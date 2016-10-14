//
//  PGBaseMoreView.h
//  PGFrame
//
//  Created by ouyanghua on 16/10/14.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PGLoadMoreState) {
    PGLoadMoreState_Normal = 0,
    PGLoadMoreState_Pulling,
    PGLoadMoreState_Loading,
    PGLoadMoreState_Stopped,
    PGLoadMoreState_Dragging
};

@protocol PGMoreViewDelegate <NSObject>
@required
- (BOOL)isLoadMoringData:(UIScrollView *)scrollView;
- (void)willStartLoadMore:(UIScrollView *)scrollView;
- (BOOL)isNeedLoadMoreData:(UIScrollView *)scrollView;
@end

@interface PGBaseMoreView : UIView
@property(nonatomic, assign)float mPullingDistance;
@property(nonatomic, assign)float mLoadingStopInset;
@property(nonatomic, assign)PGLoadMoreState mState;
@property(nonatomic, weak)id<PGMoreViewDelegate> delegate;
@property(nonatomic, strong)UIScrollView *mScrollView;

- (void)setState:(PGLoadMoreState)state;

- (void)stopLoadMore:(UIScrollView *)scrollView;

- (void)loadMoreScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)loadMoreScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
