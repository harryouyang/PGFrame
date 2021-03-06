//
//  PGHttpClient.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGAPI.h"

@class PGHttpClient;
@protocol PGHttpClientDelegate <NSObject>
@required
- (void)dataRequestSuccess:(PGResultObject *)resultObj client:(PGHttpClient *)client;
- (void)dataRequestFailed:(PGResultObject *)resultObj client:(PGHttpClient *)client;
@optional
- (void)downloadProgress:(NSProgress *)downloadProgress client:(PGHttpClient *)client;
- (void)dataRequestFinish:(NSString *)resultString client:(PGHttpClient *)client;
@end

/*
 根据业务封装Api接口数据
 */
@interface PGHttpClient : NSObject
@property(nonatomic, assign, readonly)PGApiType apiType;
@property(nonatomic, weak)id<PGApiDelegate> apiDelegate;
@property(nonatomic, weak)id<PGHttpClientDelegate> delegate;
@property(nonatomic, copy)NSString *requestMethod;
@property(nonatomic, strong, readonly)NSDictionary *originRequestData;
/*
 扩展参数
 */
@property(nonatomic, strong)NSObject *extendParam;
/*
 请求策略所用的key值，缓存接口数据与读取接口数据时用。
 */
@property(nonatomic, copy)NSString *strategyKey;
/*
 上传文件时的二进制数据
 */
@property(nonatomic, strong)NSData *fileData;

/**
 type: API接口类型
 dicParam: 请求参数
 */
- (instancetype)initWithType:(PGApiType)type requestParam:(NSDictionary *)dicParam;

/**
 开始请求数据
 */
- (void)startRequest;

/**
 取消数据请求
 */
- (void)cancelRequest;

/**
 解析接口返回的json字符数据
 */
- (void)parseData:(NSString *)szString;

/*
 开始上传数据
 */
- (void)startPostImageFileData;

/*
 开始下载文件
 */
- (void)startDownload:(NSString *)fileUrl local:(NSString *)localPath;

@end
