//
//  PGRequestManager.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGAPI.h"

@interface PGRequestManager : NSObject

//普通接口请求
/*
 type: 接口标识
 param: 接口参数集合
 extendParam: 扩展参数
 */
+ (void)startPostClient:(PGApiType)type param:(NSDictionary *)param target:(id<PGApiDelegate>)target extendParam:(NSObject *)extendParam;
+ (void)startGetClient:(PGApiType)type param:(NSDictionary *)param target:(id<PGApiDelegate>)target extendParam:(NSObject *)extendParam;

//取消请求
+ (void)cancelClientWithTarget:(id)target type:(PGApiType)type;

@end
