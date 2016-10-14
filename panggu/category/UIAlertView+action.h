//
//  UIAlertView+action.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PGAlertActionBlock)(NSInteger alertTag, NSInteger actionIndex);

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
@interface UIAlertView (action)

@property(nonatomic, copy)PGAlertActionBlock alertActionBlock;

@end

#endif
