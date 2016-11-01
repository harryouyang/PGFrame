//
//  PGBaseController+errorView.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseController.h"

@interface PGBaseController (errorView)

/**
 数据加载出错时显示提示页面
 */
- (void)showDataLoadErrorView;
/**
 隐藏提示页面
 */
- (void)hideDataLoadErrorView;

/**
 没有数据时
 */
- (void)showNoDataView;
- (void)hideNoDataRecordView;

@end
