//
//  PGUIKitUtil.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGUIKitUtil.h"
#import "UIImage+PGImage.h"

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

#pragma mark - line
+ (UIView *)createLineFrame:(CGRect)frame lineColor:(UIColor *)color
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    return line;
}

+ (UIView *)createDashLineFrame:(CGRect)frame lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    
    [[lineView layer] addSublayer:shapeLayer];
    
    return lineView;
}

#pragma mark - button
+ (UIButton *)createButton:(CGRect)frame title:(NSString *)szTitle target:(id)target action:(SEL)action
{
    return [PGUIKitUtil createButton:0 frame:frame title:szTitle target:target action:action];
}

+ (UIButton *)createButton:(int)tag frame:(CGRect)frame title:(NSString *)szTitle target:(id)target action:(SEL)action
{
    return [PGUIKitUtil createButton:tag frame:frame bgColor:[UIColor whiteColor] lineColor:nil title:szTitle titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] target:target action:action radius:0.0];
}

+ (UIButton *)createButton:(int)tag frame:(CGRect)frame bgColor:(UIColor *)color lineColor:(UIColor *)lineColor title:(NSString *)szTitle titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action radius:(CGFloat)radius
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.tag = tag;
    btn.frame = frame;
    [btn setBackgroundColor:color];
    if(lineColor)
    {
        btn.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
        btn.layer.borderColor = lineColor.CGColor;
    }
    if(radius > 0.0)
        btn.layer.cornerRadius = radius;
    
    [btn setTitle:szTitle forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

+ (void)setButtonBackImage:(UIImage *)normalImage sel:(UIImage *)selImage button:(UIButton *)button
{
    if(button && [button isKindOfClass:[UIButton class]])
    {
        button.backgroundColor = [UIColor clearColor];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        [button setBackgroundImage:normalImage forState:UIControlStateDisabled];
        if(selImage)
        {
            [button setBackgroundImage:selImage forState:UIControlStateSelected];
            [button setBackgroundImage:selImage forState:UIControlStateHighlighted];
        }
    }
}

+ (void)setButtonBack:(UIColor *)normalColor selColor:(UIColor *)selColor radius:(float)radius button:(UIButton *)button
{
    UIImage *normalImage = nil;
    UIImage *selImage = nil;
    if(radius > 0)
    {
        normalImage = [UIImage createCornerRadiusImageWithColor:normalColor cornerRadius:radius];
        selImage = [UIImage createCornerRadiusImageWithColor:selColor cornerRadius:radius];
        
        normalImage = [normalImage resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)];
        selImage = [selImage resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)];
    }
    else
    {
        normalImage = [UIImage createImageWithColor:normalColor];
        selImage = [UIImage createImageWithColor:selColor];
    }
    
    [PGUIKitUtil setButtonBackImage:normalImage sel:selImage button:button];
}

#pragma mark - Label
+ (UILabel *)createLabel:(NSString *)text frame:(CGRect)frame
{
    return [PGUIKitUtil createLabel:text frame:frame bgColor:[UIColor whiteColor] titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:14] alignment:NSTextAlignmentLeft];
}

+ (UILabel *)createLabel:(NSString *)text frame:(CGRect)frame bgColor:(UIColor *)bgColor titleColor:(UIColor *)titleColor font:(UIFont *)font alignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = bgColor;
    label.textColor = titleColor;
    label.text = text;
    label.font = font;
    label.textAlignment = textAlignment;
    return label;
}

#pragma mark - textField
+ (UITextField *)createTextField:(CGRect)frame
{
    return [PGUIKitUtil createTextField:frame font:[UIFont systemFontOfSize:14]];
}

+ (UITextField *)createTextField:(CGRect)frame font:(UIFont *)font
{
    return [PGUIKitUtil createTextField:frame font:font placeholder:nil];
}

+ (UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder
{
    return [PGUIKitUtil createTextField:frame font:[UIFont systemFontOfSize:14] placeholder:placeholder];
}

+ (UITextField *)createTextField:(CGRect)frame font:(UIFont *)font placeholder:(NSString *)placeholder
{
    return [PGUIKitUtil createTextField:frame placeholder:placeholder keyboardType:UIKeyboardTypeDefault rView:nil font:font borderColor:[UIColor grayColor] radius:0.0];
}

+ (UITextField *)createTextField:(CGRect)frame placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType rView:(UIView *)rView font:(UIFont *)font borderColor:(UIColor *)borderColor radius:(CGFloat)radius
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleNone;
    textField.placeholder = placeholder;
    textField.backgroundColor = [UIColor whiteColor];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.keyboardType = keyboardType;
    textField.textColor = [UIColor blackColor];
    textField.font = font;
    textField.returnKeyType = UIReturnKeyDone;
    
    if(borderColor)
    {
        textField.layer.borderColor = borderColor.CGColor;
    }
    
    if(radius > 0.0)
    {
        textField.layer.cornerRadius = radius;
        textField.layer.borderWidth = 1.0/[UIScreen mainScreen].scale;
    }
    
    UIView *lv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, frame.size.height)];
    lv.backgroundColor = [UIColor whiteColor];
    textField.leftView = lv;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    if(rView)
    {
        textField.rightView = rView;
        textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    return textField;
}

@end
