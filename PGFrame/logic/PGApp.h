//
//  PGApp.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGApp : NSObject

/*
 设置NavBar属性
 */
+ (void)configAppNavBar;

/*
 获取App Window的最底层ViewController
 */
+ (UIViewController *)appRootController;

/*
 添加任务到主线程
 */
+ (void)asyncOnMainQueue:(dispatch_block_t)block;

@end
