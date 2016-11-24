//
//  PGImageDownController.m
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGImageDownController.h"
#import "PGImageCell.h"

@implementation PGImageDownController
- (void)freeMemory
{
    [super freeMemory];
    
    [self.mTableView removeFromSuperview];
    self.mTableView = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"talbeCell图片下载";
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (void)createInitData
{
    [super createInitData];
    
    [self.mDataArray addObjectsFromArray:@[@"http://image57.360doc.com/DownloadImg/2012/12/1116/28841018_14.jpg",
                                           @"http://image55.360doc.com/DownloadImg/2012/10/2517/27773420_5.jpg",
                                           @"http://img2.3lian.com/2014/f3/57/d/15.jpg",
                                           @"http://image58.360doc.com/DownloadImg/2013/02/1523/30321266_13.jpg",
                                           @"http://pic65.nipic.com/file/20150421/9885883_114750128000_2.jpg",
                                           @"http://image27.360doc.com/DownloadImg/2011/04/2020/11086774_10.jpg",
                                           @"http://image.tianjimedia.com/uploadImages/2015/083/30/VVJ04M7P71W2.jpg",
                                           @"http://img1.3lian.com/2015/a1/40/d/191.jpg",
                                           @"http://img1.3lian.com/2015/a1/27/d/126.jpg",
                                           @"http://upload.northnews.cn/2015/0429/thumb_940__1430264752354.jpg",
                                           @"http://pic.yesky.com/uploadImages/2014/302/42/0UWKML12KH66.jpg",
                                           @"http://image.tianjimedia.com/uploadImages/2013/324/E85BW32E3U69_1000x500.jpg",
                                           @"http://p1.qqyou.com/pic/uploadpic/2014-7/19/2014071916461278636.jpg",
                                           @"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1501/20/c13/2122099_2122099_1421756219070_mthumb.jpg",
                                           @"http://image57.360doc.com/DownloadImg/2012/12/1116/28841018_14.jpg",
                                           @"http://image55.360doc.com/DownloadImg/2012/10/2517/27773420_5.jpg",
                                           @"http://img2.3lian.com/2014/f3/57/d/15.jpg",
                                           @"http://image58.360doc.com/DownloadImg/2013/02/1523/30321266_13.jpg",
                                           @"http://pic65.nipic.com/file/20150421/9885883_114750128000_2.jpg",
                                           @"http://image27.360doc.com/DownloadImg/2011/04/2020/11086774_10.jpg",
                                           @"http://image.tianjimedia.com/uploadImages/2015/083/30/VVJ04M7P71W2.jpg",
                                           @"http://img1.3lian.com/2015/a1/40/d/191.jpg",
                                           @"http://img1.3lian.com/2015/a1/27/d/126.jpg",
                                           @"http://upload.northnews.cn/2015/0429/thumb_940__1430264752354.jpg",
                                           @"http://pic.yesky.com/uploadImages/2014/302/42/0UWKML12KH66.jpg",
                                           @"http://image.tianjimedia.com/uploadImages/2013/324/E85BW32E3U69_1000x500.jpg",
                                           @"http://p1.qqyou.com/pic/uploadpic/2014-7/19/2014071916461278636.jpg",
                                           @"http://img.pconline.com.cn/images/upload/upc/tx/photoblog/1501/20/c13/2122099_2122099_1421756219070_mthumb.jpg"]];
    
    self.mTableDataSource = [[PGTableDataSource alloc] initWithItems:self.mDataArray cellIdentifier:@"tableCellIndentifier" createCellBlock:^UITableViewCell *(NSString *cellIdentifier) {
        PGImageCell *cell = [[PGImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [PGUIKitUtil systemFontOfSize:14];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    } configCellBlock:^(UITableViewCell *cell, NSObject *item) {
        PGImageCell *pcell = (PGImageCell *)cell;
        [pcell configCellWithImageUrl:(NSString *)item];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
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
