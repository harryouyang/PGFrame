//
//  PGMacroDefHeader.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#ifndef PGMacroDefHeader_h
#define PGMacroDefHeader_h

#ifdef DEBUG
#define PGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PGLog(...)
#endif

#ifdef __OPTIMIZE__
#define NSLog(...)
#endif

#define WEAKSELF    typeof(self) __weak weakSelf = self;
#define STRONGSELF  typeof(weakSelf) __strong strongSelf = weakSelf;

//需要横屏或者竖屏，获取屏幕宽度与高度
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000

#define SCREEN_WIDTH        ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define SCREENH_HEIGHT      ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define SCREEN_SIZE         ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#define SCREEN_SCALE        [UIScreen mainScreen].nativeScale
#else
#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREENH_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE     [UIScreen mainScreen].bounds.size
#define SCREEN_SCALE    [UIScreen mainScreen].scale
#endif

//设置颜色
#define ColorFromRGB(r,g,b)     [UIColor colorWithRed:(float)(r)/255.0 green:(float)(g)/255.0 blue:(float)(b)/255.0 alpha:1]
#define ColorFromRGBA(r,g,b,a)  [UIColor colorWithRed:(float)(r)/255.0 green:(float)(g)/255.0 blue:(float)(b)/255.0 alpha:(a)]
#define UIColorFromRGB(rgbValue) \
[UIColor \
 colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
 blue:((float)(rgbValue & 0x0000FF))/255.0 \
 alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
 colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
 green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
 blue:((float)(rgbValue & 0x0000FF))/255.0 \
 alpha:alphaValue]


//判断当前的iPhone设备/系统版本
//判断是否为iPhone
#define IS_IPHONE   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否为iPad
#define IS_IPAD     (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD     ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])
// 判断是否为 iPhone 5SE
#define iPhone5SE   [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s  [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f

//获取系统版本
#define IOS_SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define IOS9_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending)
#define IOS8_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
#define IOS7_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
#define IOS6_LATER   ([[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending)

//UI 布局
#define PGHeightWith640(height) PGHeightC(640.0, height)
#define PGHeightWith750(height) PGHeightC(750.0, height)
#define PGHeightWith1080(height) PGHeightC(1080.0, height)

CG_INLINE CGFloat PGHeightC(CGFloat reference, CGFloat height)
{
    CGFloat adapterHeight = height;
    
    if([[UIScreen mainScreen] currentMode].size.width == 768.0f ||
       [[UIScreen mainScreen] currentMode].size.width == 1536.0f ||
       [[UIScreen mainScreen] currentMode].size.width == 2048.0f)
    {
        adapterHeight = (height * 640.0 ) / reference;
    }
    else
    {
        adapterHeight = (height * [[UIScreen mainScreen] currentMode].size.width) / reference;
    }
    
    return ceil(adapterHeight/[UIScreen mainScreen].scale);
}

#endif /* PGMacroDefHeader_h */
