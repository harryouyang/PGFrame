//
//  PGSimpleMoreView.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/14.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGSimpleMoreView.h"

@interface PGSimpleMoreView ()
@property(nonatomic, strong)UILabel *mTextLabel;
@property(nonatomic, strong)UIActivityIndicatorView *mIndicatorView;
@end

@implementation PGSimpleMoreView

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.mTextLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width-100)/2,(self.frame.size.height-20)/2,100,20)];
        self.mTextLabel.backgroundColor = [UIColor clearColor];
        self.mTextLabel.font = [UIFont systemFontOfSize:14];
        self.mTextLabel.text = @"上拉加载更多";
        self.mTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.mTextLabel];
        
        self.mIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.mIndicatorView.frame = CGRectMake(50,(self.frame.size.height-self.mIndicatorView.frame.size.height)/2,self.mIndicatorView.frame.size.width,self.mIndicatorView.frame.size.height);
        [self addSubview:self.mIndicatorView];
    }
    return self;
}

- (void)setMState:(PGLoadMoreState)aState
{
    [super setState:aState];
    
    switch (aState)
    {
        case PGLoadMoreState_Pulling:
        {
            self.mTextLabel.text = @"释放加载更多";
            [self.mIndicatorView startAnimating];
            break;
        }
        case PGLoadMoreState_Loading:
        {
            self.mTextLabel.text = @"正在加载";
            [self.mIndicatorView startAnimating];
            break;
        }
        case PGLoadMoreState_Normal:
        case PGLoadMoreState_Dragging:
        case PGLoadMoreState_Stopped:
        {
            self.mTextLabel.text = @"上拉加载更多";
            [self.mIndicatorView stopAnimating];
            break;
        }
        default:
            break;
    }
}

@end
