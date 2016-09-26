//
//  PGUIKitUtil.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

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

////////////////////////////////////////////////
#pragma mark -
@interface PGUIKitUtil : NSObject

+ (UIFont *)systemFontOfSize:(CGFloat)size;

#pragma mark - line
/**
 创建线条
 */
+ (UIView *)createLineFrame:(CGRect)frame lineColor:(UIColor *)color;
/**
 创建虚线条
 */
+ (UIView *)createDashLineFrame:(CGRect)frame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor;

#pragma mark - button
+ (UIButton *)createButton:(CGRect)frame title:(NSString *)szTitle target:(id)target action:(SEL)action;

+ (UIButton *)createButton:(int)tag frame:(CGRect)frame title:(NSString *)szTitle target:(id)target action:(SEL)action;

+ (UIButton *)createButton:(int)tag frame:(CGRect)frame bgColor:(UIColor *)color lineColor:(UIColor *)lineColor title:(NSString *)szTitle titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action radius:(CGFloat)radius;

+ (void)setButtonBackImage:(UIImage *)normalImage sel:(UIImage *)selImage button:(UIButton *)button;
+ (void)setButtonBack:(UIColor *)normalColor selColor:(UIColor *)selColor radius:(float)radius button:(UIButton *)button;

#pragma mark - Label
+ (UILabel *)createLabel:(NSString *)text frame:(CGRect)frame;

+ (UILabel *)createLabel:(NSString *)text frame:(CGRect)frame bgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment;

#pragma mark - textField
+ (UITextField *)createTextField:(CGRect)frame;
+ (UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder;
+ (UITextField *)createTextField:(CGRect)frame font:(UIFont *)font;
+ (UITextField *)createTextField:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder;
+ (UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType rView:(UIView *)rView font:(UIFont *)font borderColor:(UIColor *)borderColor radius:(CGFloat)radius;

@end
