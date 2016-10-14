//
//  PGAnimationGroup.h
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGAnimationItem.h"


@interface PGAnimationGroup : NSObject

@property(nonatomic, copy)NSArray *items;
@property(nonatomic, assign)BOOL waitUntilDone;

+ (id)group;
+ (id)groupWithItem:(PGAnimationItem *)item;
+ (id)groupWithItems:(NSArray *)items;

- (id)initWithItem:(PGAnimationItem *)item;
- (id)initWithItems:(NSArray *)items;

@end
