//
//  PGWebBaseController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGWebBaseController.h"
#import "PGBaseController+errorView.h"
#import "UIViewController+message.h"

@interface PGWebBaseController ()<UIWebViewDelegate>
@property(nonatomic, strong)NSURL *homeURL;
@property(nonatomic, strong)NSURL *firstURL;

@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, assign)int timeout;
@property(nonatomic, assign)int timeIndex;

@property(nonatomic, strong)NSString *szTitle;

@end

@implementation PGWebBaseController

- (id)initWithTitle:(NSString *)title
{
    if(self = [super init])
    {
        self.szTitle = title;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.szTitle;
}

- (void)createInitData
{
    [super createInitData];
    self.timeout = 15;
    self.timeIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_webView && self.firstURL != nil)
    {
        _webView.delegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:self.firstURL]];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_webView)
    {
        _webView.delegate = nil;
    }
}

- (void)createSubViews
{
    float nOriginY = self.nNavMaxY;
    self.webView.frame = CGRectMake(0, nOriginY, self.view.frame.size.width, self.view.frame.size.height-nOriginY);
    [self.view addSubview:self.webView];
}

- (UIWebView *)webView
{
    if(_webView == nil)
    {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        _webView.scrollView.bounces = NO;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _webView;
}

- (void)loadWebRequestWithURLString:(NSString *)urlString home:(NSString *)homeUrl
{
    self.homeURL = [NSURL URLWithString:homeUrl];
    self.firstURL = [NSURL URLWithString:urlString];
    if(self.webView && self.firstURL != nil)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.firstURL]];
    }
}

- (void)loadWebRequestWithHtmlString:(NSString *)htmlString
{
    if(self.webView)
    {
        [self.webView loadHTMLString:htmlString baseURL:nil];
    }
}

- (void)webloadTimeOut
{
    if(self.timeIndex < self.timeout)
    {
        self.timeIndex++;
    }
    else
    {
        [self.webView stopLoading];
    }
}

#pragma mark -
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showWaitingView:@"数据加载中"];
    [self hideDataLoadErrorView];
    self.timeIndex = 0;
    if(self.timer == nil)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(webloadTimeOut) userInfo:nil repeats:YES];
    }
    
    [self.timer fire];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideWaitingView];
    
    self.timeIndex = 0;
    if(self.timer != nil && [self.timer isValid])
    {
        [self.timer invalidate];
    }
    
    [self hideDataLoadErrorView];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '80%'"];
    
    if(self.webViewDidFinishLoadBlock)
    {
        self.webViewDidFinishLoadBlock(webView);
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideWaitingView];
    
    [self showDataLoadErrorView];
    
    self.timeIndex = 0;
    if(self.timer != nil && ![self.timer isValid])
    {
        [self.timer invalidate];
    }
}

#pragma mark -
- (void)reloadData
{
    if(self.webView && self.firstURL != nil)
    {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.firstURL]];
    }
}

- (void)errorleftMenuResponse:(id)sender
{
    if(self.webView.canGoBack)
    {
        [self.webView goBack];
    }
}

@end
