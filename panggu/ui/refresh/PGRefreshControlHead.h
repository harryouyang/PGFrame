//
//  PGRefreshControlHead.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/27.
//  Copyright © 2016年 pangu. All rights reserved.
//

#ifndef PGRefreshControlHead_h
#define PGRefreshControlHead_h

typedef NS_ENUM(NSInteger, PGRefreshState) {
    PGRefreshStatePulling   = 0,
    PGRefreshStateNormal    = 1,
    PGRefreshStateLoading   = 2,
    PGRefreshStateStopped   = 3,
};

typedef NS_ENUM(NSInteger, PGLoadMoreState) {
    PGLoadMoreStatePulling   = 0,
    PGLoadMoreStateNormal    = 1,
    PGLoadMoreStateLoading   = 2,
    PGLoadMoreStateStopped   = 3,
};

#endif /* PGRefreshControlHead_h */
