//
//  UIViewController+message.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (message)

#pragma mark message
- (void)showMsg:(NSString *)szMsg;
- (void)showTitle:(NSString *)szTitle msg:(NSString *)szMsg;
- (void)showAskAlertTitle:(NSString *)title
                  message:(NSString *)message
                      tag:(NSInteger)tag
                   action:(void(^)(NSInteger alertTag, NSInteger actionIndex))block
        cancelActionTitle:(NSString *)cancelTitle
       otherActionsTitles:(NSString *)actionTitles,...;

@end
