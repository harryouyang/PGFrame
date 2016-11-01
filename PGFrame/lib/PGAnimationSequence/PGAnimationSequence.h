//
//  PGAnimationSequence.h
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGAnimationGroup.h"
#import "PGAnimationItem.h"

typedef enum {
    PGAnimationSequenceStatePlaying,
    PGAnimationSequenceStateStopped
} PGAnimationSequenceState;

@interface PGAnimationSequence : NSObject

@property(nonatomic, copy)NSArray *groups;
@property(nonatomic, assign)BOOL repeat;

+ (id)sequence;
+ (id)sequenceWithAnimationGroups:(NSArray *)groups;
+ (id)sequenceWithAnimationGroups:(NSArray *)groups repeat:(BOOL)repeat;
- (id)initWithAnimationGroups:(NSArray *)groups;
- (id)initWithAnimationGroups:(NSArray *)groups repeat:(BOOL)repeat;

- (void)start;
- (void)stop;

@end
