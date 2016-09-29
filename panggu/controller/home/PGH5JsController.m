//
//  PGH5JsController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/29.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGH5JsController.h"

@implementation PGH5JsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self createNavRightMenu:@"测试"];
    
}

- (void)rightItemClicked:(id)sender
{
    NSString *string = [self.jsObj wakeUpNativeJSType:1 param:@"sfsfsfss"];
    [self.webView stringByEvaluatingJavaScriptFromString:string];
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

#pragma mark -
- (void)createSubViews
{
    [super createSubViews];
}

@end
