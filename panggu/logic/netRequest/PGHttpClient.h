//
//  PGHttpClient.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGAPI.h"
/*
 根据业务封装Api接口数据
 */
@interface PGHttpClient : NSObject
@property(nonatomic, assign, readonly)PGApiType apiType;
@property(nonatomic, weak)id<PGApiDelegate> apiDelegate;
@property(nonatomic, strong)NSString *requestMethod;

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

@end
