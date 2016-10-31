//
//  PGNetController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/25.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGNetController.h"
#import "PGMacroDefHeader.h"
#import "PGConfig.h"
#import "UIColor+darken.h"
#import "PGUIKitUtil.h"
#import "PGRequestManager.h"

@interface PGNetController ()

@end

@implementation PGNetController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"网络请求+等待框";
}

- (void)buttonClicked:(UIButton *)button
{
    if(button.tag == 100)
    {
        [self showWaitingView:nil];
    }
    else
    {
        [self showWaitingView:nil viewStyle:EWaitingViewStyle_Rotation];
    }
    
    //for test
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideWaitingView];
    });
}

#pragma mark -
- (void)createSubViews
{
    [super createSubViews];
    
    CGFloat y = self.nNavMaxY+PGHeightWith1080(140);
    UIButton *button = [PGUIKitUtil createButton:100 frame:CGRectMake(PGHeightWith1080(30), y, self.viewWidth-2*PGHeightWith1080(30), PGHeightWith1080(140)) title:@"样式一" target:self action:@selector(buttonClicked:)];
    [PGUIKitUtil setButtonBack:Color_For_OrangeButton selColor:[Color_For_OrangeButton darkenByPercentage:0.3] radius:3 button:button];
    [self.view addSubview:button];
    
    y += button.frame.size.height;
    y += PGHeightWith1080(50);
    button = [PGUIKitUtil createButton:200 frame:CGRectMake(PGHeightWith1080(30), y, self.viewWidth-2*PGHeightWith1080(30), PGHeightWith1080(140)) title:@"样式二" target:self action:@selector(buttonClicked:)];
    [PGUIKitUtil setButtonBack:Color_For_OrangeButton selColor:[Color_For_OrangeButton darkenByPercentage:0.3] radius:3 button:button];
    [self.view addSubview:button];
}

@end
