//
//  PGOrderTallyController.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGOrderTallyController.h"
#import "PGUIKitUtil.h"
#import "PGConfig.h"
#import "PGMacroDefHeader.h"
#import "UIColor+darken.h"
#import "PGRequestManager.h"
#import "PGBaseController+pay.h"

@interface PGOrderTallyController ()<PGApiDelegate>

@end

@implementation PGOrderTallyController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"订单结算";
}

- (void)createInitData
{
    [super createInitData];
    
    WEAKSELF
    self.payParamBlock = ^(NSString *orderId, PGPayType payType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf showWaitingView:nil];
            [weakSelf startRequestData:API_TYPE_ORDER_PAY param:@{@"orderId":orderId} extendParma:[NSNumber numberWithInteger:payType]];
        });
    };
    
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
        }
        
        //作相应的页面跳转
        
    };
}

#pragma mark -
- (void)tally
{
    //创建订单
    [self showWaitingView:nil];
    [self startRequestData:API_TYPE_CREATE_ORDER param:@{@"money":@"12.0",@"product":@"乒乓球"}];
}

#pragma mark -
- (void)dataRequestFinish:(PGResultObject *)resultObj apiType:(PGApiType)apiType
{
    [self hideWaitingView];
    if(apiType == API_TYPE_CREATE_ORDER)
    {
        if(resultObj.nCode == 0)
        {
            //
            //获取订单号进行支付
            // ...
            //
            self.payOrderId = @"xxxxxxxxxx";
            
            [self pay:self.payOrderId];
        }
        else
        {
            [self showMsg:resultObj.szErrorDes];
        }
    }
    else if(apiType == API_TYPE_ORDER_PAY)
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
    
    UIButton *tallyButton = [PGUIKitUtil createButton:CGRectMake(PGHeightWith1080(30), self.viewValidHeight- PGHeightWith1080(140)-PGHeightWith1080(30), self.viewWidth-2*PGHeightWith1080(30), PGHeightWith1080(140)) title:@"去结算" target:self action:@selector(tally)];
    [PGUIKitUtil setButtonBack:Color_For_OrangeButton selColor:[Color_For_OrangeButton darkenByPercentage:0.3] radius:3 button:tallyButton];
    [self.view addSubview:tallyButton];
}

@end
