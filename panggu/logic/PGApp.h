//
//  PGApp.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGApp : NSObject

+ (void)configAppNavBar;

+ (UIViewController *)appRootController;

+ (void)asyncOnMainQueue:(dispatch_block_t)block;

@end
