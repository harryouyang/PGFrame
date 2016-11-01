//
//  PGDataParseManager.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+parse.h"

/**
 数据解析管理器，api所有的接口数据都在此文件中解析，方便维护
 */
@interface PGDataParseManager : NSObject

/**
 登录数据解析
 */
+ (id)parseLogin:(NSDictionary *)dictionary;

@end
