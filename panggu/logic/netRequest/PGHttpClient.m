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

@interface PGHttpClient ()
@property(nonatomic, strong)NSMutableDictionary *requestParam;
@property(nonatomic, strong)NSURLSessionDataTask *sessionTask;
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
    
//    NSString *urlString = [PGAPI urlStringWithType:self.apiType];
    
    //以下代码使用AFNetWorking 3.0进行数据请求。
    /*
    UCHTTPSessionManager *manager = [PGHttpClient shareSessionManager];
    manager.requestSerializer.timeoutInterval = 30;
    __weak PGHttpClient *weakSelf = self;
    
    self.sessionTask = [manager POST:urlString parameters:self.requestParam progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *szStr =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        PGHttpClient *strongSelf = weakSelf;
        [strongSelf parseData:szStr];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        PGResultObject *resultObj = [[PGResultObject alloc] init];
        resultObj.nCode = error.code;
        
        if(error.code == -1001) //请求超时
        {
            resultObj.szErrorDes = @"请求超时";
        }
        else if (error.code == -1009)
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
     */
}

- (void)parseData:(NSString *)szString
{
    NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:[szString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    
    PGResultObject *resultObj = [self parseDataWithResponseObject:dicInfo];
    
    if(resultObj.nCode == 0)
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
}

- (id)parseDataWithResponseObject:(id)responseObject
{
    PGResultObject *resultObj = [[PGResultObject alloc] init];
    resultObj.extendParam = self.extendParam;
    if([responseObject isEqual:[NSNull null]] || responseObject == nil)
    {
        resultObj.nCode = -1002;
        resultObj.szErrorDes = @"服务器异常，请稍后重试。";
        return resultObj;
    }
    else
    {
        NSDictionary *dicResponse = (NSDictionary *)responseObject;
        resultObj.nCode = [[dicResponse objectForKey:@"err_code" type:EDictionTypeInteger] integerValue];
        resultObj.szErrorDes = [dicResponse objectForKey:@"err_msg" type:EDictionTypeNSString];
        
        id data = [dicResponse objectForKey:@"data"];
        
        if(resultObj.nCode == 0)
        {
            [PGAPI parseDataWithType:self.apiType data:data];
        }
        
        return resultObj;
    }
    
}

#pragma mark - 
/*
 使用AFNetworking 3.0
 */
/*
+ (UCHTTPSessionManager *)shareSessionManager
{
    static UCHTTPSessionManager *s_httpSessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_httpSessionManager = [UCHTTPSessionManager manager];
        
        UCHTTPRequestSerializer *requestSerializer = [[UCHTTPRequestSerializer alloc] init];
        requestSerializer.timeoutInterval = 30;
        s_httpSessionManager.requestSerializer = requestSerializer;
        
        UCHTTPResponseSerializer *responseSerializer = [UCHTTPResponseSerializer serializer];
        [responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript", @"application/x-javascript", @"text/plain", nil]];
        s_httpSessionManager.responseSerializer = responseSerializer;
    });
    
    return s_httpSessionManager;
}
 */

@end
