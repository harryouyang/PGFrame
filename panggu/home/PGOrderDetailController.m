//
//  PGOrderDetailController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/25.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGOrderDetailController.h"
#import "PGUIKitUtil.h"
#import "PGConfig.h"
#import "PGMacroDefHeader.h"
#import "UIColor+darken.h"
#import "PGRequestManager.h"
#import "PGBaseController+pay.h"

@interface PGOrderDetailController ()<PGApiDelegate>

@end

@implementation PGOrderDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单详情";
}

- (void)createInitData
{
    [super createInitData];
    
    self.payOrderId = @"订单号xxxxxxx";
    
    WEAKSELF
    self.payParamBlock = ^(NSString *orderId, PGPayType payType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showWaitingView:nil];
            //去服务器端通过订单号与支付方式获取支付所需的参数
            [weakSelf startRequestData:API_TYPE_ORDER_PAY param:@{@"orderId":orderId} extendParma:[NSNumber numberWithInteger:payType]];
        });
    };
    
    //支付完成后回调
    self.payFinishBlock = ^(PGPayResult *result) {
        if(result.errorCode == PaySuccess)
        {
            //支付成功
        }
        else if(result.errorCode == PayErrCodeCommon)
        {
            //支付失败
        }
        else
        {
            //支付取消
            [weakSelf showMsg:result.szDesc];
        }
        
        //作相应的页面跳转
        
    };
}

#pragma mark -
- (void)payOrder
{
    //订单支付
    [self pay:self.payOrderId];
}

#pragma mark - PGApiDelegate
- (void)dataRequestFinish:(PGResultObject *)resultObj apiType:(PGApiType)apiType
{
    [self hideWaitingView];
    if(apiType == API_TYPE_ORDER_PAY)
    {
        if(resultObj.nCode == 0)
        {
            //
            //获取支付所需的参数进行支付
            // ...
            //
            NSDictionary *dicParam = [[NSDictionary alloc] init];
            
            
            NSInteger payType = [(NSNumber *)resultObj.extendParam integerValue];
            [self startPayWithParam:dicParam payType:payType orderId:self.payOrderId];
        }
        else
        {
            [self showMsg:resultObj.szErrorDes];
        }
    }
}

#pragma mark -
- (void)createSubViews
{
    [super createSubViews];
    
    UIButton *payButton = [PGUIKitUtil createButton:CGRectMake(PGHeightWith1080(30), self.viewValidHeight- PGHeightWith1080(140)-PGHeightWith1080(30), self.viewWidth-2*PGHeightWith1080(30), PGHeightWith1080(140)) title:@"支付" target:self action:@selector(payOrder)];
    [PGUIKitUtil setButtonBack:Color_For_OrangeButton selColor:[Color_For_OrangeButton darkenByPercentage:0.3] radius:3 button:payButton];
    [self.view addSubview:payButton];
}


@end
