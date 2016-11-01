//
//  NSDictionary+parse.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum dictionType
{
    EDictionTypeNSString = 0,
    EDictionTypeInt,
    EDictionTypeInteger,
    EDictionTypeLong,
    EDictionTypeLongLong,
    EDictionTypeFloat,
    EDictionTypeDouble,
    EDictionTypeBool,
    EDictionTypeDate,
}EDictionType;

@interface NSDictionary (parse)

- (id)objectForKey:(id)aKey type:(EDictionType)type;

- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue;

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue;

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue;

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue;

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

@end
