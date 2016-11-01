//
//  PGCacheManager.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PGCacheType)
{
    ECacheType_ProductList = 1,//产品列表
    
    ECacheType_UserOrderList,//订单列表
    
    ECacheType_Hots,//更新补丁

    ECacheType_Message,//反馈已读消息
    
    ECacheType_ApiStrategy,//接口请求策略缓存的数据
};

@interface PGCacheManager : NSObject

+ (BOOL)cacheData:(NSObject *)data type:(PGCacheType)type;
+ (BOOL)cacheData:(NSObject *)data type:(PGCacheType)type param:(NSObject *)param;

+ (NSObject *)readCacheType:(PGCacheType)type;
+ (NSObject *)readCacheType:(PGCacheType)type param:(NSObject *)param;

/*
 获取缓存数据的大小
 */
+ (float)cacheDataSize;
/*
 清理缓存
 */
+ (void)clearCacheData:(void(^)())finishBlock;

/*
 清理缓存,版本更新后调用。
 */
+ (void)clearCacheDataForNewVersion;

#pragma mark -
/**
 避免API接口频繁的调用。
 */
+ (NSObject *)getApiCacheStringWithKey:(NSString *)key;
/*
 缓存接口数据
 */
+ (BOOL)cacheApiData:(NSString *)apiString key:(NSString *)szKey;

@end
