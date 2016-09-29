//
//  UIViewController+message.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "UIViewController+message.h"
#import "UIAlertView+action.h"

@implementation UIViewController (message)

#pragma mark message
- (void)showMsg:(NSString *)szMsg {
    [self showTitle:nil msg:szMsg];
}

- (void)showTitle:(NSString *)szTitle msg:(NSString *)szMsg {
    [self showAskAlertTitle:szTitle message:szMsg tag:0 action:nil cancelActionTitle:@"确定" otherActionsTitles:nil];
}

- (void)showAskAlertTitle:(NSString *)title
                  message:(NSString *)message
                      tag:(NSInteger)tag
                   action:(void(^)(NSInteger alertTag, NSInteger actionIndex))block
        cancelActionTitle:(NSString *)cancelTitle
       otherActionsTitles:(NSString *)actionTitles,... {
    
    NSMutableArray *arrayTitles = [[NSMutableArray alloc] init];
    [arrayTitles addObject:cancelTitle];
    
    NSString *szActionTitle = nil;
    va_list argumentList;
    if(actionTitles) {
        [arrayTitles addObject:actionTitles];
        va_start(argumentList, actionTitles);
        szActionTitle = va_arg(argumentList, NSString *);
        while(szActionTitle) {
            [arrayTitles addObject:szActionTitle];
            szActionTitle = va_arg(argumentList, NSString *);
        }
        
        va_end(argumentList);
    }
    
    if([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        for(NSInteger i = 0; i < arrayTitles.count; i++)
        {
            NSString *string = [arrayTitles objectAtIndex:i];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:string style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if(block)
                {
                    block(tag, i);
                }
            }];
            [alertController addAction:okAction];
        }
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_8_0
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:actionTitles, nil];
        alert.alertActionBlock = block;
        [alert show];
#endif
    }
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_8_0
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.alertActionBlock)
    {
        alertView.alertActionBlock(alertView.tag, buttonIndex);
    }
}
#endif

@end
