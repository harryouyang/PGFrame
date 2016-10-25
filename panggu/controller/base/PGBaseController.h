/*!
 @header 	PGBaseController.h
 @team 		Studio pangu
 @abstract	Github: https://github.com/harryouyang
 @author	Created by ouyanghua on 16/9/21.
   Copyright © 2016年 pangu. All rights reserved.
*/

#import <UIKit/UIKit.h>
#import "PGUIKitUtil.h"
#import "UIViewController+message.h"
#import "PGRequestManager.h"
#import "PGErrorCode.h"

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
/*
 controller中View的高度 不包括Navbar
 */
@property(nonatomic, assign, readonly)CGFloat viewValidHeight;
/*
 navbar 最大的Y值
 */
@property(nonatomic, assign, readonly)CGFloat nNavMaxY;

- (UINavigationBar *)navBar;
- (void)setNavTitleAttributes:(NSDictionary *)dicAttributes;

/*
 初始化相应的数据
 */
- (void)createInitData;

/*
 创建相应的子视图
 */
- (void)createSubViews;

/*
 创建子视图完成
 */
- (void)didCreateSubViews;

/*
 重新加载
 */
- (void)reloadData;

/*
 加载网络接口数据
 */
- (void)getDataFromNet;

/*
 释放内存空间
 */
- (void)freeMemory;

#pragma mark -
/*
 添加navBar标题视图
 */
- (void)createNavTitleView:(UIView *)view;
/*
 添加navBar左侧菜单
 */
- (void)createNavLeftMenu:(id)left;
/*
 移除navBar右侧菜单
 */
- (void)removeNavRightMenu;
/*
 添加navBar右侧菜单
 */
- (void)createNavRightMenu:(id)right;

- (void)leftItemClicked:(id)sender;
- (void)rightItemClicked:(id)sender;

#pragma mark -
- (void)asyncOnMainQueue:(dispatch_block_t)block;

#pragma mark keyboard
@property(nonatomic, assign)BOOL bkeyboardVisible;
@property(nonatomic, assign)CGRect keyboardFrame;
@property(nonatomic, assign)float nKboffset;
@property(nonatomic, assign)CGPoint point;
@property(nonatomic, assign)float noffset;

- (void)addKeyboardObserver;

- (void)removeKeyboardObserver;

- (BOOL)keyboardWillShow:(NSNotification *)noti;

- (BOOL)keyboardWillHide:(NSNotification *)noti;

- (BOOL)keyboardFrameWillChange:(NSNotification*)noti;

#pragma mark request data
- (void)startRequestData:(PGApiType)apiType param:(NSDictionary *)param;
- (void)startRequestData:(PGApiType)apiType param:(NSDictionary *)param extendParma:(NSObject *)extendParam;

- (void)startUploadFileData:(PGApiType)apiType data:(NSData *)data param:(NSDictionary *)param;
- (void)startUploadFileData:(PGApiType)apiType data:(NSData *)data param:(NSDictionary *)param extendParma:(NSObject *)extendParam;

- (void)startDownload:(NSString *)fileUrl local:(NSString *)localPath;
- (void)startDownload:(NSString *)fileUrl local:(NSString *)localPath tag:(NSUInteger)tag;
- (void)startDownload:(NSString *)fileUrl local:(NSString *)localPath tag:(NSUInteger)tag extendParma:(NSObject *)extendParam;
- (void)requestDataFinish:(PGResultObject *)resultObj apiType:(PGApiType)apiType;

#pragma mark -
- (void)addSimpleTapGesture:(id<UIGestureRecognizerDelegate>)gestureDelegate;
- (void)viewhandleSingleTap:(UITapGestureRecognizer *)gesture;

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

#pragma mark waitting Indicator
- (void)showWaitingView:(NSString *)text;
- (void)showWaitingView:(NSString *)text viewStyle:(PGWaitingViewStyle)style;
- (void)hideWaitingView;

@end







