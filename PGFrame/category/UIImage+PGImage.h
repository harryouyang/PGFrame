//
//  UIImage+PGImage.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PGImage)

/*
 生成纯色图片
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;
/*
 生成纯色圆角图片
 */
+ (UIImage *)createCornerRadiusImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

/*
 将原本3倍尺寸的图片缩放到设备对应尺寸 
 */
- (UIImage *)scaledImageFrom3x;

/*
 图片缩放大小，不等比缩放
 */
- (UIImage *)scaledImageToSize:(CGSize)scaledSize;
@end
