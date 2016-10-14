//
//  PGBaseRefreshView.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/13.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseRefreshView.h"


@implementation PGBaseRefreshView

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.mPullingDistance = -frame.size.height;
        self.mLoadingStopInset = frame.size.height;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        
        self.mState = PGRefreshState_Normal;
    }
    return self;
}

- (void)setState:(PGRefreshState)state
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

- (void)startRefresh:(UIScrollView *)scrollView
{
    scrollView.contentOffset = CGPointMake(0, self.mPullingDistance);
    self.mState = PGRefreshState_Pulling;
}

- (void)stopRefresh:(UIScrollView *)scrollView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [UIView commitAnimations];
    
    self.mState = PGRefreshState_Stopped;
}

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.mState == PGRefreshState_Loading)
    {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, self.mLoadingStopInset);
        scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
    }
    else
    {
        if(scrollView.isDragging)
        {
            BOOL loading = [self.delegate isLoadingData:scrollView];
            if(!loading && self.mState == PGRefreshState_Pulling &&
               scrollView.contentOffset.y > self.mPullingDistance &&
               scrollView.contentOffset.y < 0.0f)
            {
                self.mState = PGRefreshState_Normal;
            }
            else if(!loading && self.mState == PGRefreshState_Normal &&
                      scrollView.contentOffset.y < self.mPullingDistance)
            {
                self.mState = PGRefreshState_Pulling;
            }
            else
            {
                self.mState = PGRefreshState_Dragging;
            }
            
            if (scrollView.contentInset.top != 0) {
                scrollView.contentInset = UIEdgeInsetsZero;
            }
        }
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    BOOL loading = [self.delegate isLoadingData:scrollView];
    if(!loading && scrollView.contentOffset.y <= self.mPullingDistance)
    {
        [self.delegate willStartRefresh:scrollView];
        
        self.mState = PGRefreshState_Loading;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        scrollView.contentInset = UIEdgeInsetsMake(self.mLoadingStopInset, 0.0f, 0.0f, 0.0f);
        [UIView commitAnimations];
    }
}

@end
