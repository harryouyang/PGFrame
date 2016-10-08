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
#import "PGH5JsController.h"

@implementation PGHomeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页";
}

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
    else if(indexPath.row == 4)
    {
        PGH5JsController *controller = [[PGH5JsController alloc] initWithTitle:@"H5交互实例"];
        [self pushNewViewController:controller];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"nativeInteraction" ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        [controller loadWebRequestWithHtmlString:htmlString];
        
//        NSString *url = @"http://192.168.1.206/webv3/index.php#/activity/NativeInteraction";
////        url = @"http://192.168.1.206/webv3/html/NativeInteraction.html";
//        [controller loadWebRequestWithURLString:url home:url];
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
