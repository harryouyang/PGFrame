//
//  PGAnimationItem.h
//  PGUIKit
//
//  Created by ouyanghua on 15/11/20.
//  Copyright © 2015年 PG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PGAnimationBlock)(void);

@interface PGAnimationItem : NSObject

@property(nonatomic, assign)CGFloat duration;
@property(nonatomic, assign)CGFloat delay;
@property(nonatomic, assign)UIViewAnimationOptions options;
@property(nonatomic, copy)PGAnimationBlock animations;

+ (id)item;
+ (id)itemWithDuration:(CGFloat)duration delay:(CGFloat)delay options:(UIViewAnimationOptions)options animations:(PGAnimationBlock)animations;

- (id)initWithDuration:(CGFloat)duration delay:(CGFloat)delay options:(UIViewAnimationOptions)options animations:(PGAnimationBlock)animations;

@end
