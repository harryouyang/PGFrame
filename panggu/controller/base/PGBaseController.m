/*!
 @header 	PGBaseController.m
 @team 		Studio pangu
 @abstract	Github: https://github.com/harryouyang
 @author	Created by ouyanghua on 16/9/21.
   Copyright © 2016年 pangu. All rights reserved.
*/

#import "PGBaseController.h"
#import "PGMacroDefHeader.h"
#import "UIAlertView+action.h"
#import "PGUIKitUtil.h"

@interface PGBaseController ()
@property(nonatomic, strong)NSMutableDictionary *allErrorView;
@end

@implementation PGBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavTitleAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[PGUIKitUtil systemFontOfSize:17.0]}];
}

- (NSMutableDictionary *)allErrorView {
    if(_allErrorView == nil) {
        _allErrorView = [[NSMutableDictionary alloc] init];
    }
    return _allErrorView;
}

- (CGFloat)viewWidth {
    return self.view.frame.size.width;
}

- (CGFloat)viewHeight {
    return self.view.frame.size.height;
}

#pragma mark -
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark -
- (UINavigationBar *)navBar
{
    UINavigationBar *navbar = nil;
    if(self.navigationController != nil)
    {
        navbar = self.navigationController.navigationBar;
    }
    
    return navbar;
}

- (void)setNavTitleAttributes:(NSDictionary *)dicAttributes
{
    UINavigationBar *navBar = [self navBar];
    if(navBar)
    {
        [navBar setTitleTextAttributes:dicAttributes];
    }
}

@end

/*
 viewController推进推出的简易操作
 */
#pragma mark -
@implementation PGBaseController (Navigation)

- (void)pushNewViewController:(UIViewController *)newViewController {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:newViewController animated:YES];
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if(viewController == nil) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController popToViewController:viewController animated:YES];
    }
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

/*
 消息提示，错误提示
 */
#pragma mark -
@implementation PGBaseController (errorMsgView)
#pragma mark errorView
- (void)showErrorView:(UIView *)pView flag:(NSString *)viewFlag errorView:(UIView * (^)(void))errorView {
    if(errorView != nil) {
        UIView *view = errorView();
        if(view != nil) {
            NSString *szControllerClassName = NSStringFromClass([self class]);
            NSString *szClassName = NSStringFromClass([pView class]);
            NSString *szTag = [NSString stringWithFormat:@"%@_%@",szControllerClassName, szClassName];
            if(viewFlag != nil && viewFlag.length > 0) {
                szTag = [NSString stringWithFormat:@"%@_%@_%@",szControllerClassName, szClassName, viewFlag];
            }
            
            [self hideErrorView:szTag];
            [pView addSubview:view];
            [self.allErrorView setObject:view forKey:szTag];
        }
    }
    
}

- (void)hideErrorView:(UIView *)pView flag:(NSString *)viewFlag {
    NSString *szControllerClassName = NSStringFromClass([self class]);
    NSString *szClassName = NSStringFromClass([pView class]);
    NSString *szTag = [NSString stringWithFormat:@"%@_%@",szControllerClassName, szClassName];
    if(viewFlag != nil && viewFlag.length > 0) {
        szTag = [NSString stringWithFormat:@"%@_%@_%@",szControllerClassName, szClassName, viewFlag];
    }
    
    [self hideErrorView:szTag];
}

- (void)hideErrorView:(NSString *)viewFlag {
    if(viewFlag == nil || viewFlag.length < 1) {
        return;
    }
    
    UIView *oldView = [self.allErrorView objectForKey:viewFlag];
    if(oldView != nil) {
        [oldView removeFromSuperview];
        [self.allErrorView removeObjectForKey:viewFlag];
    }
}

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
    
    if(IOS8_LATER) {
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

#pragma mark waitting Indicator
- (void)showWaitingView:(NSString *)text {
    
}

- (void)endWaitingView {
    
}

@end



