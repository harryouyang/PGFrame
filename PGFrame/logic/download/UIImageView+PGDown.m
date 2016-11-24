//
//  UIImageView+PGDown.m
//  PGFrame
//
//  Created by ouyanghua on 16/11/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "UIImageView+PGDown.h"
#import <objc/runtime.h>
#import "PGContext.h"
#import "UIImage+PGImage.h"

static char *urlNameKey = "urlNameKey";
static char *placeholderImageNameKey = "placeholderImageNameKey";
static char *fitAreaNameKey = "fitAreaNameKey";
static char *showAnimationNameKey = "showAnimationNameKey";
@implementation UIImageView (PGDown)

- (void)setImageUrl:(NSString *)szUrl {
    objc_setAssociatedObject(self, urlNameKey, szUrl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)imageUrl {
    return objc_getAssociatedObject(self, urlNameKey);
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage {
    objc_setAssociatedObject(self, placeholderImageNameKey, placeholderImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)placeholderImage {
    return objc_getAssociatedObject(self, placeholderImageNameKey);
}

- (void)setBFitArea:(BOOL)bFitArea {
    objc_setAssociatedObject(self, fitAreaNameKey, [NSNumber numberWithBool:bFitArea], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bFitArea {
    NSNumber *number = objc_getAssociatedObject(self, fitAreaNameKey);
    return [number boolValue];
}

- (void)setBShowAnimation:(BOOL)bShowAnimation {
    objc_setAssociatedObject(self, showAnimationNameKey, [NSNumber numberWithBool:bShowAnimation], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)bShowAnimation {
    NSNumber *number = objc_getAssociatedObject(self, showAnimationNameKey);
    return [number boolValue];
}

- (void)reSetNewImage:(UIImage *)image {
    
    self.image = image;
    
    if(self.placeholderImage != image && self.bShowAnimation) {
        CATransition *transition = [CATransition animation];
        transition.duration = 1;
        transition.type = kCATransitionFade;
        transition.timingFunction = UIViewAnimationCurveEaseInOut;
        
        [self.layer addAnimation:transition forKey:@"animation"];
    }
}

#pragma mark -
- (void)setImageWithUrl:(NSString *)szUrl placeholder:(UIImage *)placeholderImage
{
    self.imageUrl = szUrl;
    self.placeholderImage = placeholderImage;
    self.image = placeholderImage;
    
    [PGDownloadManager addDownloadTask:szUrl fileDirectory:[PGContext imagePath] delegate:self];
}

#pragma mark -
- (void)download:(NSString *)urlString didFinish:(NSString *)location {
    if([urlString compare:self.imageUrl] == NSOrderedSame) {
        
        UIImage *image = [UIImage imageWithContentsOfFile:location];
        __weak UIImageView *weakSelf = self;
        if(self.bFitArea) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage *newImage = [image scaledImageToSize:weakSelf.frame.size];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf reSetNewImage:newImage];
                });
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf reSetNewImage:image];
            });
        }
    }
}

- (void)download:(NSString *)urlString error:(NSError *)error {
    if([urlString compare:self.imageUrl] == NSOrderedSame) {
        __weak UIImageView *weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.image = weakSelf.placeholderImage;
        });
    }
}

- (void)download:(NSString *)urlString totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    //    NSLog(@"====>%@ --- %0.2f%%", urlString, (float)(totalBytesWritten * 100.0 /totalBytesExpectedToWrite));
}

@end
