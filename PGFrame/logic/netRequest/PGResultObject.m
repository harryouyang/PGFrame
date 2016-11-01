//
//  PGResultObject.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGResultObject.h"

@implementation PGResultObject

- (id)init
{
    if(self = [super init])
    {
        _nCode = 0;
        _szErrorDes = @"操作成功";
    }
    return self;
}

@end
