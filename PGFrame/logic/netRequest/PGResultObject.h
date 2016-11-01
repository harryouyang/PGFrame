//
//  PGResultObject.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGResultObject : NSObject
/*
 错误编号
 */
@property(nonatomic, assign)NSInteger nCode;
/*
 错误描述
 */
@property(nonatomic, strong)NSString *szErrorDes;
/*
 接口返回的数据
 */
@property(nonatomic, strong)id dataObject;
/*
 请求传入的扩展参数，原样返回
 */
@property(nonatomic, strong)NSObject *extendParam;
@end
