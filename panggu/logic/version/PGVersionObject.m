//
//  PGVersionObject.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/9.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGVersionObject.h"

@implementation PGVersionObject

- (id)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init])
    {
        self.szVersion = [dic objectForKey:@"new_version" type:EDictionTypeNSString];
        self.szUrl = [dic objectForKey:@"url" type:EDictionTypeNSString];
        self.szDesc = [dic objectForKey:@"version_desc" type:EDictionTypeNSString];
        self.updateType = [[dic objectForKey:@"update_type" type:EDictionTypeInt] integerValue];
    }
    return self;
}

@end
