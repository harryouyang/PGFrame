//
//  PGAPI.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGResultObject.h"

typedef NS_ENUM(NSUInteger, PGApiType) {
    API_TYPE_LOGIN = 1,//登录
    API_TYPE_REGIEST,//注册
};

@protocol PGApiDelegate <NSObject>
@required
- (void)dataRequestSuccess:(PGResultObject *)resultObj;
- (void)dataRequestFailed:(PGResultObject *)resultObj;
@end

@interface PGAPI : NSObject

/*
 获取相应的接口地址
 */
+ (NSString *)urlStringWithType:(PGApiType)type;

/*
 解析数据入口
 */
+ (id)parseDataWithType:(PGApiType)type data:(id)data;

@end
