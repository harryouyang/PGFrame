//
//  PGBaseObj.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+parse.h"

@interface PGBaseObj : NSObject

- (id)initWithDictionary:(NSDictionary *)dic;

- (NSString *)objectToJsonString;

- (NSDictionary *)objectToDictionary;

@end
