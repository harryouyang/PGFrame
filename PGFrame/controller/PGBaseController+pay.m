//
//  PGBaseController+pay.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseController+pay.h"
#import "PGMacroDefHeader.h"
#import "PGPaySheetView.h"
#import "PGBaseController+pay.h"
#import "PGConfig.h"
#import "UIColor+darken.h"
#import <objc/runtime.h>
#import "PGRequestManager.h"

static char *payFinishBlockNameKey = "payFinishBlock";
static char *payParamBlockNameKey = "payParamBlock";
static char *payOrderIdNameKey = "payOrderId";
@implementation PGBaseController (pay)

- (void)setPayFinishBlock:(PGPayFinishBlock)payFinishBlock
{
    objc_setAssociatedObject(self, payFinishBlockNameKey, payFinishBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PGPayFinishBlock)payFinishBlock
{
    return objc_getAssociatedObject(self, payFinishBlockNameKey);
}

- (void)setPayParamBlock:(PGPayParamBlock)payParamBlock
{
    objc_setAssociatedObject(self, payParamBlockNameKey, payParamBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (PGPayParamBlock)payParamBlock
{
    return objc_getAssociatedObject(self, payParamBlockNameKey);
}

- (void)setPayOrderId:(NSString *)payOrderId
{
    objc_setAssociatedObject(self, payOrderIdNameKey, payOrderId, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)payOrderId
{
    return objc_getAssociatedObject(self, payOrderIdNameKey);
}

#pragma mark -
- (void)pay:(NSString *)szOrderId
{
    WEAKSELF
    PGPaySheetView *sheet = [[PGPaySheetView alloc] initWithDataCount:2 cell:^UIButton *(NSInteger index) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if(index == 0) {
            [button setTitle:@"微信支付" forState:UIControlStateNormal];
            [PGUIKitUtil setButtonBack:UIColorFromRGB(0x25d092) selColor:[UIColorFromRGB(0x25d092) darkenByPercentage:0.3] radius:3 button:button];
        } else {
            [button setTitle:@"支付宝支付" forState:UIControlStateNormal];
            [PGUIKitUtil setButtonBack:UIColorFromRGB(0x00aaee) selColor:[UIColorFromRGB(0x00aaee) darkenByPercentage:0.3] radius:3 button:button];
        }
        
        return button;
    }];
    [sheet showInView:nil];
    
    sheet.mFinished = ^(NSInteger index) {
        
        if(weakSelf.payParamBlock)
        {
            if(index == 0)
            {
                weakSelf.payParamBlock(szOrderId, PGPayType_WxPay);
            }
            else
            {
                weakSelf.payParamBlock(szOrderId, PGPayType_AliPay);
            }
        }
    };
    
    sheet.mCloseView = ^() {
        [weakSelf cancelPay:szOrderId];
    };
}

- (void)startPayWithParam:(NSDictionary *)dicParam payType:(PGPayType)payType orderId:(NSString *)szOrderId
{
    [[PGPayManager shareInstance] startPayWithParam:dicParam orderId:szOrderId payType:payType delegate:self];
}

#pragma mark -
- (void)cancelPay:(NSString *)orderId
{
    PGPayResult *resultObj = [[PGPayResult alloc] init];
    resultObj.szOrder = orderId;
    resultObj.szDesc = @"支付取消";
    resultObj.errorCode = PayErrCodeUserCancel;
    
    if(self.payFinishBlock)
    {
        self.payFinishBlock(resultObj);
    }
}

#pragma mark -
/*
 payResult: 支付结果
 */
- (void)payFinished:(PGPayResult *)payResult
{
    if(self.payFinishBlock)
    {
        self.payFinishBlock(payResult);
    }
}

/*
 平台App没有安装
 */
- (void)noInstallPlatformApp:(PGPayType)type orderId:(NSString *)orderId
{
    if(type == PGPayType_WxPay)
    {
        WEAKSELF
        [self showAskAlertTitle:nil message:@"此设备没有安装微信，是否安装？" tag:0 action:^(NSInteger alertTag, NSInteger actionIndex) {
            if(actionIndex == 0)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[PGPayManager getWXAppInstallUrl]]];
            }
            else
            {
                [weakSelf cancelPay:orderId];
            }
            
        } cancelActionTitle:@"安装" otherActionsTitles:@"取消", nil];
    }
}

- (void)cancelPay
{
    
}

@end
