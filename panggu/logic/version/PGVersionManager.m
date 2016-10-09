//
//  PGVersionManager.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/9.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGVersionManager.h"
#import "NSDate+PGDateExtend.h"
#import "PGRequestManager.h"
#import "PGVersionObject.h"
#import "PGApp.h"
#import "UIViewController+message.h"
#import "PGCacheManager.h"

#define VERSION_RETRY_COUNT 5

@interface PGVersionManager ()<PGApiDelegate>
/*
 上次检测更新的时间
 */
@property(nonatomic, strong)NSDate *lastCheckDate;
/*
 是否有强制更新
 */
@property(nonatomic, assign)BOOL needUpdate;
/*
 检测版本失败重试次数
 */
@property(nonatomic, assign)NSInteger nRetryCount;

@end

@implementation PGVersionManager

+ (PGVersionManager *)shareInstance
{
    static PGVersionManager *s_versionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_versionManager = [[PGVersionManager alloc] init];
    });
    return s_versionManager;
}

- (id)init
{
    if(self = [super init])
    {
        self.needUpdate = NO;
        self.lastCheckDate = nil;
        self.nRetryCount = VERSION_RETRY_COUNT;
    }
    return self;
}

+ (void)checkVersion
{
    [PGVersionManager shareInstance].nRetryCount = VERSION_RETRY_COUNT;
    if([PGVersionManager shareInstance].needUpdate ||
       [PGVersionManager shareInstance].lastCheckDate == nil ||
       [NSDate numDayFromDate:[PGVersionManager shareInstance].lastCheckDate toDate:[NSDate date]] >= 1)
    {
        [[PGVersionManager shareInstance] getVersionInfo];
    }
}

- (void)getVersionInfo
{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [PGRequestManager startPostClient:API_TYPE_VERSION_CHECK param:@{@"app_version":version} target:self extendParam:nil];
}

#pragma mark -
- (void)dataRequestFinish:(PGResultObject *)resultObj apiType:(PGApiType)apiType
{
    if(resultObj.nCode == 0)
    {
        self.lastCheckDate = [NSDate date];
        PGVersionObject *versionObj = (PGVersionObject *)resultObj.dataObject;
        
        if(versionObj.updateType == VERION_UPDATE_TYPE_OPTIONAL)
        {
            [[PGApp appRootController] showAskAlertTitle:[NSString stringWithFormat:@"发现新版本:%@",versionObj.szVersion] message:versionObj.szDesc tag:1000 action:^(NSInteger alertTag, NSInteger actionIndex) {
                if(actionIndex == 0) {
                    [PGCacheManager clearCacheData:^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionObj.szUrl]];
                        });
                    }];
                }
            } cancelActionTitle:@"更新" otherActionsTitles:@"取消",nil];
        }
        else if(versionObj.updateType == VERION_UPDATE_TYPE_FORCE)
        {
            [[PGApp appRootController] showAskAlertTitle:[NSString stringWithFormat:@"发现新版本:%@",versionObj.szVersion] message:versionObj.szDesc tag:1000 action:^(NSInteger alertTag, NSInteger actionIndex) {
                if(actionIndex == 0) {
                    [PGCacheManager clearCacheData:^{
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionObj.szUrl]];
                        });
                    }];
                }
            } cancelActionTitle:@"更新" otherActionsTitles:nil];
        }
    }
    else
    {
        //失败重试
        if(self.nRetryCount > 0)
        {
            self.nRetryCount -= 1;
            [self getVersionInfo];
        }
    }
}

@end
