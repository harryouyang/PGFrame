//
//  PGDownTaskController.m
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGDownTaskController.h"
#import "PGDownTaskContainer.h"
#import "PGDownListController.h"

@interface CellObj : NSObject
@property(nonatomic, strong)NSString *name;
@property(nonatomic, strong)NSString *url;
+ (CellObj *)cellWith:(NSString *)name url:(NSString *)url;
@end

@implementation CellObj

+ (CellObj *)cellWith:(NSString *)name url:(NSString *)url {
    CellObj *obj = [[CellObj alloc] init];
    obj.name = name;
    obj.url = url;
    return obj;
}

@end


@implementation PGDownTaskController

- (void)freeMemory
{
    [super freeMemory];
    
    [self.mTableView removeFromSuperview];
    self.mTableView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加下载任务";
    
    [self createNavRightMenu:@"下载队列"];
}

- (void)rightItemClicked:(id)sender {
    PGDownListController *control = [[PGDownListController alloc] init];
    [self pushNewViewController:control];
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CellObj *obj = [self.mDataArray objectAtIndex:indexPath.row];
    
    [PGDownTaskContainer addTaskWithUrl:obj.url];
}

#pragma mark -
- (void)createInitData
{
    [super createInitData];
    
    [self.mDataArray addObjectsFromArray:@[[CellObj cellWith:@"28841018_14.jpg" url:@"http://image57.360doc.com/DownloadImg/2012/12/1116/28841018_14.jpg"],
                                           [CellObj cellWith:@"mysql-5.7.16-osx10.11-x86_64.dmg" url:@"http://cdn.mysql.com//Downloads/MySQL-5.7/mysql-5.7.16-osx10.11-x86_64.dmg"],
                                           [CellObj cellWith:@"30321266_13" url:@"http://image58.360doc.com/DownloadImg/2013/02/1523/30321266_13.jpg"],
                                           [CellObj cellWith:@"9885883_114750128000_2" url:@"http://pic65.nipic.com/file/20150421/9885883_114750128000_2.jpg"],
                                           [CellObj cellWith:@"15.jpg" url:@"http://img2.3lian.com/2014/f3/57/d/15.jpg"],
                                           [CellObj cellWith:@"MindManager_for_Mac_Trial_wm.dmg" url:@"http://xiazai.mindmanager.cc/wm/MindManager_for_Mac_Trial_wm.dmg"],
                                           [CellObj cellWith:@"27773420_5.jpg" url:@"http://image55.360doc.com/DownloadImg/2012/10/2517/27773420_5.jpg"],
                                           [CellObj cellWith:@"xampp-osx-5.6.24-1-installer.dmg" url:@"http://ncu.dl.sourceforge.net/project/xampp/XAMPP%20Mac%20OS%20X/5.6.24/xampp-osx-5.6.24-1-installer.dmg"],
                                           [CellObj cellWith:@"11086774_10.jpg" url:@"http://image27.360doc.com/DownloadImg/2011/04/2020/11086774_10.jpg"],
                                           [CellObj cellWith:@"QQ_V5.2.0.dmg" url:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.2.0.dmg"],
                                           [CellObj cellWith:@"JPush-iOS-SDK-2.2.0.zip" url:@"https://sdkfiledl.jiguang.cn/JPush-iOS-SDK-2.2.0.zip"]]];
    
    self.mTableDataSource = [[PGTableDataSource alloc] initWithItems:self.mDataArray cellIdentifier:@"tableCellIndentifier" createCellBlock:^UITableViewCell *(NSString *cellIdentifier) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [PGUIKitUtil systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } configCellBlock:^(UITableViewCell *cell, NSObject *item) {
        CellObj *obj = (CellObj *)item;
        cell.textLabel.text = obj.name;
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
