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

@end
