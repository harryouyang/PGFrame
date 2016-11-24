//
//  PGDownTaskContainer.m
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGDownTaskContainer.h"
#import "PGDownloadManager.h"
#import "PGContext.h"

static dispatch_queue_t url_down_task_creation_queue() {
    static dispatch_queue_t pg_url_down_task__creation_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pg_url_down_task__creation_queue = dispatch_queue_create("com.pangu.down.task.manager.creation", DISPATCH_QUEUE_CONCURRENT);
    });
    
    return pg_url_down_task__creation_queue;
}

@implementation PGTaskObject
@end

//////////////////////////////////////////////////////////
@interface PGDownTaskContainer ()<PGDownloadManagerDelegate>
@property(atomic, strong)NSMutableArray *mAllTasks;
@end

@implementation PGDownTaskContainer

+ (PGDownTaskContainer *)shareInstance {
    static dispatch_once_t onceToken;
    static PGDownTaskContainer *s_taskContainer;
    dispatch_once(&onceToken, ^{
        s_taskContainer = [[PGDownTaskContainer alloc] init];
    });
    return s_taskContainer;
}

- (id)init {
    if(self = [super init]) {
        self.mAllTasks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)readTaskFromDB {
    
}

- (void)writeTaskToDB {
    
}

- (void)insertIntoDB:(PGTaskObject *)taskObj {
    
    if(self.mDelegate && [self.mDelegate respondsToSelector:@selector(taskDidChanged)]) {
        [self.mDelegate taskDidChanged];
    }
}

- (void)updateDB:(PGTaskObject *)taskObj {
    //
    
    //更新UI
    if(taskObj.mDelegate && [taskObj.mDelegate respondsToSelector:@selector(taskDidUpdate:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [taskObj.mDelegate taskDidUpdate:taskObj];
        });
    }
}

- (PGTaskObject *)findTaskWithUrl:(NSString *)url {
    PGTaskObject *taskobj = nil;
    
    for(PGTaskObject *obj in self.mAllTasks) {
        if([obj.mUrl compare:url] == NSOrderedSame) {
            taskobj = obj;
            break;
        }
    }
    
    return taskobj;
}

#pragma mark -
+ (void)setContainerDelegate:(id<PGDownTaskContainerDelegate>)delegate {
    [PGDownTaskContainer shareInstance].mDelegate = delegate;
}

+ (NSMutableArray *)allTask {
    return [PGDownTaskContainer shareInstance].mAllTasks;
}

+ (void)addTaskWithUrl:(NSString *)url {
    
    if(url == nil || url.length < 1) {
        return;
    }
    
    PGDownTaskContainer *container = [PGDownTaskContainer shareInstance];
    PGTaskObject *taskObj = [container findTaskWithUrl:url];
    
    if(taskObj == nil) {
        PGTaskObject *task = [[PGTaskObject alloc] init];
        task.mUrl = url;
        task.mState = PGDownTaskStateRunning;
        task.mFileName = [url lastPathComponent];
        task.mLocationPath = [[PGContext dataPathForCache] stringByAppendingPathComponent:task.mFileName];
        task.mTotalBytesExpectedToWrite = 0;
        task.mTotalBytesWritten = 0;
        [container.mAllTasks addObject:task];
        
        dispatch_async(url_down_task_creation_queue(), ^{
            [container insertIntoDB:task];
        });
    }
    
    dispatch_async(url_down_task_creation_queue(), ^{
        [PGDownloadManager addDownloadTask:url fileDirectory:[PGContext dataPathForCache] delegate:container];
    });
    
}

#pragma mark -
- (void)download:(NSString *)urlString didFinish:(NSString *)location
{
    PGTaskObject *taskObj = [self findTaskWithUrl:urlString];
    if(taskObj) {
        [[NSFileManager defaultManager] moveItemAtURL:[NSURL fileURLWithPath:location] toURL:[NSURL fileURLWithPath:taskObj.mLocationPath] error:NULL];
        taskObj.mState = PGDownTaskStateCompleted;
        
        dispatch_async(url_down_task_creation_queue(), ^{
            [self updateDB:taskObj];
        });
    }
}

- (void)download:(NSString *)urlString error:(NSError *)error
{
    PGTaskObject *taskObj = [self findTaskWithUrl:urlString];
    if(taskObj) {
        taskObj.mState = PGDownTaskStateError;
        
        dispatch_async(url_down_task_creation_queue(), ^{
            [self updateDB:taskObj];
        });
    }
}

- (void)download:(NSString *)urlString totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    PGTaskObject *taskObj = [self findTaskWithUrl:urlString];
    if(taskObj) {
        taskObj.mTotalBytesWritten = totalBytesWritten;
        taskObj.mTotalBytesExpectedToWrite = totalBytesExpectedToWrite;
        
        dispatch_async(url_down_task_creation_queue(), ^{
            [self updateDB:taskObj];
        });
    }
}

@end
