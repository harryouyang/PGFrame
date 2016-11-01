//
//  PGHttpClient.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGHttpClient.h"
#import "PGEncrypt.h"
#import "PGResultObject.h"
#import "NSDictionary+parse.h"
#import "AFNetworking.h"
#import "PGErrorCode.h"
#import "PGMacroDefHeader.h"

@interface PGHttpClient ()
@property(nonatomic, strong)NSMutableDictionary *requestParam;
@property(nonatomic, strong)NSURLSessionDataTask *sessionTask;
@property(nonatomic, strong)NSURLSessionDownloadTask *downloadSessionTask;
@end

@implementation PGHttpClient

- (instancetype)initWithType:(PGApiType)type requestParam:(NSDictionary *)dicParam
{
    if(self = [super init])
    {
        _apiType = type;
        _requestMethod = @"POST";
        NSString *szVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        _requestParam = [[NSMutableDictionary alloc] initWithDictionary:@{@"app_id":@"xxxxxx",
                                                                          @"app_version": szVersion,
                                                                          @"time":[NSString stringWithFormat:@"%0.0f",[NSDate date].timeIntervalSince1970]}];
        [_requestParam addEntriesFromDictionary:dicParam];
    }
    return self;
}

- (void)startRequest
{
    NSString *sign = [PGEncrypt createSignWith:self.requestParam];
    [self.requestParam setObject:sign forKey:@"sign"];
    
    NSString *urlString = [PGAPI urlStringWithType:self.apiType];
    
    //以下代码使用AFNetWorking 3.0进行数据请求。
    
    AFHTTPSessionManager *manager = [PGHttpClient shareSessionManager];
    manager.requestSerializer.timeoutInterval = 30;
    __weak PGHttpClient *weakSelf = self;
    
    self.sessionTask = [manager POST:urlString parameters:self.requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *szStr =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        PGHttpClient *strongSelf = weakSelf;
        [strongSelf parseData:szStr];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        PRLog("\n====================================================\n requestUrl: %s \n requestParam: \n %s \n\n====>ResposeData:(%s) \n%s\n====================================================\n",[urlString cStringUsingEncoding:NSUTF8StringEncoding], [[strongSelf.requestParam description] UTF8String], [@(strongSelf.apiType).stringValue cStringUsingEncoding:NSUTF8StringEncoding], [szStr cStringUsingEncoding:NSUTF8StringEncoding]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PGResultObject *resultObj = [[PGResultObject alloc] init];
        resultObj.nCode = error.code;
        
        if(error.code == CODE_REQUEST_TIMEROUT) //请求超时
        {
            resultObj.szErrorDes = @"请求超时";
        }
        else if (error.code == CODE_NETWORK_ERROR)
        {
            resultObj.szErrorDes = @"当前网络异常，请稍后再试。";
        }
        else
        {
            resultObj.szErrorDes = @"服务器繁忙,请稍后候再试。";//[error localizedDescription];
        }
        
        PGHttpClient *strongSelf = weakSelf;
        
        resultObj.extendParam = strongSelf.extendParam;
        if(strongSelf.delegate)
        {
            [strongSelf.delegate dataRequestFailed:resultObj client:strongSelf];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        PRLog("\n====================================================\n requestUrl: %s \n requestParam: \n %s \n\n====>ResposeData:(%s) \n%s\n====================================================\n",[urlString cStringUsingEncoding:NSUTF8StringEncoding], [[strongSelf.requestParam description] UTF8String], [@(strongSelf.apiType).stringValue cStringUsingEncoding:NSUTF8StringEncoding], [[error description] cStringUsingEncoding:NSUTF8StringEncoding]);
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)parseData:(NSString *)szString
{
    NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:[szString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    PGResultObject *resultObj = [self parseDataWithResponseObject:dicInfo];
    
    if(resultObj.nCode == CODE_NO_ERROR)
    {
        if(self.delegate)
        {
            [self.delegate dataRequestSuccess:resultObj client:self];
        }
    }
    else
    {
        if(self.delegate)
        {
            [self.delegate dataRequestFailed:resultObj client:self];
        }
    }
}

- (void)cancelRequest
{
    if(self.sessionTask)
    {
        [self.sessionTask cancel];
    }
    
    if(self.downloadSessionTask)
    {
        [self.downloadSessionTask cancel];
    }
}

- (id)parseDataWithResponseObject:(id)responseObject
{
    PGResultObject *resultObj = [[PGResultObject alloc] init];
    resultObj.extendParam = self.extendParam;
    if([responseObject isEqual:[NSNull null]] || responseObject == nil)
    {
        resultObj.nCode = CODE_SERVICE_ERROR;
        resultObj.szErrorDes = @"服务器异常，请稍后重试。";
        return resultObj;
    }
    else
    {
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        resultObj.nCode = [[dicResponse objectForKey:@"err_code" type:EDictionTypeInteger] integerValue];
        resultObj.szErrorDes = [dicResponse objectForKey:@"err_msg" type:EDictionTypeNSString];
        
        id data = [dicResponse objectForKey:@"data"];
        
        if(resultObj.nCode == CODE_NO_ERROR)
        {
            [PGAPI parseDataWithType:self.apiType data:data];
        }
        
        return resultObj;
    }
    
}

- (void)startPostImageFileData
{
    NSString *sign = [PGEncrypt createSignWith:self.requestParam];
    [self.requestParam setObject:sign forKey:@"sign"];
    
    NSString *urlString = [PGAPI urlStringWithType:self.apiType];
    
    AFHTTPSessionManager *manager = [PGHttpClient shareSessionManager];
    manager.requestSerializer.timeoutInterval = 30;
    __weak PGHttpClient *weakSelf = self;
    
    self.sessionTask = [manager POST:urlString parameters:self.requestParam constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if(weakSelf.fileData != nil)
        {
            [formData appendPartWithFileData:weakSelf.fileData name:@"file" fileName:@"file.png" mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        PGLog(@"%@,,,%@",@(uploadProgress.totalUnitCount).stringValue, @(uploadProgress.completedUnitCount).stringValue);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *szStr =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        PGHttpClient *strongSelf = weakSelf;
        [strongSelf parseData:szStr];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PGResultObject *resultObj = [[PGResultObject alloc] init];
        resultObj.nCode = error.code;
        
        if(error.code == CODE_REQUEST_TIMEROUT) //请求超时
        {
            resultObj.szErrorDes = @"请求超时";
        }
        else if (error.code == CODE_NETWORK_ERROR)
        {
            resultObj.szErrorDes = @"当前网络异常，请稍后再试。";
        }
        else
        {
            resultObj.szErrorDes = @"服务器繁忙,请稍后候再试。";//[error localizedDescription];
        }
        
        PGHttpClient *strongSelf = weakSelf;
        
        resultObj.extendParam = strongSelf.extendParam;
        if(strongSelf.delegate)
        {
            [strongSelf.delegate dataRequestFailed:resultObj client:strongSelf];
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)startDownload:(NSString *)fileUrl local:(NSString *)localPath
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:fileUrl]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    __weak PGHttpClient *weakSelf = self;
    self.downloadSessionTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        __typeof__(weakSelf) strongSelf = weakSelf;
        if(strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(downloadProgress:client:)])
        {
            [strongSelf.delegate downloadProgress:downloadProgress client:strongSelf];
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:localPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        PGResultObject *resultObj = [[PGResultObject alloc] init];
        resultObj.nCode = error.code;
        
        PGHttpClient *strongSelf = weakSelf;
        if(error != nil)
        {
            if(error.code == CODE_REQUEST_TIMEROUT) //请求超时
            {
                resultObj.szErrorDes = @"请求超时";
            }
            else if (error.code == CODE_NETWORK_ERROR)
            {
                resultObj.szErrorDes = @"当前网络异常，请稍后再试。";
            }
            else
            {
                resultObj.szErrorDes = @"服务器繁忙,请稍后候再试。";//[error localizedDescription];
            }
            
            if(strongSelf.delegate)
            {
                [strongSelf.delegate dataRequestFailed:resultObj client:strongSelf];
            }
        }
        else
        {
            resultObj.nCode = CODE_NO_ERROR;
            resultObj.szErrorDes = @"操作成功";
            
            if(strongSelf.delegate)
            {
                [strongSelf.delegate dataRequestSuccess:resultObj client:strongSelf];
            }
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.downloadSessionTask resume];
}

#pragma mark - 
/*
 使用AFNetworking 3.0
 */
+ (AFHTTPSessionManager *)shareSessionManager
{
    static AFHTTPSessionManager *s_httpSessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_httpSessionManager = [AFHTTPSessionManager manager];
        
        AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
        requestSerializer.timeoutInterval = 30;
        s_httpSessionManager.requestSerializer = requestSerializer;
        
        AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
        [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"application/x-javascript", @"text/plain", nil]];
        s_httpSessionManager.responseSerializer = responseSerializer;
    });
    
    return s_httpSessionManager;
}

@end
