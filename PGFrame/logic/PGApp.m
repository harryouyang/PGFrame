//
//  PGApp.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGApp.h"
#import "PGConfig.h"
#import "UIImage+PGImage.h"
#import "PGMacroDefHeader.h"

@implementation PGApp

+ (void)configAppNavBar
{
    UIImage *image = [UIImage createImageWithColor:Color_For_NavBarColor];
    [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBarTintColor:Color_For_NavBarColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    if(IOS8_LATER)
    {
        [UINavigationBar appearance].translucent = NO;
    }
    
    UIImage *backImage = [UIImage imageNamed:@"icon_return"];
    backImage = [backImage scaledImageToSize:CGSizeMake(27, 27)];
    backImage = [[backImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 7, 4, 0)];
    [[UINavigationBar appearance] setBackIndicatorImage:backImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backImage];
    
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(NSIntegerMin, NSIntegerMin)
                                                         forBarMetrics:UIBarMetricsDefault];
}

+ (UIViewController *)appRootController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootController = window.rootViewController;
    
    if(rootController == nil)
    {
        NSArray *array = [UIApplication sharedApplication].windows;
        UIWindow *topWindow = [array objectAtIndex:0];
        for(UIView *view in topWindow.subviews)
        {
            if([view.nextResponder isKindOfClass:[UIViewController class]] == YES)
            {
                rootController = (UIViewController *)view.nextResponder;
                break;
            }
        }
    }
    
    return rootController;
}

+ (void)asyncOnMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
}

@end
