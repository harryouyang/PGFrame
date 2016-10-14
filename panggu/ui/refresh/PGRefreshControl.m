//
//  PGRefreshControl.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/27.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGRefreshControl.h"

#define kPGDefaultRefreshTotalPixels    60
#define kPGLoadMoreViewHeight       50

@interface PGRefreshControl ()
@property(nonatomic, assign)BOOL bPullDownEnable;
@property(nonatomic, assign)BOOL bLoadMoreEnable;

@property(nonatomic, assign)BOOL bPullDownRefreshing;
@property(nonatomic, assign)BOOL bLoadMoreRefreshing;

@property(nonatomic, readwrite)CGFloat originalTopInset;
@property(nonatomic, readwrite)CGFloat originalBottomInset;

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIView *refreshView;

@property(nonatomic, weak)id<PGRefreshControlDelegate> delegate;
@property(nonatomic, assign)PGRefreshState refreshState;

@property(nonatomic, assign)CGFloat refreshTotalPixels;

@property(nonatomic, assign)CGFloat preloadValue;
@property(nonatomic, assign)BOOL noMoreDataForLoaded;
@property(nonatomic, strong)UIView *loadMoreView;
@end

@implementation PGRefreshControl

- (void)configuraObserverWithScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverWithScrollView:(UIScrollView *)scrollView
{
    [scrollView removeObserver:self forKeyPath:@"contentOffset" context:nil];
    [scrollView removeObserver:self forKeyPath:@"contentSize" context:nil];
}

- (void)setup
{
    self.originalTopInset = self.scrollView.contentInset.top;
    self.originalBottomInset = self.scrollView.contentInset.bottom;
    
//    self.refreshState = PGRefreshStateNormal;
    
    [self configuraObserverWithScrollView:self.scrollView];
    
    if (self.bPullDownEnable)
    {
        [self.scrollView addSubview:self.refreshView];
    }
    
    if (self.bLoadMoreEnable)
    {
        [self.scrollView addSubview:self.loadMoreView];
    }
}

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<PGRefreshControlDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.delegate = delegate;
        self.scrollView = scrollView;
        [self setup];
    }
    return self;
}

- (void)startPullDown
{
    if(self.bPullDownEnable)
    {
        self.bPullDownRefreshing = YES;
        
        self.refreshState = PGRefreshStatePulling;
        self.refreshState = PGRefreshStateLoading;
    }
}

- (void)endPullDown
{
    if(self.bPullDownEnable)
    {
        self.bPullDownRefreshing = NO;
        self.refreshState = PGRefreshStateStopped;
        [self resetScrollViewContentInset];
    }
    
    if ([self.delegate respondsToSelector:@selector(pullDownRefreshViewWillEndRefresh:)]) {
        [self.delegate pullDownRefreshViewWillEndRefresh:self.refreshView];
    }
}

- (void)startLoadMore
{
    if(self.bLoadMoreRefreshing)
        return;
    
}

- (void)callBeginPullDownRefreshing
{
//    [self setScrollViewContentInsetForNoLoadMore];
    
//    self.loadMoreRefreshedCount = 0;
//    self.noMoreDataForLoaded = NO;
    
    if ([self.delegate respondsToSelector:@selector(pullDownRefreshViewDidStartRefresh:)]) {
        [self.delegate pullDownRefreshViewDidStartRefresh:self.refreshView];
    }
    
    [self.delegate beginPullDownRefreshing];
}

#pragma mark - more
- (void)callBeginLoadMoreRefreshing
{
    if (self.bLoadMoreRefreshing)
        return;
    
    [self.delegate beginLoadMoreRefreshing];
}

#pragma mark - setter
- (void)setRefreshState:(PGRefreshState)refreshState
{
    if([self.delegate respondsToSelector:@selector(pullDownRefreshViewRefreshState:)])
    {
        [self.delegate pullDownRefreshViewRefreshState:refreshState];
    }
    
    switch(refreshState)
    {
        case PGRefreshStateStopped:
        case PGRefreshStateNormal:
        {
            break;
        }
        case PGRefreshStateLoading:
        {
            if(self.bPullDownRefreshing)
            {
                __weak typeof(self) weakSelf = self;
                [self setScrollViewContentInsetForLoadingCompletion:^(BOOL finished) {
                    if (finished) {
                        [weakSelf callBeginPullDownRefreshing];
                    }
                }];
                
                if ([self.delegate respondsToSelector:@selector(pullDownRefreshViewWillStartRefresh:)]) {
                    [self.delegate pullDownRefreshViewWillStartRefresh:self.refreshView];
                }
            }
            break;
        }
        case PGRefreshStatePulling:
        {
            break;
        }
    }
}

#pragma mark - getter
- (UIView *)refreshView
{
    if(_refreshView == nil)
    {
        if([self.delegate respondsToSelector:@selector(pullDownRefreshView)])
        {
            _refreshView = [self.delegate pullDownRefreshView];
        }
    }
    return _refreshView;
}

- (BOOL)bPullDownEnable
{
    BOOL pullDowned = YES;
    if ([self.delegate respondsToSelector:@selector(isPullDownRefreshed)]) {
        pullDowned = [self.delegate isPullDownRefreshed];
        return pullDowned;
    }
    return YES;
}

- (BOOL)bLoadMoreEnable
{
    BOOL loadMored = YES;
    if ([self.delegate respondsToSelector:@selector(isLoadMoreRefreshed)]) {
        loadMored = [self.delegate isLoadMoreRefreshed];
        return loadMored;
    }
    self.loadMoreView.hidden = !loadMored;
    return loadMored;
}

- (CGFloat)refreshTotalPixels
{
    return kPGDefaultRefreshTotalPixels + [self getAdaptorHeight];
}

- (CGFloat)getAdaptorHeight
{
    return self.originalTopInset;
}

- (CGFloat)preloadValue
{
    CGFloat currentValue = 0.0;
    if ([self.delegate respondsToSelector:@selector(preloadDistance)])
    {
        currentValue = [self.delegate preloadDistance];
    }
    return currentValue;
}

- (BOOL)noMoreDataForLoaded
{
    BOOL bNoMore = YES;
    if([self.delegate respondsToSelector:@selector(noMoreDataForLoaded)])
    {
        bNoMore = [self.delegate noMoreDataForLoaded];
    }
    return bNoMore;
}

- (UIView *)loadMoreView
{
    if(!_loadMoreView)
    {
        if([self.delegate respondsToSelector:@selector(loadMoreView)])
        {
            _refreshView = [self.delegate loadMoreView];
        }
    }
    return _loadMoreView;
}

#pragma mark - scrollView
- (void)resetScrollViewContentInset
{
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.top = self.originalTopInset;
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentInset:contentInset];
    } completion:^(BOOL finished) {
        
        self.refreshState = PGRefreshStateNormal;
        
        if ([self.delegate respondsToSelector:@selector(pullDownRefreshViewDidEndRefresh:)]) {
            [self.delegate pullDownRefreshViewDidEndRefresh:self.refreshView];
        }
    }];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset
{
    [self setScrollViewContentInset:contentInset completion:NULL];
}

- (void)setScrollViewContentInset:(UIEdgeInsets)contentInset completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentInset = contentInset;
                     }
                     completion:^(BOOL finished) {
                         if (completion) {
                             completion(YES);
                         }
                         if (finished && self.refreshState == PGRefreshStateStopped) {
                             if (!self.scrollView.isDragging)
                                 self.refreshState = PGRefreshStateNormal;
                         }
                     }];
}

- (void)setScrollViewContentInsetForLoadingCompletion:(void (^)(BOOL finished))completion
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.top = self.refreshTotalPixels;
    [self setScrollViewContentInset:currentInsets completion:completion];
}

- (void)setScrollViewContentInsetForLoadMore
{
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = kPGLoadMoreViewHeight + self.originalBottomInset;
    [self setScrollViewContentInset:currentInsets];
}

- (void)setScrollViewContentInsetForNoLoadMore {
    UIEdgeInsets currentInsets = self.scrollView.contentInset;
    currentInsets.bottom = kPGLoadMoreViewHeight + self.originalBottomInset;
    [self setScrollViewContentInset:currentInsets];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint contentOffset = [[change valueForKey:NSKeyValueChangeNewKey] CGPointValue];
        
        // 上提加载更多的逻辑方法
        if (self.bLoadMoreEnable) {
            int currentPostion = contentOffset.y;
            
            if (currentPostion > 0) {
                
                CGRect bounds = self.scrollView.bounds;//边界
                
                CGSize size = self.scrollView.contentSize;//滚动视图内容区域size
                
                UIEdgeInsets inset = self.scrollView.contentInset;//视图周围额外的滚动视图区域
                
                float y = currentPostion + bounds.size.height + inset.bottom;
                
                //判断是否滚动到底部
                if(((y - size.height) + self.preloadValue) > kPGLoadMoreViewHeight && self.refreshState != PGRefreshStateLoading &&!self.bLoadMoreRefreshing && !self.noMoreDataForLoaded) {
                    [self callBeginLoadMoreRefreshing];
                }
            }
        }
        
        // 下拉刷新的逻辑方法
        if (self.bPullDownEnable) {
            if (!self.bLoadMoreRefreshing) {
                if(self.refreshState != PGRefreshStateLoading) {
                    // 如果不是加载状态的时候
                    
                    CGFloat pullDownOffset = (MIN(ABS(self.scrollView.contentOffset.y + [self getAdaptorHeight]), kPGDefaultRefreshTotalPixels));
                    if (ABS(self.scrollView.contentOffset.y + [self getAdaptorHeight]) >= 0) {
                        if ([self.delegate respondsToSelector:@selector(pullDownRefreshView:withPullDownOffset:)]) {
                            if (self.refreshView) {
                                [self.delegate pullDownRefreshView:self.refreshView withPullDownOffset:pullDownOffset];
                            }
                        }
                    }
                    
                    CGFloat scrollOffsetThreshold;
                    scrollOffsetThreshold = -(kPGDefaultRefreshTotalPixels + self.originalTopInset);
                    
                    if(!self.scrollView.isDragging && self.refreshState == PGRefreshStatePulling) {
                        if (!self.bPullDownRefreshing) {
                            self.bPullDownRefreshing = YES;
                            self.refreshState = PGRefreshStateLoading;
                        }
                    } else if (contentOffset.y < scrollOffsetThreshold && self.scrollView.isDragging && self.refreshState == PGRefreshStateStopped) {
                        self.refreshState = PGRefreshStatePulling;
                    } else if (contentOffset.y >= scrollOffsetThreshold && self.refreshState != PGRefreshStateStopped) {
                        self.refreshState = PGRefreshStateStopped;
                    }
                } else {
                    if (self.bPullDownRefreshing) {
                        CGFloat offset;
                        UIEdgeInsets contentInset;
                        offset = MAX(self.scrollView.contentOffset.y * -1, kPGDefaultRefreshTotalPixels);
                        offset = MIN(offset, self.refreshTotalPixels);
                        contentInset = self.scrollView.contentInset;
                        self.scrollView.contentInset = UIEdgeInsetsMake(offset, contentInset.left, contentInset.bottom, contentInset.right);
                    }
                }
            }
        }
    } else if ([keyPath isEqualToString:@"contentSize"]) {
        CGSize contentSize = [[change valueForKey:NSKeyValueChangeNewKey] CGSizeValue];
        if (self.bLoadMoreEnable && !self.noMoreDataForLoaded && !self.bPullDownRefreshing) {
            CGRect loadMoreViewFrame = self.loadMoreView.frame;
            loadMoreViewFrame.origin.y = contentSize.height;
            self.loadMoreView.frame = loadMoreViewFrame;
            [self setScrollViewContentInsetForLoadMore];
        } else {
            //            CGFloat scrollViewHeight = CGRectGetHeight(self.scrollView.frame);
            //            CGFloat thubs = scrollViewHeight - [self getAdaptorHeight];
            //            if (contentSize.height >= thubs) {
            CGRect loadMoreViewFrame = self.loadMoreView.frame;
            loadMoreViewFrame.origin.y = contentSize.height;
            self.loadMoreView.frame = loadMoreViewFrame;
            //            }
        }
    }
}

@end
