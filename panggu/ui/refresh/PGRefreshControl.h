//
//  PGRefreshControl.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/27.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGRefreshControlHead.h"

@protocol PGRefreshControlDelegate <NSObject>

@required
/**
 *  将要开始下拉刷新
 */
- (void)beginPullDownRefreshing;

/**
 *  将要开始上提加载更多
 */
- (void)beginLoadMoreRefreshing;


@optional
/**
 *  是否支持下拉刷新
 */
- (BOOL)isPullDownRefreshed;

/**
 *  是否支持上提加载更多
 */
- (BOOL)isLoadMoreRefreshed;

/**
 *  获取用户定义下拉的View
 */
- (UIView *)pullDownRefreshView;

/**
 *  通知外部，下拉的距离，用于定制某个时机的状态
 */
- (void)pullDownRefreshView:(UIView *)pullDownRefreshView withPullDownOffset:(CGFloat)pullDownOffset;

/**
 *  通知外部，下拉的状态，用于定制某个时机的状态
 */
- (void)pullDownRefreshViewRefreshState:(PGRefreshState)refreshState;

/**
 *  将要下拉的时候，被调用
 */
- (void)pullDownRefreshViewWillStartRefresh:(UIView *)pullDownRefreshView;

/**
 *  刚进入下拉的时候，被调用
 */
- (void)pullDownRefreshViewDidStartRefresh:(UIView *)pullDownRefreshView;

/**
 *  将要停止下啦的时候，被调用
 */
- (void)pullDownRefreshViewWillEndRefresh:(UIView *)pullDownRefreshView;

/**
 *  刚进入停止下啦的时候，被调用
 */
- (void)pullDownRefreshViewDidEndRefresh:(UIView *)pullDownRefreshView;

#pragma mark -
/**
 *  获取用户定义下拉的View
 */
- (UIView *)loadMoreView;

/**
 *  通知外部，下拉的状态，用于定制某个时机的状态
 */
- (void)loadMoreViewRefreshState:(PGLoadMoreState)loadMoreState;

/**
 *  当scrollView滚动到距离底部有多少距离
 */
- (CGFloat)preloadDistance;

/**
 *  是否有更多数据需要加载,有：返回NO，没有返回YES
 */
- (BOOL)noMoreDataForLoaded;

@end


#pragma mark -
@interface PGRefreshControl : NSObject

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<PGRefreshControlDelegate>)delegate;

/**
 *  外部手动启动下拉加载的方法，这个方法不需要手动去拖动UIScrollView
 */
- (void)startPullDown;

/**
 *  停止下拉刷新的方法
 */
- (void)endPullDown;

/**
 *  外部手动启动上拉加载更多的方法，这个方法不需要手动去拖动UIScrollView
 */
- (void)startLoadMore;

/**
 *  停止上提加载更多的方法
 */
- (void)endLoadMore;

/**
 *  获取是否下啦刷新中
 */
- (BOOL)isLoading;

@end
