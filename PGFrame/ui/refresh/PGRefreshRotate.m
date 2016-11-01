//
//  PGRefreshRotate.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/13.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGRefreshRotate.h"
#import "PGAnimationSequence.h"

@interface PGRefreshRotate ()
{
    PGAnimationSequence *_sequence;
}
@property(nonatomic, assign)CGFloat angle;
@end

@implementation PGRefreshRotate

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.angle = 0;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-40)/2, (self.frame.size.height-40)/2, 40, 40)];
        self.imageView.image = [UIImage imageNamed:@"refreshRatate.png"];
        
        [self addSubview:self.imageView];
        
        __weak PGRefreshRotate *weakSelf = self;
        PGAnimationItem *item = [PGAnimationItem itemWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveLinear|UIViewAnimationOptionAllowUserInteraction animations:^{
            weakSelf.imageView.transform = CGAffineTransformRotate(weakSelf.imageView.transform, M_PI/2);
        }];
        
        PGAnimationGroup *group = [PGAnimationGroup groupWithItems:@[item]];
        
        _sequence = [[PGAnimationSequence alloc] initWithAnimationGroups:@[group] repeat:YES];
    }
    return self;
}

- (void)setMState:(PGRefreshState)aState
{
    [super setState:aState];
    
    switch (aState)
    {
        case PGRefreshState_Pulling:
        case PGRefreshState_Normal:
        case PGRefreshState_Dragging:
        {
            CGPoint contentOffset = self.mScrollView.contentOffset;
            
            CGFloat angle = contentOffset.y * 180.0 / M_PI * 0.001;
            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, self.angle - angle);
            
            self.angle = angle;
            break;
        }
        case PGRefreshState_Loading:
        {
            [_sequence start];
            break;
        }
        case PGRefreshState_Stopped:
        {
            [_sequence stop];
            break;
        }
        default:
            break;
    }
}

@end
