/*!
 @header 	PGBaseController.m
 @team 		Studio pangu
 @abstract	Github: https://github.com/harryouyang
 @author	Created by ouyanghua on 16/9/21.
   Copyright © 2016年 pangu. All rights reserved.
*/

#import "PGBaseController.h"
#import "PGMacroDefHeader.h"
#import "PGUIKitUtil.h"
#import "PGCustomWaitingView.h"
#import "PGRotaionWaitingView.h"

@interface PGBaseController ()
@property(nonatomic, strong)NSMutableDictionary *allErrorView;

@property(nonatomic, strong)PGWaitingView *waitingView;
@property(nonatomic, assign)BOOL bShowProgressView;
@end

@implementation PGBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavTitleAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[PGUIKitUtil systemFontOfSize:17.0]}];
    
    [self createInitData];
    [self createSubViews];
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

- (CGFloat)viewValidHeight
{
    if(self.navigationController != nil &&
       !self.navigationController.navigationBar.hidden &&
       !self.navigationController.navigationBar.translucent)
    {
        return [UIApplication sharedApplication].keyWindow.frame.size.height-CGRectGetMaxY([self navBarFrame]);
    }
    else
    {
        return [UIApplication sharedApplication].keyWindow.frame.size.height;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self freeMemory];
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

- (CGRect)navBarFrame
{
    CGRect rect = CGRectZero;
    if(self.navigationController != nil && !self.navigationController.navigationBar.hidden)
    {
        rect = self.navigationController.navigationBar.frame;
    }
    
    return rect;
}

- (CGFloat)nNavMaxY
{
    if(self.navigationController != nil &&
       !self.navigationController.navigationBar.hidden &&
       !self.navigationController.navigationBar.translucent)
    {
        return 0.0;
    }
    else
    {
        return CGRectGetMaxY([self navBarFrame]);
    }
}

#pragma mark -
- (void)createInitData
{
    
}

- (void)freeMemory
{
}

- (void)createSubViews
{
}

- (void)reloadData
{
    [self getDataFromNet];
}

- (void)getDataFromNet
{
}

#pragma mark -
- (void)createNavTitleView:(UIView *)view
{
    self.navigationItem.titleView = view;
}

- (void)createNavLeftMenu:(id)left
{
    if(left == nil)
        return;
    
    if([left isKindOfClass:[NSString class]])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 40, 30);
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:left forState:UIControlStateNormal];
        btn.titleLabel.font = [PGUIKitUtil systemFontOfSize:14];
        [btn addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }
    else if([left isKindOfClass:[UIImage class]])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 27, 27);
        [btn setImage:left forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }
    else if([left isKindOfClass:[UIView class]])
    {
        UIView *view = (UIView *)left;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
        [btn addSubview:view];
        [btn addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = item;
    }
}

- (void)leftItemClicked:(id)sender
{
}

- (void)removeNavRightMenu
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)createNavRightMenu:(id)right
{
    if(right == nil)
        return;
    
    if([right isKindOfClass:[NSString class]])
    {
        UIFont *font = [PGUIKitUtil systemFontOfSize:14];
        CGSize size = [(NSString *)right sizeWithAttributes:@{NSFontAttributeName:font}];
        float btnWidth = MAX(floorf(size.width)+1, 40.0);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, btnWidth, 30);
        [btn setTitle:right forState:UIControlStateNormal];
        btn.titleLabel.font = font;
        [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
    }
    else if([right isKindOfClass:[UIImage class]])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 27, 27);
        [btn setImage:right forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
    }
    else if([right isKindOfClass:[UIView class]])
    {
        UIView *view = (UIView *)right;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, view.bounds.size.width, view.bounds.size.height);
        [btn addSubview:view];
        [btn addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (void)rightItemClicked:(id)sender
{
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

#pragma mark waitting Indicator
- (void)showWaitingView:(NSString *)text {
    [self showWaitingView:text viewStyle:EWaitingViewStyle_Custom];
}

- (void)showWaitingView:(NSString *)text viewStyle:(PGWaitingViewStyle)style {
    if(self.waitingView == nil) {
        if(style == EWaitingViewStyle_Rotation) {
            self.waitingView = [[PGRotaionWaitingView alloc] initWithFrame:CGRectMake(0, 0, PGHeightWith1080(280), PGHeightWith1080(280))];
        } else {
            self.waitingView = [[PGCustomWaitingView alloc] initBgColor:UIColorFromRGBA(0x858585, 0.8) apla:1.0 font:nil textColor:nil activeColor:[UIColor whiteColor]];
            self.waitingView.layer.cornerRadius = 5.0;
        }
    }
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:self.waitingView];
    
    [self.view addSubview:bgView];
    
    self.bShowProgressView = YES;
    
    [self.waitingView showText:text];
    self.waitingView.center = self.waitingView.superview.center;
}

- (void)hideWaitingView {
    if(self.waitingView) {
        [self.waitingView.superview removeFromSuperview];
        self.bShowProgressView = NO;
    }
}

@end



