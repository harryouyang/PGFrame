//
//  PGHomeController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGHomeController.h"

@implementation PGHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor redColor];
    button.frame = CGRectMake(50, 100, 200, 50);
    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clicked:(UIButton *)button
{
//    PGHomeController *controller = [[PGHomeController alloc] init];
//    [self pushNewViewController:controller];
    
    [self showWaitingView:nil viewStyle:EWaitingViewStyle_Rotation];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideWaitingView];
    });
}

@end
