//
//  PGPatchObject.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/25.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGPatchObject.h"

@implementation PGPatchObject

- (id)initWithDictionary:(NSDictionary *)dic
{
    if(self = [super init])
    {
        self.mFixID = [dic objectForKey:@"id" type:EDictionTypeNSString];
        self.mFixString = [dic objectForKey:@"fix" type:EDictionTypeNSString];
    }
    return self;
}

+ (NSMutableArray *)objectsFromArrays:(NSArray *)array
{
    if(array == nil || [array isKindOfClass:[NSNull class]] || array.count <= 0)
        return nil;
    
    NSMutableArray *arrayobj = [[NSMutableArray alloc] init];
    for(NSDictionary *dic in array)
    {
        PGPatchObject *obj = [[PGPatchObject alloc] initWithDictionary:dic];
        [arrayobj addObject:obj];
    }
    
    return arrayobj;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.mFixID forKey:@"mFixID"];
    [aCoder encodeObject:self.mFixString forKey:@"mFixString"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.mFixID = [aDecoder decodeObjectForKey:@"mFixID"];
        self.mFixString = [aDecoder decodeObjectForKey:@"mFixString"];
    }
    return self;
}

@end
