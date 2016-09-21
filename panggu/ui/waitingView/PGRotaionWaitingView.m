//
//  PGRotaionWaitingView.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGRotaionWaitingView.h"
#import "PGMacroDefHeader.h"

@interface PGRotaionWaitingView ()
@property(nonatomic, strong)UIImageView *mBgView;
@property(nonatomic, strong)UIImageView *mAnimationView;
@end

@implementation PGRotaionWaitingView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.mBgView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-PGHeightWith1080(210))/2, (frame.size.height-PGHeightWith1080(110))/2, PGHeightWith1080(210), PGHeightWith1080(110))];
        self.mBgView.image = [UIImage imageNamed:@"loading_logo"];
        [self addSubview:self.mBgView];
        
        self.mAnimationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.mAnimationView.image = [UIImage imageNamed:@"loading_round"];
        [self addSubview:self.mAnimationView];
    }
    return self;
}

- (void)showText:(NSString *)text
{
    [self.mAnimationView.layer removeAnimationForKey:@"rotationAnimation"];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    [self.mAnimationView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end
