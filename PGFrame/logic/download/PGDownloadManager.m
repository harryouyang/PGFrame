//
//  PGDownloadManager.m
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGDownloadManager.h"
#import "NSString+encrypt.h"

static NSOperationQueue * download_manager_creation_queue() {
    static NSOperationQueue *pg_url_manager_creation_queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pg_url_manager_creation_queue = [[NSOperationQueue alloc] init];
        pg_url_manager_creation_queue.maxConcurrentOperationCount = 5;
    });
    
    return pg_url_manager_creation_queue;
}

////////////////////////////////////////////////////////////////
@interface RMDownTask : NSObject
@property(nonatomic, strong)NSURLSessionDownloadTask *task;
@property(nonatomic, strong)NSData *resumeData;
@property(nonatomic, assign)int64_t totalBytesWritten;
@property(nonatomic, assign)int64_t totalBytesExpectedToWrite;
@property(nonatomic, strong)NSString *fileDirectory;
@property(atomic, strong)NSMutableArray *arrayDelegate;
@end

@implementation RMDownTask

- (id)init {
    if(self = [super init]) {
        self.arrayDelegate = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addDelegate:(id<PGDownloadManagerDelegate>)delegate {
    if(delegate != nil) {
        BOOL bFlag = YES;
        for(id aDelegate in self.arrayDelegate) {
            if(aDelegate == delegate) {
                bFlag = NO;
                break;
            }
        }
        
        if(bFlag) {
            [self.arrayDelegate addObject:delegate];
        }
    }
}

- (void)delDelegate:(id<PGDownloadManagerDelegate>)delegate {
    if(delegate != nil) {
        [self.arrayDelegate removeObject:delegate];
    }
}

@end

////////////////////////////////////////////////////////////////
@interface PGDownloadManager ()<NSURLSessionDownloadDelegate>
@property(atomic, strong)NSMutableDictionary *mTasks;
@property(readwrite, nonatomic, strong)NSLock *lock;
@property(nonatomic, strong)NSURLSession *session;
@end

@implementation PGDownloadManager
+ (PGDownloadManager *)shareInstance {
    static dispatch_once_t onceToken;
    static PGDownloadManager *s_downloadManager = nil;
    dispatch_once(&onceToken, ^{
        s_downloadManager = [[PGDownloadManager alloc] init];
        s_downloadManager.mTasks = [[NSMutableDictionary alloc] init];
    });
    
    return s_downloadManager;
}

- (id)init {
    if(self = [super init]) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:download_manager_creation_queue()];
        _lock = [[NSLock alloc] init];
        _lock.name = @"PGDownloadManagerLock";
    }
    return self;
}

- (void)addTask:(NSString *)url fileDirectory:(NSString *)fileDirectory  delegate:(id<PGDownloadManagerDelegate>)delegate {
    NSString *downKey = [NSString MD5Encrypt:url];
    RMDownTask *downTask = [self.mTasks objectForKey:downKey];
    if(downTask) {
        [downTask addDelegate:delegate];
        switch (downTask.task.state) {
            case NSURLSessionTaskStateSuspended:
            {
                [downTask.task resume];
                break;
            }
            case NSURLSessionTaskStateCanceling:
            {
                NSURLSessionDownloadTask *task = [self.session downloadTaskWithResumeData:downTask.resumeData];
                downTask.task = task;
                [task resume];
                break;
            }
            case NSURLSessionTaskStateCompleted:
            {
                if(downTask.totalBytesWritten != downTask.totalBytesExpectedToWrite) {
                    NSURLSessionDownloadTask *task = [self.session downloadTaskWithResumeData:downTask.resumeData];
                    downTask.task = task;
                    [task resume];
                }
                break;
            }
            default:
                break;
        }
    } else {
        NSURLSessionDownloadTask *task = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        downTask = [[RMDownTask alloc] init];
        downTask.task = task;
        [downTask addDelegate:delegate];
        downTask.fileDirectory = fileDirectory;
        [self.lock lock];
        [self.mTasks setObject:downTask forKey:downKey];
        [self.lock unlock];
        [task resume];
    }
}

+ (void)addDownloadTask:(NSString *)url fileDirectory:(NSString *)fileDirectory delegate:(id<PGDownloadManagerDelegate>)delegate {
    
    if(url == nil || url.length < 1) {
        if(delegate && [delegate respondsToSelector:@selector(download:error:)]) {
            NSError *error = [[NSError alloc] initWithDomain:@"链接为空" code:-1 userInfo:nil];
            [delegate download:url error:error];
        }
    } else {
        NSString *path = [NSString stringWithFormat:@"%@/%@",fileDirectory, [NSString MD5Encrypt:url]];
        path = [path stringByAppendingPathExtension:[url pathExtension]];
        if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            if(delegate && [delegate respondsToSelector:@selector(download:didFinish:)]) {
                [delegate download:url didFinish:path];
            }
        } else {
            [[PGDownloadManager shareInstance] addTask:url fileDirectory:fileDirectory delegate:delegate];
        }
    }
}

+ (void)cancelTask:(NSString *)url {
    NSString *downKey = [NSString MD5Encrypt:url];
    RMDownTask *downTask = [[PGDownloadManager shareInstance].mTasks objectForKey:downKey];
    if(downTask) {
        [downTask.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
            downTask.resumeData = resumeData;
        }];
    }
}

+ (void)suspendTask:(NSString *)url {
    NSString *downKey = [NSString MD5Encrypt:url];
    RMDownTask *downTask = [[PGDownloadManager shareInstance].mTasks objectForKey:downKey];
    if(downTask) {
        [downTask.task suspend];
    }
}

+ (void)deleteTask:(NSString *)url {
    NSString *downKey = [NSString MD5Encrypt:url];
    RMDownTask *downTask = [[PGDownloadManager shareInstance].mTasks objectForKey:downKey];
    if(downTask) {
        [downTask.task cancel];
        [[PGDownloadManager shareInstance].mTasks removeObjectForKey:downKey];
    }
}

+ (void)deleteDelegate:(id<PGDownloadManagerDelegate>)delegate url:(NSString *)url {
    NSString *downKey = [NSString MD5Encrypt:url];
    RMDownTask *downTask = [[PGDownloadManager shareInstance].mTasks objectForKey:downKey];
    if(downTask) {
        [downTask delDelegate:delegate];
    }
}

#pragma mark -
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    NSString *url = downloadTask.currentRequest.URL.absoluteString;
    NSString *downKey = [NSString MD5Encrypt:url];
    RMDownTask *downTask = [self.mTasks objectForKey:downKey];
    
    NSString *path = [NSString stringWithFormat:@"%@/%@",downTask.fileDirectory, [NSString MD5Encrypt:url]];
    path = [path stringByAppendingPathExtension:[url pathExtension]];
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:path] error:NULL];
    
    if(downTask) {
        for(id<PGDownloadManagerDelegate> delegate in downTask.arrayDelegate) {
            if(delegate && [delegate respondsToSelector:@selector(download:didFinish:)]) {
                [delegate download:url didFinish:path];
            }
        }
        
        [self.mTasks removeObjectForKey:downKey];
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSString *url = downloadTask.currentRequest.URL.absoluteString;
    NSString *downKey = [NSString MD5Encrypt:url];
    RMDownTask *downTask = [[PGDownloadManager shareInstance].mTasks objectForKey:downKey];
    if(downTask) {
        downTask.totalBytesWritten = totalBytesWritten;
        downTask.totalBytesExpectedToWrite = totalBytesExpectedToWrite;
    }
    
    for(id<PGDownloadManagerDelegate> delegate in downTask.arrayDelegate) {
        if(delegate && [delegate respondsToSelector:@selector(download:totalBytesWritten:totalBytesExpectedToWrite:)]) {
            [delegate download:url totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
        }
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    // 保存恢复数据
    NSString *url = task.currentRequest.URL.absoluteString;
    NSString *downKey = [NSString MD5Encrypt:url];
    RMDownTask *downTask = [self.mTasks objectForKey:downKey];
    if(downTask && error) {
        [self.lock lock];
        downTask.resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
        [self.lock unlock];
    }
    
    if(error) {
        for(id<PGDownloadManagerDelegate> delegate in downTask.arrayDelegate) {
            if(delegate && [delegate respondsToSelector:@selector(download:error:)]) {
                [delegate download:url error:error];
            }
        }
    }
}

@end
