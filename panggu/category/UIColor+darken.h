//
//  UIColor+darken.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 颜色亮度
 */
@interface UIColor (darken)
/*
 调亮
 */
- (UIColor *)lightenByPercentage:(CGFloat)percentage;
/*
 调暗
 */
- (UIColor *)darkenByPercentage:(CGFloat)percentage;

@end
