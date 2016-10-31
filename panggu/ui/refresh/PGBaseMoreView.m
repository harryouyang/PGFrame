//
//  PGBaseMoreView.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/14.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseMoreView.h"

@implementation PGBaseMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.mPullingDistance = frame.size.height + 20;
        self.mLoadingStopInset = frame.size.height;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        self.mState = PGLoadMoreState_Normal;
    }
    return self;
}

- (void)setState:(PGLoadMoreState)state
{
    _mState = state;
}

- (UIScrollView *)mScrollView
{
    UIScrollView *scrollView = (UIScrollView *)self.superview;
    
    if(![scrollView isKindOfClass:[UIScrollView class]])
        scrollView = nil;
    
    return scrollView;
}

- (void)stopLoadMore:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    self.mState = PGLoadMoreState_Stopped;
}

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.mState == PGLoadMoreState_Loading)
    {
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, self.mLoadingStopInset, 0.0f);
    }
    else
    {
        if(scrollView.isDragging)
        {
            BOOL loading = [self.delegate isLoadMoringData:scrollView];
            float offset = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.bounds.size.height);
            if(!loading && offset > 0 && offset < self.mPullingDistance)
            {
                self.mState = PGLoadMoreState_Normal;
            }
            else if(!loading && offset > self.mPullingDistance)
            {
                self.mState = PGLoadMoreState_Pulling;
            }
            else
            {
                self.mState = PGLoadMoreState_Dragging;
            }
        }
    }
}

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    BOOL needLoad = [self.delegate isNeedLoadMoreData:scrollView];
    BOOL loading = [self.delegate isLoadMoringData:scrollView];
    float offset = scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.bounds.size.height);
    if(needLoad && !loading && offset > self.mPullingDistance)
    {
        [self.delegate willStartLoadMore:scrollView];
        
        self.mState = PGLoadMoreState_Loading;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, self.mLoadingStopInset, 0.0f);
        [UIView commitAnimations];
    }
}

@end
