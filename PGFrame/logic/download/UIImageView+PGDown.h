//
//  UIImageView+PGDown.h
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGDownloadManager.h"

@interface UIImageView (PGDown)<PGDownloadManagerDelegate>
@property(nonatomic, strong)NSString *imageUrl;
@property(nonatomic, strong)UIImage *placeholderImage;
@property(nonatomic, assign)BOOL bFitArea;
@property(nonatomic, assign)BOOL bShowAnimation;

- (void)setImageWithUrl:(NSString *)szUrl placeholder:(UIImage *)placeholderImage;

@end
