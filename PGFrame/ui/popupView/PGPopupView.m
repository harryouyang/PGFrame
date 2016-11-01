//
//  PGPopupView.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGPopupView.h"
#import "PGMacroDefHeader.h"

@interface PGPopupView ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, assign)CGFloat contentHeight;
@property(nonatomic, assign)CGFloat contentWidth;
@property(nonatomic, copy)UIView *(^mContentBlock)(id target, SEL closeSEL);
@end

@implementation PGPopupView

- (id)initWithContent:(UIView * (^ __nonnull)(id target, SEL closeSEL))contentBlock
{
    if(self = [super init])
    {
        self.mContentBlock = contentBlock;
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENH_HEIGHT);
        self.backgroundColor = ColorFromRGBA(160, 160, 160, 0);
        
        [self createSubViews];
        
        [self animeData];
    }
    return self;
}

- (void)animeData
{
    //self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
    [self addGestureRecognizer:tapGesture];
    tapGesture.delegate = self;
    
    __weak PGPopupView *weakSelf = self;
    [UIView animateWithDuration:.25 animations:^{
        weakSelf.backgroundColor = UIColorFromRGBA(0x000000, 0.7);
        [UIView animateWithDuration:.25 animations:^{
            
            weakSelf.contentView.frame = CGRectMake((self.frame.size.width-self.contentWidth)/2, (self.frame.size.height-self.contentHeight)/2, self.contentWidth, self.contentHeight);
        }];
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[self class]])
    {
        return YES;
    }
    return NO;
}

- (void)tappedCancel
{
    __weak PGPopupView *weakSelf = self;
    [UIView animateWithDuration:.25 animations:^{
        [weakSelf.contentView setFrame:CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0)];
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [weakSelf removeFromSuperview];
        }
    }];
}

- (void)showInView:(UIView *)view
{
    if(view==nil){
        [[UIApplication sharedApplication].delegate.window addSubview:self];
    }else{
        [view addSubview:self];
    }
}

- (void)closeView
{
    [self tappedCancel];
}

/////////////////
#pragma mark -
- (void)createSubViews
{
    if(!self.contentView) {
        if(self.mContentBlock) {
            self.contentView = self.mContentBlock(self, @selector(closeView));
            self.contentHeight = self.contentView.frame.size.height;
            self.contentWidth = self.contentView.frame.size.width;
            self.contentView.frame = CGRectZero;
        } else {
            self.contentView = [[UIView alloc] initWithFrame:CGRectZero];
            self.contentHeight = 0;
        }
        self.contentView.clipsToBounds = YES;
        self.contentView.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height/2, 0, 0);
        [self addSubview:self.contentView];
    }
}

@end
