//
//  PGUIKitUtil.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGUIKitUtil.h"

@implementation PGUIKitUtil

+ (UIFont *)systemFontOfSize:(CGFloat)size
{
    UIFont *font = [UIFont fontWithName:@"PingFang SC" size:size];
    if(!font)
    {
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}
@end
