//
//  PGEncrypt.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGEncrypt : NSObject

/*
 创建接口签名
 */
+ (NSString *)createSignWith:(NSDictionary *)dictionary;

@end
