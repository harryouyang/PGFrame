//
//  UIScrollView+refresh.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/13.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "UIScrollView+refresh.h"
#import <objc/runtime.h>

static char *refreshDelegateKey = "refreshDelegateKey";
static char *refreshViewKey = "refreshViewKey";
static char *bPullDownEnableKey = "bPullDownEnableKey";
static char *bLoadMoreEnableKey = "bLoadMoreEnableKey";
static char *bLoadMoringKey = "bLoadMoringkey";
static char *bLoadingKey = "bLoadingKey";
static char *nNumOfPageKey = "nNumOfPageKey";
static char *nPageIndexKey = "nPageIndexKey";
static char *nTotalKey = "nTotalKey";
static char *moreViewKey = "moreViewKey";
static char *bNeedLoadMoreDataKey = "bNeedLoadMoreDataKey";

@implementation UIScrollView (refresh)

+ (void)load
{
    Method origMethod = class_getInstanceMethod([self class], @selector(setContentSize:));
    Method newMethod = class_getInstanceMethod([self class], @selector(pgSetContentSize:));

    method_exchangeImplementations(origMethod, newMethod);
}

- (void)pgSetContentSize:(CGSize)size
{
    if(self.moreView) {
        self.moreView.frame = CGRectMake(0, size.height, self.frame.size.width, self.moreView.frame.size.height);
    }
    
    [self pgSetContentSize:size];
}

- (void)setRefreshDelegate:(id<PGRefreshDelegate>)refreshDelegate {
    objc_setAssociatedObject(self, refreshDelegateKey, refreshDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<PGRefreshDelegate>)refreshDelegate {
    return objc_getAssociatedObject(self, refreshDelegateKey);
}

- (void)setRefreshView:(PGBaseRefreshView *)refreshView {
    if(self.refreshView) {
        self.refreshView.delegate = nil;
        [self.refreshView removeFromSuperview];
        objc_removeAssociatedObjects(refreshView);
    }
    
    objc_setAssociatedObject(self, refreshViewKey, refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(refreshView) {
        [self addSubview:refreshView];
        refreshView.delegate = self;
    }
}

- (PGBaseRefreshView *)refreshView {
    return objc_getAssociatedObject(self, refreshViewKey);
}

- (void)setMoreView:(PGBaseMoreView *)moreView {
    if(self.moreView) {
        self.moreView.delegate = nil;
        [self.moreView removeFromSuperview];
        objc_removeAssociatedObjects(moreView);
    }
    
    objc_setAssociatedObject(self, moreViewKey, moreView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if(moreView) {
        [self addSubview:moreView];
        moreView.delegate = self;
    }
}

- (PGBaseMoreView *)moreView {
    return objc_getAssociatedObject(self, moreViewKey);
}

- (void)setBPullDownEnable:(BOOL)bPullDownEnable {
    objc_setAssociatedObject(self, bPullDownEnableKey, [NSNumber numberWithBool:bPullDownEnable], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bPullDownEnable {
    NSNumber *number = objc_getAssociatedObject(self, bPullDownEnableKey);
    return [number boolValue];
}

- (void)setBLoadMoreEnable:(BOOL)bLoadMoreEnable {
    objc_setAssociatedObject(self, bLoadMoreEnableKey, [NSNumber numberWithBool:bLoadMoreEnable], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bLoadMoreEnable {
    NSNumber *number = objc_getAssociatedObject(self, bLoadMoreEnableKey);
    return [number boolValue];
}

- (void)setBLoading:(BOOL)bLoading {
    objc_setAssociatedObject(self, bLoadingKey, [NSNumber numberWithBool:bLoading], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bLoading {
    NSNumber *number = objc_getAssociatedObject(self, bLoadingKey);
    return [number boolValue];
}

- (void)setBLoadMoring:(BOOL)bLoadMoring {
    objc_setAssociatedObject(self, bLoadMoringKey, [NSNumber numberWithBool:bLoadMoring], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bLoadMoring {
    NSNumber *number = objc_getAssociatedObject(self, bLoadMoringKey);
    return [number boolValue];
}

- (void)setNNumOfPage:(NSInteger)nNumOfPage {
    objc_setAssociatedObject(self, nNumOfPageKey, [NSNumber numberWithInteger:nNumOfPage], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)nNumOfPage {
    NSNumber *number = objc_getAssociatedObject(self, nNumOfPageKey);
    return [number integerValue];
}

- (void)setNPageIndex:(NSInteger)nPageIndex {
    objc_setAssociatedObject(self, nPageIndexKey, [NSNumber numberWithInteger:nPageIndex], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)nPageIndex {
    NSNumber *number = objc_getAssociatedObject(self, nPageIndexKey);
    return [number integerValue];
}

- (void)setNTotal:(NSInteger)nTotal {
    objc_setAssociatedObject(self, nTotalKey, [NSNumber numberWithInteger:nTotal], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)nTotal {
    NSNumber *number = objc_getAssociatedObject(self, nTotalKey);
    return [number integerValue];
}

- (void)setBNeedLoadMoreData:(BOOL)bNeedLoadMoreData {
    objc_setAssociatedObject(self, bNeedLoadMoreDataKey, [NSNumber numberWithBool:bNeedLoadMoreData], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bNeedLoadMoreData {
    NSNumber *number = objc_getAssociatedObject(self, bNeedLoadMoreDataKey);
    return [number boolValue];
}

#pragma mark -
- (void)pgScrollViewDidScroll
{
    if(self.bPullDownEnable && self.refreshView) {
        [self.refreshView refreshScrollViewDidScroll:self];
    }
    
    if(self.bLoadMoreEnable && self.moreView) {
        [self.moreView loadMoreScrollViewDidScroll:self];
    }
}

- (void)pgScrollViewDidEndDragging
{
    if(self.bPullDownEnable && self.refreshView) {
        [self.refreshView refreshScrollViewDidEndDragging:self willDecelerate:NO];
    }
    
    if(self.bLoadMoreEnable && self.moreView) {
        [self.moreView loadMoreScrollViewDidEndDragging:self willDecelerate:NO];
    }
}

#pragma mark - loading
- (void)startRefresh
{
    [self.refreshView startRefresh:self];
}

- (void)endRefreshing
{
    [self.refreshView stopRefresh:self];
}

#pragma mark - PGRefreshViewDelegate
- (BOOL)isLoadingData:(UIScrollView *)scrollView
{
    return scrollView.bLoading;
}

- (void)willStartRefresh:(UIScrollView *)scrollView
{
    if(!scrollView.bLoading) {
        scrollView.bLoading = YES;
        [self.refreshDelegate willStartRefresh:scrollView];
    }
}

#pragma mark - loadmore
- (void)endLoadMoring
{
    [self.moreView stopLoadMore:self];
}

- (BOOL)isLoadMoringData:(UIScrollView *)scrollView
{
    return scrollView.bLoadMoring;
}

- (BOOL)isNeedLoadMoreData:(UIScrollView *)scrollView
{
    return scrollView.bNeedLoadMoreData;
}

- (void)willStartLoadMore:(UIScrollView *)scrollView
{
    if(!scrollView.bLoadMoring) {
        scrollView.bLoadMoring = YES;
        [self.refreshDelegate willStartLoadMore:scrollView];
    }
}

#pragma mark -
- (void)reRefreshData
{
    if([self isKindOfClass:[UITableView class]]) {
        [(UITableView *)self reloadData];
    }
}

@end
