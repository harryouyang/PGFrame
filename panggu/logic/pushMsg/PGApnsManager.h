//
//  PGApnsManager.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PGApnsManager : NSObject

+ (void)registerPush:(NSDictionary *)launchOptions;

+ (void)registerDeviceToken:(NSData *)deviceToken;

+ (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

@end
