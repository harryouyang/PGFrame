//
//  PGRefreshController.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/13.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGRefreshController.h"

@interface PGRefreshController ()
@property(nonatomic, strong)NSArray *pageArray;
@property(nonatomic, assign)NSInteger nTotalCount;
@end

@implementation PGRefreshController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"下拉刷新";
}

#pragma mark -
- (void)createInitData
{
    [super createInitData];
    
    self.nTotalCount = 60;
    
    self.pageArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                       @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"];
    
    self.mTableDataSource = [[PGTableDataSource alloc] initWithItems:self.mDataArray cellIdentifier:@"tableCellIndentifier" createCellBlock:^UITableViewCell *(NSString *cellIdentifier) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [PGUIKitUtil systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } configCellBlock:^(UITableViewCell *cell, NSObject *item) {
        cell.textLabel.text = (NSString *)item;
    }];
}

- (void)didCreateSubViews
{
    [self getDataFromNet];
}

- (void)getDataFromNet
{
    [self showWaitingView:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideWaitingView];
        [self.mDataArray removeAllObjects];
        [self.mDataArray addObjectsFromArray:self.pageArray];
        self.mTableView.nTotal = self.nTotalCount;
        self.mTableDataSource.arrayData = self.mDataArray;
        [self loadDataFinish:self.mTableView];
    });
}

- (void)loadMoreData
{
    [self showWaitingView:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideWaitingView];
        [self.mDataArray addObjectsFromArray:self.pageArray];
        self.mTableDataSource.arrayData = self.mDataArray;
        [self loadMoreDataFinish:self.mTableView];
    });
}

#pragma mark -
- (void)createSubViews
{
    [super createSubViews];
    
    self.mTableView = [self createTableView:CGRectMake(0, 0, self.viewWidth, self.viewValidHeight) style:UITableViewStylePlain bEnableRefreshHead:YES bLoadMore:YES complete:nil];
    [self.view addSubview:self.mTableView];
    
    self.mTableView.dataSource = self.mTableDataSource;
}

@end
