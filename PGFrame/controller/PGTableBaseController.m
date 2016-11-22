//
//  PGTableBaseController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGTableBaseController.h"
#import "PGConfig.h"
#import "PGMacroDefHeader.h"
#import "PGRefreshRotate.h"
#import "PGSimpleMoreView.h"

@interface PGTableBaseController ()<PGRefreshDelegate>
@end

@implementation PGTableBaseController

- (void)createInitData
{
    [super createInitData];
    self.nNumOfPage = 20;
    self.mDataArray = [[NSMutableArray alloc] init];
}

- (void)createAndAddTableView:(CGRect)rect
                        style:(UITableViewStyle)style
           bEnableRefreshHead:(BOOL)bEnableRefreshHead
                    bLoadMore:(BOOL)bloadmore
                     complete:(void(^)(UITableView *table))complete
{
    self.mTableView = [self createTableView:rect style:style bEnableRefreshHead:bEnableRefreshHead bLoadMore:bloadmore complete:complete];
    [self.view addSubview:self.mTableView];
}

- (UITableView *)createTableView:(CGRect)rect
                           style:(UITableViewStyle)style
              bEnableRefreshHead:(BOOL)bEnableRefreshHead
                       bLoadMore:(BOOL)bLoadMore
                        complete:(void(^)(UITableView *table))complete
{
    UITableView *table = [[UITableView alloc] initWithFrame:rect style:style];
    table.delegate = self;
    table.dataSource = self;
    
    table.backgroundColor = Color_For_ControllerBackColor;
    table.separatorColor = Color_For_separatorColor;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    table.bPullDownEnable = bEnableRefreshHead;
    table.bLoadMoreEnable = bLoadMore;
    table.nNumOfPage = self.nNumOfPage;
    if(bEnableRefreshHead) {
        table.refreshDelegate = self;
        table.refreshView = [[PGRefreshRotate alloc] initWithFrame:CGRectMake(0,-80,CGRectGetWidth(table.frame),80)];
    }
    
    if(bLoadMore) {
        table.refreshDelegate = self;
        table.moreView = [[PGSimpleMoreView alloc] initWithFrame:CGRectMake(0, table.contentSize.height, CGRectGetWidth(table.frame), 40)];
        table.moreView.hidden = YES;
    }
    
    if(complete)
        complete(table);
    
    return table;
}

#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section;
{
    return 1.0f/SCREEN_SCALE;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f/SCREEN_SCALE;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableCell"];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (void)viewDidLayoutSubviews
{
    if(self.bSeparatorInset == NO)
        return;
    
    if([self.mTableView respondsToSelector:@selector(setSeparatorInset:)])
        [self.mTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    
    if(IOS8_LATER)
    {
        self.mTableView.layoutMargins = UIEdgeInsetsMake(0,0,0,0);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.bSeparatorInset == NO)
        return;
    
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if(IOS8_LATER)
    {
        cell.preservesSuperviewLayoutMargins = NO;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (void)willGetDataForScrollView:(UIScrollView *)scrollView
{
    [self getDataFromNet];
}

- (void)loadMoreData
{
}

- (void)willLoadMoreDataForScrollView:(UIScrollView *)scrollView
{
    [self loadMoreData];
}

- (void)loadDataFinish:(UIScrollView *)scrollView
{
    scrollView.nPageIndex += 1;
    scrollView.bLoading = NO;
    
    WEAKSELF
    [self asyncOnMainQueue:^{
        [weakSelf hideWaitingView];
        [scrollView reRefreshData];
        [scrollView endRefreshing];
        [weakSelf showLoadMoreView:scrollView];
    }];
}

- (void)loadDataError:(UIScrollView *)scrollView error:(NSString *)msg
{
    scrollView.bLoading = NO;
    WEAKSELF
    [self asyncOnMainQueue:^{
        [weakSelf hideWaitingView];
        [weakSelf showMsg:msg];
        [scrollView endRefreshing];
        [weakSelf showLoadMoreView:scrollView];
    }];
}

- (void)loadMoreDataFinish:(UIScrollView *)scrollView
{
    scrollView.nPageIndex += 1;
    scrollView.bLoadMoring = NO;
    
    WEAKSELF
    [self asyncOnMainQueue:^{
        [weakSelf hideWaitingView];
        [scrollView reRefreshData];
        [scrollView endLoadMoring];
        [weakSelf showLoadMoreView:scrollView];
    }];
}

- (void)loadMoreDataError:(UIScrollView *)scrollView error:(NSString *)msg
{
    scrollView.bLoadMoring = NO;
    WEAKSELF
    [self asyncOnMainQueue:^{
        [weakSelf hideWaitingView];
        [weakSelf showMsg:msg];
        [scrollView endLoadMoring];
        [weakSelf showLoadMoreView:scrollView];
    }];
}

#pragma mark -
- (void)showLoadMoreView:(UIScrollView *)scrollView
{
    if(scrollView.moreView != nil)
    {
        if(scrollView.nTotal > self.mDataArray.count)
        {
            scrollView.moreView.hidden = NO;
            scrollView.bNeedLoadMoreData = YES;
        }
        else
        {
            scrollView.moreView.hidden = YES;
            scrollView.bNeedLoadMoreData = NO;
        }
    }
}


#pragma mark - PGRefreshDelegate
- (void)willStartRefresh:(UIScrollView *)scrollView
{
    [self willGetDataForScrollView:scrollView];
}

- (void)willStartLoadMore:(UIScrollView *)scrollView
{
    [self willLoadMoreDataForScrollView:scrollView];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView pgScrollViewDidScroll];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [scrollView pgScrollViewDidEndDragging];
}

@end
