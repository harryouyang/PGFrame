//
//  PGTableBaseController.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseController.h"
#import "PGTableDataSource.h"
#import "UIScrollView+refresh.h"

@interface PGTableBaseController : PGBaseController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *mTableView;
@property(nonatomic, strong)PGTableDataSource *mTableDataSource;
@property(nonatomic, strong)NSMutableArray *mDataArray;
@property(nonatomic, assign)NSInteger nNumOfPage;
/*
 创建TableView
 */
- (UITableView *)createTableView:(CGRect)rect
                           style:(UITableViewStyle)style
              bEnableRefreshHead:(BOOL)bEnableRefreshHead
                       bLoadMore:(BOOL)bLoadMore
                        complete:(void(^)(UITableView *table))complete;

/*
 将要刷新获取数据
 */
- (void)willGetDataForScrollView:(UIScrollView *)scrollView;

- (void)loadDataFinish:(UIScrollView *)scrollView;
- (void)loadDataError:(UIScrollView *)scrollView error:(NSString *)msg;

/*
 加载更多数据
 */
- (void)loadMoreData;
/*
 加载更多数据,当controller中有多个table都有加载更多的时候用
 */
- (void)willLoadMoreDataForScrollView:(UIScrollView *)scrollView;

- (void)loadMoreDataFinish:(UIScrollView *)scrollView;
- (void)loadMoreDataError:(UIScrollView *)scrollView error:(NSString *)msg;
@end
