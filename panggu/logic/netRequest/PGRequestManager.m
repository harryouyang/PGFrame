//
//  PGRequestManager.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGRequestManager.h"
#import "PGHttpClient.h"

@interface PGRequestManager ()<PGApiDelegate>
@property(atomic, strong)NSMutableDictionary *allClient;
@end

static PGRequestManager *s_requestManager = nil;

@implementation PGRequestManager

- (void)dealloc
{
    [self cancelAllClient];
}

+ (PGRequestManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_requestManager = [[PGRequestManager alloc] init];
        s_requestManager.allClient = [[NSMutableDictionary alloc] init];
    });
    
    return s_requestManager;
}

- (void)addClient:(PGHttpClient *)client target:(id)target tag:(NSString *)tag
{
    if(client == nil)
    {
        return;
    }
    
    NSString *szClassName = NSStringFromClass([target class]);
    NSString *szTag = szClassName;
    if(tag != nil && tag.length > 0)
    {
        szTag = [NSString stringWithFormat:@"%@_%@",szClassName, tag];
    }
    
    [self cancelClient:szTag];
    [self.allClient setObject:client forKey:szTag];
}

+ (void)cancelClientWithTarget:(id)target tag:(NSString *)tag
{
    NSString *szClassName = NSStringFromClass([target class]);
    NSString *szTag = szClassName;
    if(tag != nil && tag.length > 0)
    {
        szTag = [NSString stringWithFormat:@"%@_%@",szClassName, tag];
    }
    
    [[PGRequestManager shareInstance] cancelClient:szTag];
}

- (void)cancelClient:(NSString *)szTag
{
    if(szTag == nil || szTag.length < 1)
    {
        return;
    }
    
    PGHttpClient *oldClient = [self.allClient objectForKey:szTag];
    if(oldClient != nil)
    {
        [oldClient cancelRequest];
        [self.allClient removeObjectForKey:szTag];
    }
}

- (void)cancelAllClient
{
    NSArray *tagArray = self.allClient.allValues;
    for(NSString *string in tagArray)
    {
        [self cancelClient:string];
    }
}

//普通接口请求
+ (void)startPostClient:(PGApiType)type param:(NSDictionary *)param target:(id<PGApiDelegate>)target tag:(NSString *)tag;
{
    [[PGRequestManager shareInstance] startClient:@"POST" type:type param:param target:target tag:tag];
}

+ (void)startGetClient:(PGApiType)type param:(NSDictionary *)param target:(id<PGApiDelegate>)target tag:(NSString *)tag
{
    [[PGRequestManager shareInstance] startClient:@"GET" type:type param:param target:target tag:tag];
}

- (void)startClient:(NSString *)method type:(PGApiType)type param:(NSDictionary *)param target:(id)target tag:(NSString *)tag
{
    PGHttpClient *client = [[PGHttpClient alloc] initWithType:type requestParam:param];
    client.requestMethod = method;
    client.apiDelegate = target;
    
    if(target != nil)
        [self addClient:client target:target tag:tag];
    else
        [self addClient:client target:self tag:tag];
    
    [client startRequest];
}

#pragma mark -
- (void)dataRequestSuccess:(PGResultObject *)resultObj
{
}

- (void)dataRequestFailed:(PGResultObject *)resultObj
{
}

@end
