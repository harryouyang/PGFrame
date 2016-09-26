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

@implementation PGTableBaseController

- (void)createInitData
{
    [super createInitData];
    self.mDataArray = [[NSMutableArray alloc] init];
}

- (UITableView *)createTableView:(CGRect)rect
                           style:(UITableViewStyle)style
              bEnableRefreshHead:(BOOL)bEnableRefreshHead
                       bLoadMore:(BOOL)bloadmore
                        complete:(void(^)(UITableView *table))complete
{
    UITableView *table = [[UITableView alloc] initWithFrame:rect style:style];
    table.delegate = self;
    table.dataSource = self;
    
    table.backgroundColor = Color_For_ControllerBackColor;
    table.separatorColor = Color_For_separatorColor;
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
