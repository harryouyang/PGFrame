//
//  PGPayManager.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGPayManager.h"
//#import <AlipaySDK/AlipaySDK.h>
//#import "WXApi.h"

#define WX_APP_ID               @"xxxxxxxx"

@implementation PGPayResult
@end

static PGPayManager *s_payManager = nil;
@interface PGPayManager ()//<WXApiDelegate>
@property(nonatomic, copy)NSString *curOrderId;
@property(nonatomic, weak)id<PGPayManagerDelegate> delegate;
@end

#pragma mark -
@implementation PGPayManager

+ (PGPayManager *)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_payManager = [[PGPayManager alloc] init];
    });
    return s_payManager;
}

- (void)handleOpenURL:(NSURL *)url
{
//    __weak PGPayManager *weakSelf = self;
//    if([url.host isEqualToString:@"safepay"]) {
//        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
//            //处理返回结果
//            NSString* resultCode = resultDic[@"resultStatus"];
//            NSInteger code = [resultCode integerValue];
//            
//            PGPayResult *resultObj = [[PGPayResult alloc] init];
//            resultObj.szOrder = weakSelf.curOrderId;
//            
//            if(code == 9000) {
//                resultObj.errorCode = PaySuccess;
//                resultObj.szDesc = @"支付成功";
//            } else if(code == 6001) {
//                resultObj.errorCode = PayErrCodeUserCancel;
//                resultObj.szDesc = @"取消支付";
//            } else {
//                resultObj.errorCode = PayErrCodeCommon;
//                resultObj.szDesc = @"支付失败";
//            }
//            
//            if(weakSelf.delegate)
//            {
//                [weakSelf.delegate payFinished:resultObj];
//            }
//
//        }];
//    } else {
//        [WXApi handleOpenURL:url delegate:self];
//    }
}

- (void)platformInit
{
//    [WXApi registerApp:WX_APP_ID];
}

- (void)startPayWithParam:(NSDictionary *)dicParam orderId:(NSString *)orderId payType:(PGPayType)type delegate:(id<PGPayManagerDelegate>)delegate
{
    self.curOrderId = orderId;
    self.delegate = delegate;
    if(type == PGPayType_WxPay)
    {
//        if([WXApi isWXAppInstalled])
//        {
//            [self startPayForWX:dicParam];
//        }
//        else
//        {
            if(self.delegate)
            {
                [self.delegate noInstallPlatformApp:type orderId:self.curOrderId];
            }
//        }
    }
    else if(type == PGPayType_AliPay)
    {
        [self startPayForAlipay:dicParam];
    }
}

+ (NSString *)getWXAppInstallUrl
{
//    return [WXApi getWXAppInstallUrl];
    return @"";
}

#pragma mark -
- (void)startPayForWX:(NSDictionary *)wxDic
{
//    if(wxDic)
//    {
//        PayReq *payReq = [[PayReq alloc] init];
//        payReq.openID = [wxDic objectForKey:@"appid" type:EDictionTypeNSString];
//        payReq.nonceStr = [wxDic objectForKey:@"noncestr" type:EDictionTypeNSString];
//        payReq.package = @"Sign=WXPay";
//        payReq.partnerId = [wxDic objectForKey:@"partnerid" type:EDictionTypeNSString];
//        payReq.prepayId = [wxDic objectForKey:@"prepayid" type:EDictionTypeNSString];
//        payReq.timeStamp = [[wxDic objectForKey:@"timestamp" type:EDictionTypeLong] unsignedIntValue];
//        payReq.sign = [[wxDic objectForKey:@"sign" type:EDictionTypeNSString] uppercaseString];
//        
//        if(![WXApi sendReq:payReq])
//        {
//            PGPayResult *resultObj = [[PGPayResult alloc] init];
//            resultObj.szOrder = self.curOrderId;
//            resultObj.errorCode = PayErrCodeCommon;
//            resultObj.szDesc = @"支付失败";
//            
//            if(weakSelf.delegate)
//            {
//                [weakSelf.delegate payFinished:resultObj];
//            }
//            
//        }
//    }
}

- (void)startPayForAlipay:(NSDictionary *)aliDic
{
//    NSString *orderString = [aliDic objectForKey:@"orderString" type:EDictionTypeNSString];
//    __weak PGPayManager *weakSelf = self;
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"ucarsyangche" callback:^(NSDictionary *resultDic) {
//        //处理返回结果
//        NSString* resultCode = resultDic[@"resultStatus"];
//        NSInteger code = [resultCode integerValue];
//        
//        PGPayResult *resultObj = [[PGPayResult alloc] init];
//        resultObj.szOrder = weakSelf.curOrderId;
//        
//        if(code == 9000) {
//            resultObj.errorCode = PaySuccess;
//            resultObj.szDesc = @"支付成功";
//        } else if(code == 6001) {
//            resultObj.errorCode = PayErrCodeUserCancel;
//            resultObj.szDesc = @"取消支付";
//        } else {
//            resultObj.errorCode = PayErrCodeCommon;
//            resultObj.szDesc = @"支付失败";
//        }
//        
//        if(weakSelf.delegate)
//        {
//            [weakSelf.delegate payFinished:resultObj];
//        }
//    }];
}

#pragma mark -
//- (void)onResp:(BaseResp *)resp
//{
//    if([resp isKindOfClass:[PayResp class]])
//    {
//        PGPayResult *resultObj = [[PGPayResult alloc] init];
//        resultObj.szOrder = self.curOrderId;
//        PayResp *response = (PayResp *)resp;
//        switch(response.errCode)
//        {
//            case WXSuccess:
//            {
//                resultObj.errorCode = PaySuccess;
//                resultObj.szDesc = @"支付成功";
//                break;
//            }
//            case WXErrCodeUserCancel:
//            {
//                resultObj.errorCode = PayErrCodeUserCancel;
//                resultObj.szDesc = @"取消支付";
//                break;
//            }
//            default:
//            {
//                resultObj.errorCode = PayErrCodeCommon;
//                resultObj.szDesc = @"支付失败";
//                break;
//            }
//        }
//        
//        if(weakSelf.delegate)
//        {
//            [weakSelf.delegate payFinished:resultObj];
//        }
//    }
//}
//
//- (void)onReq:(BaseReq*)req
//{
//}

@end
