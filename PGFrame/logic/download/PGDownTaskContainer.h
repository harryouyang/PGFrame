//
//  PGDownTaskContainer.h
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PGDownTaskState) {
    PGDownTaskStateRunning = 0,
    PGDownTaskStateSuspended = 1,
    PGDownTaskStateCanceling = 2,
    PGDownTaskStateCompleted = 3,
    PGDownTaskStateError = 4,
};

@class PGTaskObject;
@protocol PGTaskDelegate <NSObject>
@optional
- (void)taskDidUpdate:(PGTaskObject *)taskObj;
@end

@interface PGTaskObject : NSObject
@property(nonatomic, strong)NSString *mUrl;
@property(nonatomic, strong)NSString *mFileName;
@property(nonatomic, strong)NSString *mLocationPath;
@property(nonatomic, assign)PGDownTaskState mState;
@property(nonatomic, assign)int64_t mTotalBytesWritten;
@property(nonatomic, assign)int64_t mTotalBytesExpectedToWrite;
@property(nonatomic, weak)id<PGTaskDelegate> mDelegate;
@end

//////////////////////////////////////////////////////////
@protocol PGDownTaskContainerDelegate <NSObject>
- (void)taskDidChanged;
@end

/*
 下载容器
 用于一般的下载队列
 */
@interface PGDownTaskContainer : NSObject
@property(nonatomic, weak)id<PGDownTaskContainerDelegate> mDelegate;

+ (void)setContainerDelegate:(id<PGDownTaskContainerDelegate>)delegate;

+ (NSMutableArray *)allTask;

+ (void)addTaskWithUrl:(NSString *)url;

@end
