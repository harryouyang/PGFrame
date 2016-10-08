//
//  PGWebBaseController.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseController.h"

@interface PGWebBaseController : PGBaseController
@property(nonatomic, strong)UIWebView *webView;
/*
 webView加载完成后会回调此block
 */
@property(nonatomic, copy)void(^webViewDidFinishLoadBlock)(UIWebView *webview);

- (id)initWithTitle:(NSString *)title;

- (void)loadWebRequestWithURLString:(NSString *)urlString home:(NSString *)homeUrl;

- (void)loadWebRequestWithHtmlString:(NSString *)htmlString;

@end
