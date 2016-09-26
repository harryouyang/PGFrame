//
//  PGBaseController+pay.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseController.h"
#import "PGPayManager.h"

typedef void(^PGPayFinishBlock)(PGPayResult *resultObj);
typedef void(^PGPayParamBlock)(NSString *orderId, PGPayType payType);

@interface PGBaseController (pay)<PGPayManagerDelegate>
/*
 支付完成时的block回调
 */
@property(nonatomic, copy)PGPayFinishBlock payFinishBlock;
/*
 获取支付所需的支付参数
 */
@property(nonatomic, copy)PGPayParamBlock payParamBlock;
/*
 订单号
 */
@property(nonatomic, copy)NSString *payOrderId;

/*
 进行支付
 */
- (void)pay:(NSString *)szOrderId;
/*
 用对应的支付方式进行支付
 */
- (void)startPayWithParam:(NSDictionary *)dicParam
                  payType:(PGPayType)payType
                  orderId:(NSString *)szOrderId;

@end
