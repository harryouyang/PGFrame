//
//  PGApnsManager.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGApnsManager.h"
#import "PGMessageObject.h"
#import <UIKit/UIKit.h>
#import "PGRequestManager.h"
#import "PGContext.h"
#import "UIViewController+message.h"
#import "PGApp.h"
#import "PGNavigationController.h"
#import "PGWebBaseController.h"

//极光推送相关参数
static NSString *appKey = @"";
static NSString *channel = @"AppStore";

//是否是生产环境
//static BOOL isProduction = TRUE;

@interface PGApnsManager ()
@property(nonatomic, strong)PGMessageObject *msgObj;
@property(nonatomic, strong)NSString *pushToken;

- (void)submitDevicetoken:(NSString *)devicetoken registerID:(NSString *)registerID;

@end

@implementation PGApnsManager

static PGApnsManager *s_apnsManager = nil;

+ (PGApnsManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_apnsManager = [[PGApnsManager alloc] init];
        s_apnsManager.msgObj = [[PGMessageObject alloc] init];
        s_apnsManager.pushToken = @"";
        
        //使用了极光推送服务
//        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//        [defaultCenter addObserver:s_apnsManager
//                          selector:@selector(networkDidRegister:)
//                              name:kJPFNetworkDidLoginNotification
//                            object:nil];
    });
    return s_apnsManager;
}

+ (void)registerPush:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
    } else {
        //categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
    }
    
//    [JPUSHService setLogOFF];
//    
//    [JPUSHService setupWithOption:launchOptions
//                           appKey:appKey
//                          channel:channel
//                 apsForProduction:isProduction];
    
    //判断是否由远程消息通知触发应用程序启动
    if (launchOptions) {
        //获取应用程序消息通知标记数（即小红圈中的数字）
        NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
        if (badge > 0) {
            //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
            badge--;
            //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
            [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
            NSDictionary *pushInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
            
            if(pushInfo)
            {
                [PGApnsManager handleRemoteNotification:pushInfo];
            }
        }
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

+ (void)registerDeviceToken:(NSData *)deviceToken
{
    [PGApnsManager shareInstance].pushToken = [[[[deviceToken description]
                        stringByReplacingOccurrencesOfString:@"<" withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)networkDidRegister:(NSNotification *)notification
{
//    NSString *registrationID = [JPUSHService registrationID];
//    if(registrationID == nil)
//    {
//        registrationID = [[notification userInfo] valueForKey:@"RegistrationID"];
//        if(registrationID == nil)
//        {
//            registrationID = @"";
//        }
//    }
//    
//    __weak PGApnsManager *weakSelf = self;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [[PGApnsManager shareInstance] submitDevicetoken:weakSelf.pushToken registerID:registrationID];
//    });
}

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo
{
    // 处理推送消息
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
//    [JPUSHService handleRemoteNotification:remoteInfo];
//    [JPUSHService resetBadge];
    
    [[PGApnsManager shareInstance] parseRemoteInfo:remoteInfo];
    
    PGMessageObject *msgObj = [PGApnsManager shareInstance].msgObj;
    if(msgObj.msgUrl && msgObj.msgUrl.length > 0)
    {
        [[PGApp appRootController] showAskAlertTitle:nil message:msgObj.msgContent tag:1000 action:^(NSInteger alertTag, NSInteger actionIndex) {
            if(actionIndex == 1) {
                [PGApnsManager openMsg:msgObj];
            }
        } cancelActionTitle:@"关闭" otherActionsTitles:@"查看",nil];
    }
    else
    {
        [[PGApp appRootController] showMsg:msgObj.msgContent];
    }
}

- (void)parseRemoteInfo:(NSDictionary *)remoteInfo
{
    NSDictionary *dic = [remoteInfo objectForKey:@"aps"];
    NSString *msg = [dic objectForKey:@"alert"];
    
    self.msgObj.msgContent = msg;
    NSString *msgType = [remoteInfo objectForKey:@"msg_type"];
    self.msgObj.msgType = [msgType integerValue];
    self.msgObj.msgUrl = [remoteInfo objectForKey:@"msg_url"];
    self.msgObj.msgTitle = [remoteInfo objectForKey:@"msg_title"];
    self.msgObj.msgContent = [remoteInfo objectForKey:@"msg_content"];
    
}

#pragma mark - private
- (void)submitDevicetoken:(NSString *)devicetoken registerID:(NSString *)registerID
{
    //    NSLog(@"deviceToken:%@ , registrationID:%@", devicetoken, registerID);
    //这里应将devicetoken registrationID 发送到服务器端
    
    [PGRequestManager startPostClient:API_TYPE_APNS_DEVICE_TOKEN param:@{@"device_token":devicetoken,@"third_id":registerID,@"token":[PGContext shareInstance].userToken} target:nil extendParam:nil];
}

+ (void)openMsg:(PGMessageObject *)msgObj
{
    PGWebBaseController *control = [[PGWebBaseController alloc] initWithTitle:msgObj.msgTitle];
    [control loadWebRequestWithURLString:msgObj.msgUrl home:msgObj.msgUrl];
    PGNavigationController *nav = [[PGNavigationController alloc] initWithRootViewController:control];
    [[PGApp appRootController] presentViewController:nav animated:YES completion:nil];
}

@end
