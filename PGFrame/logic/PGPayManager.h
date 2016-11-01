//
//  PGPayManager.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 支付方式
 */
typedef NS_ENUM(NSInteger, PGPayType) {
    PGPayType_None      = 0,//不支付
    PGPayType_WxPay     = 1,//微信支付
    PGPayType_AliPay    = 2,//支付宝支付
};

/*
 支付结果状态
 */
typedef NS_ENUM(NSInteger, PayErrCode) {
    PaySuccess           = 0,    /**< 成功    */
    PayErrCodeCommon     = -1,   /**< 失败    */
    PayErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
};

#pragma mark -
/**
 支付结果
 */
@interface PGPayResult : NSObject
@property(nonatomic, strong)NSString *szOrder;
@property(nonatomic, assign)PayErrCode errorCode;
@property(nonatomic, strong)NSString *szDesc;
@end

#pragma mark -
@protocol PGPayManagerDelegate <NSObject>
@required
/*
 payResult: 支付结果
 */
- (void)payFinished:(PGPayResult *)payResult;
/*
 平台App没有安装
 */
- (void)noInstallPlatformApp:(PGPayType)type orderId:(NSString *)orderId;
@end

#pragma mark -
@interface PGPayManager : NSObject

+ (PGPayManager *)shareInstance;
/*
 支付完成后，应用间的信息传递
 */
- (void)handleOpenURL:(NSURL *)url;
/*
 初始化各支付平台
 */
- (void)platformInit;
/*
 开始支付
 dicParam: 平台SDK支付所需的参数
 type:支付方式
 delegate: 支付完成后的回调
 */
- (void)startPayWithParam:(NSDictionary *)dicParam
                  orderId:(NSString *)orderId
                  payType:(PGPayType)type
                 delegate:(id<PGPayManagerDelegate>)delegate;
/*
 获取微信支付下载地址
 */
+ (NSString *)getWXAppInstallUrl;


@end
