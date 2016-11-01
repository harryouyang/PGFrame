//
//  PGMsgAndErrorController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGMsgAndErrorController.h"
#import "PGBaseController+errorView.h"
#import "PGMacroDefHeader.h"
#import "PGPopupView.h"
#import "PGConfig.h"

@interface PGMsgAndErrorController ()
@property(nonatomic, strong)PGPopupView *mPopview;
@end

@implementation PGMsgAndErrorController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"提示模块";
}

- (void)reloadData
{
    [self showNoDataView];
    [self hideDataLoadErrorView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideNoDataRecordView];
    });
}

#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        [self showMsg:@"简单提示框"];
    }
    else if(indexPath.row == 1)
    {
        [self showAskAlertTitle:@"标题" message:@"提示的内容" tag:0 action:^(NSInteger alertTag, NSInteger actionIndex) {
            //事件响应
            if(actionIndex == 0) {
                [self showTitle:@"提示" msg:@"您点击了取消"];
            } else if(actionIndex == 1) {
                [self showTitle:@"提示" msg:@"您点击了确定"];
            }
        } cancelActionTitle:@"取消" otherActionsTitles:@"确定",nil];
    }
    else if(indexPath.row == 2)
    {
        [self showDataLoadErrorView];
    }
    else if(indexPath.row == 3)
    {
        [self showNoDataView];
        //隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideNoDataRecordView];
        });
    }
    else if(indexPath.row == 4)
    {
        WEAKSELF
        [self showErrorView:self.view flag:@"errorView" errorView:^UIView *{
            CGFloat y = weakSelf.nNavMaxY;
            CGFloat h = weakSelf.view.frame.size.height-y;
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, weakSelf.viewWidth, h)];
            view.backgroundColor = weakSelf.view.backgroundColor;
            
            UILabel *label = [PGUIKitUtil createLabel:@"根据业务自定义页面" frame:CGRectMake(PGHeightWith1080(30), y, weakSelf.viewWidth-2*PGHeightWith1080(30), PGHeightWith1080(80)) bgColor:view.backgroundColor titleColor:[UIColor blackColor] font:[PGUIKitUtil systemFontOfSize:13] alignment:NSTextAlignmentCenter];
            [view addSubview:label];
            label.center = view.center;
            
            return view;
        }];
        
        //隐藏
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hideErrorView:self.view flag:@"errorView"];
        });
    }
    else if(indexPath.row == 5)
    {
        [self showDemoView];
    }
    else if(indexPath.row == 6)
    {
        WEAKSELF
        PGPopupView *view = [[PGPopupView alloc] initWithContent:^UIView * (id target, SEL closeSEL){
            UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.frame.size.width-2*PGHeightWith1080(60), PGHeightWith1080(960))];
            contentView.backgroundColor = UIColorFromRGBA(0xff00ff, 1.0);
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            closeBtn.frame = CGRectMake(contentView.frame.size.width-PGHeightWith1080(120), PGHeightWith1080(60), PGHeightWith1080(90), PGHeightWith1080(90));
            [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
            [closeBtn addTarget:target action:closeSEL forControlEvents:UIControlEventTouchUpInside];
            [contentView addSubview:closeBtn];
            
            //可以自定义界面
            
            return contentView;
        }];
        [view showInView:nil];
    }
}

#pragma mark -
- (void)showDemoView
{
    WEAKSELF
    NSInteger nLevel = 3;
    PGPopupView *view = [[PGPopupView alloc] initWithContent:^UIView * (id target, SEL closeSEL){
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, weakSelf.view.frame.size.width-2*PGHeightWith1080(60), PGHeightWith1080(960))];
        contentView.backgroundColor = UIColorFromRGBA(0xffffff, 0.0);
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(contentView.frame.size.width-PGHeightWith1080(120), PGHeightWith1080(60), PGHeightWith1080(90), PGHeightWith1080(90));
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [closeBtn addTarget:target action:closeSEL forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:closeBtn];
        
        /////////////
        UIView *wView = [[UIView alloc] initWithFrame:CGRectMake(0, PGHeightWith1080(200), contentView.frame.size.width, PGHeightWith1080(610))];
        wView.backgroundColor = [UIColor whiteColor];
        [contentView addSubview:wView];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:wView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(PGHeightWith1080(30), PGHeightWith1080(30))];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = wView.bounds;
        maskLayer.path = maskPath.CGPath;
        wView.layer.mask = maskLayer;
        
        UILabel *label = [PGUIKitUtil createLabel:@"恭喜升级" frame:CGRectMake(0, PGHeightWith1080(350), wView.frame.size.width, PGHeightWith1080(100)) bgColor:wView.backgroundColor titleColor:Color_For_OrangeButton font:[PGUIKitUtil systemFontOfSize:17] alignment:NSTextAlignmentCenter];
        [wView addSubview:label];
        
        label = [PGUIKitUtil createLabel:@"" frame:CGRectMake(0, PGHeightWith1080(450), wView.frame.size.width, PGHeightWith1080(80)) bgColor:wView.backgroundColor titleColor:Color_For_GrayTextColor font:[PGUIKitUtil systemFontOfSize:12] alignment:NSTextAlignmentCenter];
        [wView addSubview:label];
        
        if(nLevel == 4) {
            label.text = @"我可是白金会员了哦！";
        } else if(nLevel == 3) {
            label.text = @"我可是金牌会员了哦！";
        } else if(nLevel == 2) {
            label.text = @"我可是银牌会员了哦！";
        } else {
            label.text = @"我可是铜牌会员了哦！";
        }
        
        ///////////
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = Color_For_OrangeButton;
        button.frame = CGRectMake(0, PGHeightWith1080(800), contentView.frame.size.width, PGHeightWith1080(160));
        [button setTitle:@"查看特权奖励" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [PGUIKitUtil systemFontOfSize:15];
        [button addTarget:weakSelf action:@selector(openLevelRule) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:button];
        maskPath = [UIBezierPath bezierPathWithRoundedRect:button.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(PGHeightWith1080(30), PGHeightWith1080(30))];
        maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = button.bounds;
        maskLayer.path = maskPath.CGPath;
        button.layer.mask = maskLayer;
        
        UIView *medalView = [weakSelf createMedalView:nLevel];
        medalView.frame = CGRectMake((contentView.frame.size.width-medalView.frame.size.width)/2, 0, medalView.frame.size.width, medalView.frame.size.height);
        [contentView addSubview:medalView];
        
        return contentView;
    }];
    self.mPopview = view;
    [view showInView:nil];
}

- (void)openLevelRule
{
    [self.mPopview closeView];
    
    PGBaseController *control = [[PGBaseController alloc] init];
    control.title = @"等级的具体内容";
    [self pushNewViewController:control];
}

- (UIView *)createMedalView:(NSInteger)nLevel
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, PGHeightWith1080(550), PGHeightWith1080(500))];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PGHeightWith1080(550), PGHeightWith1080(405))];
    bgImageView.image = [UIImage imageNamed:@"menber_2"];
    [view addSubview:bgImageView];
    
    UIImageView *imageV1 = [[UIImageView alloc] initWithFrame:CGRectMake(PGHeightWith1080(58), PGHeightWith1080(40), PGHeightWith1080(435), PGHeightWith1080(450))];
    [view addSubview:imageV1];
    
    UIImageView *imageV2 = [[UIImageView alloc] initWithFrame:CGRectMake(PGHeightWith1080(24), PGHeightWith1080(350), PGHeightWith1080(503), PGHeightWith1080(130))];
    imageV2.image = [UIImage imageNamed:@"menber_1"];
    [view addSubview:imageV2];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(PGHeightWith1080(126), PGHeightWith1080(10), PGHeightWith1080(250), PGHeightWith1080(80))];
    label.font = [PGUIKitUtil systemFontOfSize:14];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [imageV2 addSubview:label];
    
    if(nLevel == 4) {
        imageV1.image = [UIImage imageNamed:@"menber_top1"];
        label.text = @"白金会员";
    } else if (nLevel == 3) {
        imageV1.image = [UIImage imageNamed:@"menber_top2"];
        label.text = @"金牌会员";
    } else if (nLevel == 2) {
        imageV1.image = [UIImage imageNamed:@"menber_top3"];
        label.text = @"银牌会员";
    } else {
        imageV1.image = [UIImage imageNamed:@"menber_top4"];
        label.text = @"铜牌会员";
    }
    
    return view;
}

#pragma mark -
- (void)createInitData
{
    [super createInitData];
    
    [self.mDataArray addObjectsFromArray:@[@"消息提示1",@"消息提示2",@"错误提示1",@"错误提示2",@"错误提示3",@"遮罩层1",@"遮罩层2"]];
    
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
