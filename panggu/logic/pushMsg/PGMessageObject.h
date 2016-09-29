//
//  PGMessageObject.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMessageObject : NSObject
/*
 消息类型,根据业务主义
 */
@property(nonatomic, assign)NSInteger msgType;
/*
 消息内容
 */
@property(nonatomic, strong)NSString *msgContent;
/*
 消息链接地址
 */
@property(nonatomic, strong)NSString *msgUrl;
/*
 消息标题
 */
@property(nonatomic, strong)NSString *msgTitle;
@end
