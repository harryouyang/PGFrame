//
//  PGAnimationItem.m
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import "PGAnimationItem.h"

@implementation PGAnimationItem

+ (id)item
{
    return [[PGAnimationItem alloc] init];
}

+ (id)itemWithDuration:(CGFloat)duration delay:(CGFloat)delay options:(UIViewAnimationOptions)options animations:(PGAnimationBlock)animations
{
    return [[PGAnimationItem alloc] initWithDuration:duration delay:delay options:options animations:animations];
}

- (id)init
{
    return [self initWithDuration:0 delay:0 options:UIViewAnimationOptionCurveLinear animations:NULL];
}

- (id)initWithDuration:(CGFloat)duration delay:(CGFloat)delay options:(UIViewAnimationOptions)options animations:(PGAnimationBlock)animations
{
    self = [super init];
    
    if(self)
    {
        self.duration = duration;
        self.delay = delay;
        self.options = options;
        self.animations = animations;
    }
    
    return self;
}

@end
