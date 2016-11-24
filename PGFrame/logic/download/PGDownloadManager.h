//
//  PGDownloadManager.h
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PGDownloadManagerDelegate <NSObject>
@optional
- (void)download:(NSString *)urlString didFinish:(NSString *)location;
- (void)download:(NSString *)urlString error:(NSError *)error;
- (void)download:(NSString *)urlString totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite;
@end

/*
 下载管理
 */
@interface PGDownloadManager : NSObject
//添加下载任务
+ (void)addDownloadTask:(NSString *)url
          fileDirectory:(NSString *)fileDirectory
               delegate:(id<PGDownloadManagerDelegate>)delegate;
//取消任务
+ (void)cancelTask:(NSString *)url;
//暂停任务
+ (void)suspendTask:(NSString *)url;
//删除任务
+ (void)deleteTask:(NSString *)url;
//删除delegate
+ (void)deleteDelegate:(id<PGDownloadManagerDelegate>)delegate url:(NSString *)url;
@end
