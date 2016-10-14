//
//  PGAnimationSequence.m
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import "PGAnimationSequence.h"

@interface PGAnimationSequence ()

@property(nonatomic, assign)BOOL running;
@property(nonatomic, assign)NSUInteger currentGroup;
@property(nonatomic, assign)NSUInteger finishedCount;

- (void)performNextGroup;
- (void)animationFinished;

@end

@implementation PGAnimationSequence

+ (id)sequence
{
    return [[PGAnimationSequence alloc] init];
}

+ (id)sequenceWithAnimationGroups:(NSArray *)groups
{
    return [[PGAnimationSequence alloc] initWithAnimationGroups:groups];
}

+ (id)sequenceWithAnimationGroups:(NSArray *)groups repeat:(BOOL)repeat
{
    return [[PGAnimationSequence alloc] initWithAnimationGroups:groups repeat:repeat];
}

- (id)init
{
    return [self initWithAnimationGroups:nil repeat:NO];
}

- (id)initWithAnimationGroups:(NSArray *)groups
{
    return [self initWithAnimationGroups:groups repeat:NO];
}

- (id)initWithAnimationGroups:(NSArray *)groups repeat:(BOOL)repeat
{
    self = [super init];
    
    if(self) {
        self.groups = groups;
        self.repeat = repeat;
        
        self.running = NO;
    }
    
    return self;
}


#pragma mark -

- (void)start
{
    if(self.running) return;
    
    self.running = YES;
    
    self.currentGroup = 0;
    self.finishedCount = 0;
    
    [self performNextGroup];
}

- (void)stop
{
    self.running = NO;
}

- (void)performNextGroup
{
    if(!self.running) return;
    
    if(self.currentGroup >= self.groups.count)
    {
        if(self.repeat)
        {
            self.running = NO;
            
            [self start];
        }
        
        return;
    }
    
    PGAnimationGroup *group = (PGAnimationGroup *)[self.groups objectAtIndex:self.currentGroup];
    
    for(NSInteger i = 0; i < group.items.count; i++)
    {
        PGAnimationItem *item = (PGAnimationItem *)[group.items objectAtIndex:i];
        
        if(group.waitUntilDone)
        {
            [UIView animateWithDuration:item.duration delay:item.delay options:item.options animations:item.animations completion:^(BOOL finished) {
                [self animationFinished];
            }];
        }
        else
        {
            [UIView animateWithDuration:item.duration delay:item.delay options:item.options animations:item.animations completion:nil];
        }
    }
    
    if(!group.waitUntilDone) {
        self.currentGroup++;
        
        [self performNextGroup];
    }
}

- (void)animationFinished
{
    self.finishedCount++;
    
    PGAnimationGroup *group = (PGAnimationGroup *)[self.groups objectAtIndex:self.currentGroup];
    
    if(self.finishedCount == group.items.count)
    {
        self.finishedCount = 0;
        
        self.currentGroup++;
        [self performNextGroup];
    }
}

@end
