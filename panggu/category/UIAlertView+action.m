//
//  UIAlertView+action.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "UIAlertView+action.h"
#import <objc/runtime.h>

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
//定义常量 必须是C语言字符串
static char *actionNameKey = "actionNameKey";
@implementation UIAlertView (action)

- (void)setAlertActionBlock:(PGAlertActionBlock)alertActionBlock
{
    objc_setAssociatedObject(self, actionNameKey, alertActionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PGAlertActionBlock)alertActionBlock
{
    return objc_getAssociatedObject(self, actionNameKey);
}

@end

#endif