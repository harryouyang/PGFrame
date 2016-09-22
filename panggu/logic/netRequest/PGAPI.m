//
//  PGAPI.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGAPI.h"
#import "PGDataParseManager.h"
#import "PGConfig.h"

@implementation PGAPI

+ (NSString *)urlStringWithType:(PGApiType)type
{
    NSString *urlString = nil;
    switch(type)
    {
        case API_TYPE_LOGIN: {
            urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/u/user/login"];
            break;
        }
        case API_TYPE_REGIEST: {
            urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,@"/u/user/regiest"];
            break;
        }
    }
    return urlString;
}

+ (id)parseDataWithType:(PGApiType)type data:(id)data
{
    NSObject *result = nil;
    switch(type)
    {
        case API_TYPE_LOGIN: {
            result = [PGDataParseManager parseLogin:data];
            break;
        }
        case API_TYPE_REGIEST: {
            break;
        }
    }
    return result;
}

@end
