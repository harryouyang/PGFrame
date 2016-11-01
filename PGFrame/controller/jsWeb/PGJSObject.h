//
//  PGJSObject.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef NS_ENUM(NSInteger, UCJSType) {
    EPGJSType_Login = 1,//登录
    EPGJSType_Order,//下单
    EPGJSType_OpenPage_Coupon,//打开优惠券
    
    EPGJSType_Error,//出错时用
};

#pragma mark -
@protocol PGJSObjectDelegate <NSObject>
@optional
- (void)jsReponse:(UCJSType)type params:(NSObject *)params;
- (void)jsErrorMessage:(NSString *)message;
@end

#pragma mark-
@protocol PGJSObjectProtocol <JSExport>
//JS调用此方法并传递参数
- (void)wakeUpNativeObject:(NSString *)message;
@end

#pragma mark-
@interface PGJSObject : NSObject<PGJSObjectProtocol>
@property(nonatomic, weak)id<PGJSObjectDelegate> jsDelegate;

//生成调用JS方法的字符串
- (NSString *)wakeUpNativeJSType:(NSInteger)type param:(NSString *)params;

@end
