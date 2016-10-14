//
//  PGBaseRefreshView.h
//  PGFrame
//
//  Created by ouyanghua on 16/10/13.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PGRefreshState) {
    PGRefreshState_Normal = 0,
    PGRefreshState_Pulling,
    PGRefreshState_Loading,
    PGRefreshState_Stopped,
    PGRefreshState_Dragging
};

@protocol PGRefreshViewDelegate <NSObject>
@required
- (BOOL)isLoadingData:(UIScrollView *)scrollView;
- (void)willStartRefresh:(UIScrollView *)scrollView;

@end

#pragma mark -
@interface PGBaseRefreshView : UIView
@property(nonatomic, assign)float mPullingDistance;
@property(nonatomic, assign)float mLoadingStopInset;
@property(nonatomic, assign)PGRefreshState mState;
@property(nonatomic, weak)id<PGRefreshViewDelegate> delegate;
@property(nonatomic, strong)UIScrollView *mScrollView;

- (void)setState:(PGRefreshState)state;

- (void)startRefresh:(UIScrollView *)scrollView;

- (void)stopRefresh:(UIScrollView *)scrollView;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
