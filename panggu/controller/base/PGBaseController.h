/*!
 @header 	PGBaseController.h
 @team 		Studio pangu
 @abstract	Github: https://github.com/harryouyang
 @author	Created by ouyanghua on 16/9/21.
   Copyright © 2016年 pangu. All rights reserved.
*/

#import <UIKit/UIKit.h>

/*
 等待视图的样式类型
 */
typedef NS_ENUM(NSInteger, PGWaitingViewStyle)
{
    EWaitingViewStyle_Custom = 0,
    EWaitingViewStyle_Rotation
};

@interface PGBaseController : UIViewController

/* 
 controller中view的宽度
 */
@property(nonatomic, assign, readonly)CGFloat viewWidth;
/*
 controller中view的高度
 */
@property(nonatomic, assign, readonly)CGFloat viewHeight;

- (UINavigationBar *)navBar;
- (void)setNavTitleAttributes:(NSDictionary *)dicAttributes;

@end

/*
 viewController推进推出的简易操作
 */
@interface PGBaseController (Navigation)
- (void)pushNewViewController:(UIViewController *)newViewController;
- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popToRootViewControllerAnimated:(BOOL)animated;
@end

/*
 消息提示，错误提示
 */
@interface PGBaseController (errorMsgView)
#pragma mark errorView
- (void)showErrorView:(UIView *)pView flag:(NSString *)viewFlag errorView:(UIView * (^)(void))errorView;
- (void)hideErrorView:(UIView *)pView flag:(NSString *)viewFlag;
- (void)hideErrorView:(NSString *)viewFlag;

#pragma mark message
- (void)showMsg:(NSString *)szMsg;
- (void)showTitle:(NSString *)szTitle msg:(NSString *)szMsg;
- (void)showAskAlertTitle:(NSString *)title
                  message:(NSString *)message
                      tag:(NSInteger)tag
                   action:(void(^)(NSInteger alertTag, NSInteger actionIndex))block
        cancelActionTitle:(NSString *)cancelTitle
       otherActionsTitles:(NSString *)actionTitles,...;

#pragma mark waitting Indicator
- (void)showWaitingView:(NSString *)text;
- (void)showWaitingView:(NSString *)text viewStyle:(PGWaitingViewStyle)style;
- (void)hideWaitingView;

@end







