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
#import "PGUIKitUtil.h"
#import "PGMsgAndErrorController.h"
#import "PGPayController.h"
#import "PGNetController.h"

@implementation PGHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor redColor];
//    button.frame = CGRectMake(50, 100, 200, 50);
//    [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:button];
}

//- (void)clicked:(UIButton *)button
//{
////    PGHomeController *controller = [[PGHomeController alloc] init];
////    [self pushNewViewController:controller];
//    
////    [self showWaitingView:nil viewStyle:EWaitingViewStyle_Rotation];
////    
////    [PGRequestManager startPostClient:API_TYPE_LOGIN
////                                param:@{@"userName":@"name",@"password":@"123456"}
////                               target:self
////                                  tag:@"login"];
//    
//    
////    [self showDataLoadErrorView];
//    
////    [self showMsg:@"消息内容"];
//    
//    [self showAskAlertTitle:@"标题" message:@"提示的内容" tag:0 action:^(NSInteger alertTag, NSInteger actionIndex) {
//        //事件响应
//        if(actionIndex == 0) {
//            
//        } else if(actionIndex == 1) {
//            
//        }
//    } cancelActionTitle:@"取消" otherActionsTitles:@"确定",nil];
//}
//
- (void)reloadData
{
    [self showNoDataView];
    [self hideDataLoadErrorView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideNoDataRecordView];
    });
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        PGMsgAndErrorController *controller = [[PGMsgAndErrorController alloc] init];
        [self pushNewViewController:controller];
    }
    else if(indexPath.row == 1)
    {
        PGNetController *controller = [[PGNetController alloc] init];
        [self pushNewViewController:controller];
    }
    else if(indexPath.row == 2)
    {
        
    }
    else if(indexPath.row == 3)
    {
        PGPayController *controller = [[PGPayController alloc] init];
        [self pushNewViewController:controller];
    }
}

#pragma mark -
- (void)createInitData
{
    [super createInitData];
    
    [self.mDataArray addObjectsFromArray:@[@"消息提示、错误提示、遮罩层",@"网络请求模块",@"数据缓存、读取、删除",@"支付模块",@"H5交互"]];
    
    self.mTableDataSource = [[PGTableDataSource alloc] initWithItems:self.mDataArray cellIdentifier:@"tableCellIndentifier" createCellBlock:^UITableViewCell *(NSString *cellIdentifier) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [PGUIKitUtil systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } configCellBlock:^(UITableViewCell *cell, NSObject *item) {
        cell.textLabel.text = (NSString *)item;
    }];
}

#pragma mark -
- (void)createSubViews
{
    [super createSubViews];
    
    self.mTableView = [self createTableView:CGRectMake(0, 0, self.viewWidth, self.viewValidHeight) style:UITableViewStylePlain bEnableRefreshHead:NO bLoadMore:NO complete:nil];
    [self.view addSubview:self.mTableView];
    
    self.mTableView.dataSource = self.mTableDataSource;
}


@end
