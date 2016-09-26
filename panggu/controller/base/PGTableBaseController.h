//
//  PGTableBaseController.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseController.h"
#import "PGTableDataSource.h"

@interface PGTableBaseController : PGBaseController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *mTableView;
@property(nonatomic, strong)PGTableDataSource *mTableDataSource;
@property(nonatomic, strong)NSMutableArray *mDataArray;

/*
 创建TableView
 */
- (UITableView *)createTableView:(CGRect)rect
                           style:(UITableViewStyle)style
              bEnableRefreshHead:(BOOL)bEnableRefreshHead
                       bLoadMore:(BOOL)bloadmore
                        complete:(void(^)(UITableView *table))complete;
@end
