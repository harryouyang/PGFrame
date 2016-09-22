//
//  PGHomeController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGHomeController.h"
#import "PGRequestManager.h"
#import "PGBaseController+errorView.h"

@interface PGHomeController ()<PGApiDelegate>

@end

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
    
//    [self showWaitingView:nil viewStyle:EWaitingViewStyle_Rotation];
//    
//    [PGRequestManager startPostClient:API_TYPE_LOGIN
//                                param:@{@"userName":@"name",@"password":@"123456"}
//                               target:self
//                                  tag:@"login"];
    
    
//    [self showDataLoadErrorView];
    
//    [self showMsg:@"消息内容"];
    
    [self showAskAlertTitle:@"标题" message:@"提示的内容" tag:0 action:^(NSInteger alertTag, NSInteger actionIndex) {
        //事件响应
        if(actionIndex == 0) {
            
        } else if(actionIndex == 1) {
            
        }
    } cancelActionTitle:@"取消" otherActionsTitles:@"确定",nil];
}

- (void)reloadData
{
    [self showNoDataView];
    [self hideDataLoadErrorView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideNoDataRecordView];
    });
}

#pragma mark PGApiDelegate
- (void)dataRequestSuccess:(PGResultObject *)resultObj
{
    [self hideWaitingView];
}

- (void)dataRequestFailed:(PGResultObject *)resultObj
{
    [self hideWaitingView];
    [self showMsg:resultObj.szErrorDes];
}

@end
