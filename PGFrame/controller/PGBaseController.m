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

#define KEYBOARDFRAMEWILLCHANGE2         @"KBWFC"

@interface PGBaseController ()<PGApiDelegate,UIGestureRecognizerDelegate>
@property(nonatomic, strong)NSMutableDictionary *allErrorView;

@property(nonatomic, strong)PGWaitingView *waitingView;
@property(nonatomic, assign)BOOL bShowProgressView;

@property(nonatomic, strong)NSMutableDictionary *apiKeyDic;

@property(nonatomic, assign)BOOL bDidSubViewCreate;
@end

@implementation PGBaseController

- (void)dealloc
{
    [self cancelTask];
}

- (void)cancelTask {
    for(NSNumber *typeNum in self.apiKeyDic.allValues)
    {
        [PGRequestManager cancelClientWithTarget:self type:typeNum.integerValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavTitleAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                  NSFontAttributeName:[PGUIKitUtil systemFontOfSize:17.0]}];
    
    [self createInitData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.bDidSubViewCreate)
    {
        [self createSubViews];
        [self didCreateSubViews];
    }
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

- (CGRect)mainFrame
{
    return [UIApplication sharedApplication].keyWindow.frame;
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
    self.bDidSubViewCreate = NO;
}

- (void)createSubViews
{
    self.bDidSubViewCreate = YES;
}

- (void)didCreateSubViews
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
- (void)asyncOnMainQueue:(dispatch_block_t)block
{
    dispatch_async(dispatch_get_main_queue(), block);
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

#pragma mark - keyboard
#pragma mark -
- (void)addKeyboardObserver
{
    if(IOS8_LATER)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue]>4)
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameWillChange:) name:KEYBOARDFRAMEWILLCHANGE2 object:nil];
    }
}

- (void)removeKeyboardObserver
{
    if(IOS8_LATER)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
        if([[[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."] objectAtIndex:0] intValue]>4)
            [[NSNotificationCenter defaultCenter] removeObserver:self name:KEYBOARDFRAMEWILLCHANGE2 object:nil];
    }
}

- (BOOL)keyboardWillShow:(NSNotification *)noti
{
    CGRect frame=[(NSValue*)[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(IOS8_LATER)
    {
        CGRect rect = [(NSValue *)[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if(rect.size.height == 0 || _bkeyboardVisible)
            return NO;
        
        _keyboardFrame = rect;
        _bkeyboardVisible = YES;
        _nKboffset = _keyboardFrame.size.height;
    }
    else
    {
        if(_bkeyboardVisible)
        {
            if(frame.size.height != _nKboffset)
                [[NSNotificationCenter defaultCenter] postNotificationName:KEYBOARDFRAMEWILLCHANGE2 object:nil userInfo:[noti userInfo]];
            return NO;
        }
        _keyboardFrame = [(NSValue *)[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        _bkeyboardVisible = YES;
        _nKboffset = _keyboardFrame.size.height;
        
    }
    
    return YES;
}

- (BOOL)keyboardWillHide:(NSNotification *)noti
{
    if(_bkeyboardVisible==NO)
        return NO;
    _bkeyboardVisible = NO;
    return YES;
}

- (BOOL)keyboardFrameWillChange:(NSNotification*)noti
{
    CGRect frame=[(NSValue*)[[noti userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if(IOS8_LATER)
    {
        if(frame.size.height != 0 && _bkeyboardVisible && CGRectEqualToRect(_keyboardFrame,frame) != YES)
        {
            _keyboardFrame = frame;
            _nKboffset = _keyboardFrame.size.height;
            return YES;
        }
    }
    else
    {
        if(CGRectEqualToRect(_keyboardFrame,frame)!=YES)
        {
            _keyboardFrame = frame;
            _nKboffset = _keyboardFrame.size.height;
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - request data
- (NSMutableDictionary *)apiKeyDic
{
    if(_apiKeyDic == nil) {
        _apiKeyDic = [[NSMutableDictionary alloc] init];
    }
    return _apiKeyDic;
}

- (void)startRequestData:(PGApiType)apiType param:(NSDictionary *)param
{
    [self startRequestData:apiType param:param isShowWaiting:YES];
}

- (void)startRequestData:(PGApiType)apiType param:(NSDictionary *)param extendParma:(NSObject *)extendParam
{
    [self startRequestData:apiType param:param extendParma:extendParam isShowWaiting:YES];
}

- (void)startRequestData:(PGApiType)apiType param:(NSDictionary *)param isShowWaiting:(BOOL)isShowWaiting
{
    [self startRequestData:apiType param:param extendParma:nil isShowWaiting:isShowWaiting];
}

- (void)startRequestData:(PGApiType)apiType param:(NSDictionary *)param extendParma:(NSObject *)extendParam isShowWaiting:(BOOL)isShowWaiting
{
    if(isShowWaiting) {
        [self showWaitingView:nil];
        self.waitingView.nShowNumCount += 1;
    }
    [self.apiKeyDic setObject:[NSNumber numberWithInteger:apiType] forKey:@(apiType).stringValue];
    [PGRequestManager startPostClient:apiType param:param target:self extendParam:extendParam];
}

- (void)startUploadFileData:(PGApiType)apiType data:(NSData *)data param:(NSDictionary *)param
{
    [self startUploadFileData:apiType data:data param:param extendParma:nil];
}

- (void)startUploadFileData:(PGApiType)apiType data:(NSData *)data param:(NSDictionary *)param extendParma:(NSObject *)extendParam
{
    [self showWaitingView:nil];
    self.waitingView.nShowNumCount += 1;
    [self.apiKeyDic setObject:[NSNumber numberWithInteger:apiType] forKey:@(apiType).stringValue];
    [PGRequestManager startFile:data PostClient:apiType param:param target:self extendParam:extendParam];
}

- (void)startDownload:(NSString *)fileUrl local:(NSString *)localPath
{
    [self startDownload:fileUrl local:localPath tag:0];
}

- (void)startDownload:(NSString *)fileUrl local:(NSString *)localPath tag:(NSUInteger)tag
{
    [self startDownload:fileUrl local:localPath tag:tag extendParma:nil];
}

- (void)startDownload:(NSString *)fileUrl local:(NSString *)localPath tag:(NSUInteger)tag extendParma:(NSObject *)extendParam
{
    NSInteger apiTag = API_TYPE_FileDownload+tag;
    [self.apiKeyDic setObject:[NSNumber numberWithInteger:apiTag] forKey:@(apiTag).stringValue];
    [PGRequestManager startDownload:apiTag url:fileUrl local:localPath target:self extendParam:extendParam];
}

- (void)dataRequestFinish:(PGResultObject *)resultObj apiType:(PGApiType)apiType
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.waitingView.nShowNumCount -= 1;
        [self hideWaitingView];
        [self requestDataFinish:resultObj apiType:apiType];
    });
}

- (void)requestDataFinish:(PGResultObject *)resultObj apiType:(PGApiType)apiType
{
}

#pragma mark -
- (void)addSimpleTapGesture:(id<UIGestureRecognizerDelegate>)gestureDelegate
{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewhandleSingleTap:)];
    singleTap.delegate = gestureDelegate;
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewhandleSingleTap:(UITapGestureRecognizer *)gesture
{
    [self.view endEditing:YES];
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
    
    if(!self.bShowProgressView)
    {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        bgView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:self.waitingView];
    
        [self.view addSubview:bgView];
    
        self.bShowProgressView = YES;
    }
    
    [self.waitingView showText:text];
    self.waitingView.center = self.waitingView.superview.center;
}

- (void)hideWaitingView {
    if(self.waitingView && self.waitingView.nShowNumCount < 1) {
        [self.waitingView.superview removeFromSuperview];
        self.bShowProgressView = NO;
    }
}

@end


