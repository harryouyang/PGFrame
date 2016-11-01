//
//  PGBaseController+errorView.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseController+errorView.h"
#import "PGMacroDefHeader.h"
#import "PGUIKitUtil.h"
#import "PGConfig.h"

@implementation PGBaseController (errorView)

- (void)showDataLoadErrorView
{
    WEAKSELF
    [self showErrorView:self.view flag:@"commonError" errorView:^UIView *{
        CGFloat y = weakSelf.nNavMaxY;
        CGFloat h = weakSelf.view.frame.size.height-y;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, weakSelf.viewWidth, h)];
        view.backgroundColor = weakSelf.view.backgroundColor;
        
        y = PGHeightWith1080(300);
        CGFloat iw = PGHeightWith1080(320);
        CGFloat ih = PGHeightWith1080(400);
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((weakSelf.viewWidth-iw)/2, y, iw, ih)];
        image.image = [UIImage imageNamed:@"no_net"];
        [view addSubview:image];
        
        y += image.frame.size.height;
        y += PGHeightWith1080(30);
        
        UILabel *label = [PGUIKitUtil createLabel:@"网络异常,请稍后重试!" frame:CGRectMake(PGHeightWith1080(30), y, weakSelf.viewWidth-2*PGHeightWith1080(30), PGHeightWith1080(80)) bgColor:view.backgroundColor titleColor:Color_For_GrayTextColor font:[PGUIKitUtil systemFontOfSize:13] alignment:NSTextAlignmentCenter];
        [view addSubview:label];
        
        y += label.frame.size.height;
        y += PGHeightWith1080(30);
        
        UIButton *button = [PGUIKitUtil createButton:0 frame:CGRectMake(PGHeightWith1080(400), y, weakSelf.viewWidth-2*PGHeightWith1080(400), PGHeightWith1080(100)) bgColor:[UIColor whiteColor] lineColor:Color_For_separatorColor title:@"重试" titleColor:Color_For_TextColor font:[PGUIKitUtil systemFontOfSize:13] target:weakSelf action:@selector(reloadData) radius:0.0];
        [view addSubview:button];
        
        return view;
    }];
}

- (void)hideDataLoadErrorView
{
    [self hideErrorView:self.view flag:@"commonError"];
}

- (void)showNoDataView
{
    WEAKSELF
    [self showErrorView:self.view flag:@"commonNoData" errorView:^UIView *{
        CGFloat y = weakSelf.nNavMaxY;
        CGFloat h = weakSelf.view.frame.size.height-y;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, weakSelf.viewWidth, h)];
        view.backgroundColor = weakSelf.view.backgroundColor;
        
        y = PGHeightWith1080(300);
        CGFloat iw = PGHeightWith1080(320);
        CGFloat ih = PGHeightWith1080(400);
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((weakSelf.viewWidth-iw)/2, y, iw, ih)];
        image.image = [UIImage imageNamed:@"data_no"];
        [view addSubview:image];
        
        y += image.frame.size.height;
        y += PGHeightWith1080(30);
        
        UILabel *label = [PGUIKitUtil createLabel:@"您没有相应的数据记录！" frame:CGRectMake(PGHeightWith1080(30), y, weakSelf.viewWidth-2*PGHeightWith1080(30), PGHeightWith1080(80)) bgColor:view.backgroundColor titleColor:Color_For_GrayTextColor font:[PGUIKitUtil systemFontOfSize:13] alignment:NSTextAlignmentCenter];
        [view addSubview:label];
        
        return view;
    }];
}

- (void)hideNoDataRecordView
{
    [self hideErrorView:self.view flag:@"commonNoData"];
}


@end
