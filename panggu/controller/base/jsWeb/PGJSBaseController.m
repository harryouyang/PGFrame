//
//  PGJSBaseController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGJSBaseController.h"
#import "PGApp.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "PGMacroDefHeader.h"

@interface PGJSBaseController ()
@property(nonatomic, strong)JSContext *jsContext;
@end

@implementation PGJSBaseController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.jsObj = [[PGJSObject alloc] init];
    self.jsObj.jsDelegate = self;
}

- (void)createInitData
{
    [super createInitData];
    
    WEAKSELF
    self.webViewDidFinishLoadBlock = ^(UIWebView *webView) {
        weakSelf.jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
        weakSelf.jsContext[@"UCJSObject"] = weakSelf.jsObj;
    };
}

#pragma mark -
- (void)jsReponse:(UCJSType)type params:(NSObject *)params
{
    NSString *str = [NSString stringWithFormat:@"type: %@, param: %@", @(type).stringValue, params];
    NSLog(@"====> %@",str);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMsg:str];
    });
}

- (void)jsErrorMessage:(NSString *)message
{
}

@end
