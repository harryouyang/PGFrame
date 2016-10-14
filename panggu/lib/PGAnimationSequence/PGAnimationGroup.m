//
//  PGAnimationGroup.m
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import "PGAnimationGroup.h"

@implementation PGAnimationGroup

+ (id)group
{
    return [[PGAnimationGroup alloc] init];
}

+ (id)groupWithItem:(PGAnimationItem *)item
{
    return [[PGAnimationGroup alloc] initWithItem:item];
}

+ (id)groupWithItems:(NSArray *)items
{
    return [[PGAnimationGroup alloc] initWithItems:items];
}

- (id)init
{
    return [self initWithItems:nil];
}

- (id)initWithItem:(PGAnimationItem *)item
{
    return [self initWithItems:[NSArray arrayWithObject:item]];
}

- (id)initWithItems:(NSArray *)items
{
    self = [super init];
    
    if(self) {
        self.items = items;
        self.waitUntilDone = YES;
    }
    
    return self;
}


@end
