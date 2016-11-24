//
//  PGDownListController.m
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGDownListController.h"
#import "PGDownTaskContainer.h"
#import "PGDownloadCell.h"

@interface PGDownListController ()<PGDownTaskContainerDelegate>
@property(nonatomic, strong)UITableView *mDownTable;
@property(nonatomic, strong)PGTableDataSource *mDownTableSource;

@end

@implementation PGDownListController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"下载队列";
}

- (void)createInitData {
    [super createInitData];
    
    [PGDownTaskContainer setContainerDelegate:self];
    self.mDownTableSource.arrayData = [PGDownTaskContainer allTask];
}

- (PGTableDataSource *)mDownTableSource
{
    if(_mDownTableSource == nil) {
        _mDownTableSource = [[PGTableDataSource alloc] initWithItems:self.mDataArray cellIdentifier:@"tablecellIdentifier" createCellBlock:^UITableViewCell *(NSString *cellIdentifier) {
            PGDownloadCell *cell = [[PGDownloadCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } configCellBlock:^(UITableViewCell *cell, NSObject *item) {
            PGDownloadCell *pCell = (PGDownloadCell *)cell;
            PGTaskObject *obj = (PGTaskObject *)item;
            [pCell configWithTask:obj];
        }];
    }
    
    return _mDownTableSource;
}

#pragma mark -
- (void)taskDidChanged {
    self.mDownTableSource.arrayData = [PGDownTaskContainer allTask];
    __weak PGDownListController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.mDownTable reloadData];
    });
}

#pragma mark -
- (void)createSubViews
{
    [super createSubViews];
    
    self.mDownTable = [self createTableView:CGRectMake(0, self.nNavMaxY, self.viewWidth, self.viewValidHeight) style:UITableViewStylePlain bEnableRefreshHead:YES bLoadMore:YES complete:^(UITableView *table) {
    }];
    [self.view addSubview:self.mDownTable];
    self.mDownTable.dataSource = self.mDownTableSource;
}


@end
