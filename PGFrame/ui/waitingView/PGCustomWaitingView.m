//
//  PGCustomWaitingView.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGCustomWaitingView.h"

@interface PGCustomWaitingView ()
@property(nonatomic, strong)UILabel *content;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)UIActivityIndicatorView *activityView;
@end

@implementation PGCustomWaitingView

- (id)initBgColor:(UIColor *)color apla:(float)apla font:(UIFont *)font textColor:(UIColor *)tColor activeColor:(UIColor *)aColor
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        self.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        self.scrollView.clipsToBounds = YES;
        
        self.content = [[UILabel alloc] initWithFrame:CGRectZero];
        self.content.backgroundColor = [UIColor clearColor];
        self.content.textAlignment = NSTextAlignmentCenter;
        self.content.numberOfLines = 0;
        if(font == nil)
        {
            self.content.font = font;
        }
        else
        {
            self.content.font = [UIFont systemFontOfSize:14];
        }
        if(tColor == nil)
        {
            self.content.textColor = [UIColor whiteColor];
        }
        else
        {
            self.content.textColor = tColor;
        }
        [self.scrollView addSubview:self.content];
        
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.frame = CGRectMake(0, 0, 40, 40);
        [self.activityView startAnimating];
        if(aColor == nil)
        {
            self.activityView.color = [UIColor whiteColor];
        }
        else
        {
            self.activityView.color = aColor;
        }
        [self addSubview:self.activityView];
        
        if(color == nil)
        {
            self.backgroundColor = [UIColor grayColor];
        }
        else
        {
            self.backgroundColor = color;
        }
        self.alpha = apla;
    }
    return self;
}

- (void)showText:(NSString *)text
{
    if(text != nil)
    {
        self.content.text = text;
    }
    else
    {
        self.content.text = @"";
    }
    
    float spaceWidth = 10;
    CGRect frame = CGRectZero;
    
    if(self.content.text != nil && self.content.text.length > 0)
    {
        float maxWidth = 0;
        float maxHeight = 0;
        
        if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            maxWidth = 240;
            maxHeight = 180;
        }
        else
        {
            maxWidth = 400;
            maxHeight = 360;
        }
        
        CGSize size = CGSizeZero;
        size = [self.content.text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                               options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:self.content.font}
                                               context:nil].size;
        
        float width = MAX(size.width, self.activityView.frame.size.width);
        
        self.content.frame = CGRectMake(0, 0, width, size.height);
        if(size.height > maxHeight)
        {
            self.scrollView.frame = CGRectMake(0, 0, width, maxHeight);
            self.scrollView.contentSize = CGSizeMake(width, size.height);
            frame = CGRectMake(0, 0, width+2*spaceWidth, maxHeight+self.activityView.frame.size.height+3*spaceWidth);
        }
        else
        {
            self.scrollView.frame = CGRectMake(0, 0, width, size.height);
            self.scrollView.contentSize = CGSizeMake(width, size.height);
            frame = CGRectMake(0, 0, width+2*spaceWidth, size.height+self.activityView.frame.size.height+3*spaceWidth);
        }
    }
    else
    {
        frame = CGRectMake(0, 0, self.activityView.frame.size.width+2*spaceWidth, self.activityView.frame.size.height+2*spaceWidth);
    }
    
    self.frame = CGRectMake(self.frame.origin.x+(frame.size.width-self.frame.size.width)/2, self.frame.origin.y+(frame.size.height-self.frame.size.height)/2, frame.size.width, frame.size.height);
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    float spaceWidth = 10;
    self.activityView.frame = CGRectMake((self.bounds.size.width-self.activityView.frame.size.width)/2, spaceWidth, self.activityView.frame.size.width, self.activityView.frame.size.height);
    self.scrollView.frame = CGRectMake((self.bounds.size.width-self.scrollView.frame.size.width)/2, CGRectGetMaxY(self.activityView.frame) + spaceWidth, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}

@end
