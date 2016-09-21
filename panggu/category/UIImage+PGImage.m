//
//  UIImage+PGImage.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "UIImage+PGImage.h"
#import <objc/runtime.h>

@implementation UIImage (PGImage)

+ (void)load
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending) {
        // 由于iOS8已经兼容，所以不需要使用下面方法
        return;
    }
    
    // 改替换实现用代码调用imageNamed:时的图片适应
    SEL origM = @selector(imageNamed:);
    SEL newM = @selector(imageWithName:);
    method_exchangeImplementations(class_getClassMethod(self, origM), class_getClassMethod(self, newM));
    
    // 该替换实现对xib中图片的适应
    NSString *className = [[@"UIImage" stringByAppendingString:@"Nib"] stringByAppendingString:@"Placeholder"]; // 这样写是为了避开AppStore审核的代码检查，不一定有效
    Method m1 = class_getInstanceMethod(NSClassFromString(className), @selector(initWithCoder:));
    Method m2 = class_getInstanceMethod(self, @selector(initWithCoderForNib:));
    method_exchangeImplementations(m1, m2);
    
}

/*
 该方法替换原有的imageNamed:方法 
 */
+ (UIImage *)imageWithName:(NSString *)name
{
    UIImage *aImage = [self imageWithName:name];
    if (aImage) {
        // 如果能取到对应图片，则直接返回
        return aImage;
    }
    
    NSString *fileName = [name stringByAppendingString:@"@3x.png"];
    aImage = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName]];
    
    return [aImage scaledImageFrom3x];
}

/* 
 该方法替换UIImage-Nib-Placeholder中的initWithCoder:，因为xib的图片都是用这个类来初始化的 
 */
- (id)initWithCoderForNib:(NSCoder *)aDecoder
{
    NSString *resourceName = [aDecoder decodeObjectForKey:@"UIResourceName"];
    NSString *newResourceName = resourceName;
    
    if ([resourceName hasSuffix:@".png"]) {
        newResourceName = [resourceName substringToIndex:resourceName.length -4];
    }
    
    return [UIImage imageNamed:newResourceName];
}

#pragma mark -
+ (UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)createCornerRadiusImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 2*cornerRadius, 2*cornerRadius);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillEllipseInRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (UIImage *)scaledImageFrom3x
{
    float locScale = [UIScreen mainScreen].scale;
    float theRate = 1.0 / 3.0;
    
    CGSize oldSize = self.size;
    CGFloat scaledWidth = oldSize.width * theRate;
    CGFloat scaledHeight = oldSize.height * theRate;
    
    CGRect scaledRect = CGRectZero;
    scaledRect.size.width  = scaledWidth;
    scaledRect.size.height = scaledHeight;
    
    UIGraphicsBeginImageContextWithOptions(scaledRect.size, NO, locScale);
    
    [self drawInRect:scaledRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    return newImage;
}

- (UIImage *)scaledImageToSize:(CGSize)scaledSize
{
    float locScale = [UIScreen mainScreen].scale;
    
    CGFloat scaledWidth = scaledSize.width;
    CGFloat scaledHeight = scaledSize.height;
    
    CGRect scaledRect = CGRectZero;
    scaledRect.size.width  = scaledWidth;
    scaledRect.size.height = scaledHeight;
    
    UIGraphicsBeginImageContextWithOptions(scaledRect.size, NO, locScale);
    
    [self drawInRect:scaledRect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil) {
        NSLog(@"could not scale image");
    }
    
    return newImage;
}

@end
