//
//  NSDictionary+parse.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "NSDictionary+parse.h"

@implementation NSDictionary (parse)

- (id)objectForKey:(id)aKey type:(EDictionType)type
{
    id value = [self objectForKey:aKey];
    if(value == nil || [value isEqual:[NSNull null]])
    {
        switch((int)type)
        {
            case EDictionTypeNSString:
            case EDictionTypeDate:
            {
                value = @"";
                break;
            }
            case EDictionTypeInt:
            {
                value = [NSNumber numberWithInt:0];
                break;
            }
            case EDictionTypeInteger:
            {
                value = [NSNumber numberWithInteger:0];
                break;
            }
            case EDictionTypeLong:
            {
                value = [NSNumber numberWithLong:0];
                break;
            }
            case EDictionTypeLongLong:
            {
                value = [NSNumber numberWithLongLong:0];
                break;
            }
            case EDictionTypeFloat:
            {
                value = [NSNumber numberWithFloat:0.0];
                break;
            }
            case EDictionTypeDouble:
            {
                value = [NSNumber numberWithDouble:0.0];
                break;
            }
            case EDictionTypeBool:
            {
                value = [NSNumber numberWithBool:NO];
                break;
            }
        }
    }
    return value;
}


- (BOOL)getBoolValueForKey:(NSString *)key defaultValue:(BOOL)defaultValue
{
    return [self objectForKey:key] == [NSNull null] ? defaultValue
    : [[self objectForKey:key] boolValue];
}

- (int)getIntValueForKey:(NSString *)key defaultValue:(int)defaultValue
{
    return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] intValue];
}

- (time_t)getTimeValueForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
    NSString *stringTime   = [self objectForKey:key];
    if ((id)stringTime == [NSNull null]) {
        stringTime = @"";
    }
    struct tm created;
    time_t now;
    time(&now);
    
    if (stringTime) {
        if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL)
        {
            strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
        }
        return mktime(&created);
    }
    return defaultValue;
}

- (long long)getLongLongValueValueForKey:(NSString *)key defaultValue:(long long)defaultValue
{
    return [self objectForKey:key] == [NSNull null]
    ? defaultValue : [[self objectForKey:key] longLongValue];
}

- (NSString *)getStringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    return [self objectForKey:key] == nil || [self objectForKey:key] == [NSNull null]
    ? defaultValue : [self objectForKey:key];
}

@end
