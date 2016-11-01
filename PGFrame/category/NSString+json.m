//
//  NSString+json.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "NSString+json.h"
#import "PGBaseObj.h"

@implementation NSString (json)

+ (NSString *) jsonStringWithString:(NSString *)string
{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+ (NSString *)jsonStringWithPGObj:(PGBaseObj *)obj
{
    if(obj != nil && [obj respondsToSelector:@selector(objectToJsonString)])
    {
        return (NSString *)[obj objectToJsonString];
    }
    else
    {
        return @"";
    }
}

+ (NSString *)jsonStringWithNumber:(NSNumber *)number
{
    return number.stringValue;
}

+ (NSString *) jsonStringWithArray:(NSArray *)array
{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array)
    {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value)
        {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+ (NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary
{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++)
    {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value)
        {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+ (NSString *) jsonStringWithObject:(id)object
{
    NSString *value = nil;
    if (!object)
    {
        return value;
    }
    if ([object isKindOfClass:[NSString class]])
    {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]])
    {
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]])
    {
        value = [NSString jsonStringWithArray:object];
    }else if([object isKindOfClass:[NSNumber class]])
    {
        value = [NSString jsonStringWithNumber:object];
    }else if([object isKindOfClass:[PGBaseObj class]])
    {
        value = [NSString jsonStringWithPGObj:object];
    }
    return value;
}

@end
