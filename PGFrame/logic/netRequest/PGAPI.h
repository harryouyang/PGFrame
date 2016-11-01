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
    API_TYPE_PRODUCT_LIST,//产品列表
    API_TYPE_CREATE_ORDER,//创建订单
    API_TYPE_ORDER_PAY,//订单支付
    API_TYPE_APNS_DEVICE_TOKEN,//提交消息推送的deviceToken
    API_TYPE_VERSION_CHECK,//检测版本更新
    API_TYPE_PATCH,//获取补丁
    API_TYPE_FileDownload,//文件下载
};

@protocol PGApiDelegate <NSObject>
@required
- (void)dataRequestFinish:(PGResultObject *)resultObj apiType:(PGApiType)apiType;
@optional
- (void)downloadProgress:(NSProgress *)downloadProgress apiType:(PGApiType)apiType extendParam:(NSObject *)extendParam;
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
