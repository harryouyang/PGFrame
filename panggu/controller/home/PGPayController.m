//
//  PGPayController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/25.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGPayController.h"
#import "PGOrderTallyController.h"
#import "PGOrderDetailController.h"

@implementation PGPayController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付模块";
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        PGOrderTallyController *controller = [[PGOrderTallyController alloc] init];
        [self pushNewViewController:controller];
    }
    else if(indexPath.row == 1)
    {
        PGOrderDetailController *controller = [[PGOrderDetailController alloc] init];
        [self pushNewViewController:controller];
    }
}

#pragma mark -
- (void)createInitData
{
    [super createInitData];
    
    [self.mDataArray addObjectsFromArray:@[@"订单结算",@"订单详情"]];
    
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
