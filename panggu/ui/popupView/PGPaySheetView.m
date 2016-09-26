//
//  PGPaySheetView.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGPaySheetView.h"
#import "PGMacroDefHeader.h"
#import "PGUIKitUtil.h"
#import "PGConfig.h"

@interface PGPaySheetView ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong)UIView *contentView;
@property(nonatomic, copy)cellBlock cellBlock;
@property(nonatomic, assign)NSUInteger mCount;
@property(nonatomic, assign)CGFloat contentHeight;
@end

@implementation PGPaySheetView

- (id)initWithDataCount:(NSUInteger)count cell:(cellBlock)cellBlock
{
    if(self = [super init])
    {
        self.mCount = count;
        self.cellBlock = cellBlock;
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
    
    __weak PGPaySheetView *weakSelf = self;
    [UIView animateWithDuration:.25 animations:^{
        weakSelf.backgroundColor = UIColorFromRGBA(0x000000, 0.3);
        [UIView animateWithDuration:.25 animations:^{
            
            weakSelf.contentView.frame = CGRectMake(PGHeightWith1080(30), (self.frame.size.height-self.contentHeight)/2, self.frame.size.width-2*PGHeightWith1080(30), self.contentHeight);
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
    __weak PGPaySheetView *weakSelf = self;
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

- (void)showInView:(UIViewController *)Sview
{
    if(Sview==nil){
        [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    }else{
        [Sview.view addSubview:self];
    }
}

/////////////////
#pragma mark -
- (void)createSubViews
{
    if(!self.contentView) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(PGHeightWith1080(30), 0, self.frame.size.width-2*PGHeightWith1080(30), PGHeightWith1080(80))];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.cornerRadius = 5.0f;
        [self addSubview:self.contentView];
        
        CGFloat y = 0;
        UILabel *tLabel = [PGUIKitUtil createLabel:@"选择支付方式" frame:CGRectMake(0, y, self.contentView.frame.size.width, PGHeightWith1080(128)) bgColor:[UIColor clearColor] titleColor:Color_For_GrayTextColor font:[PGUIKitUtil systemFontOfSize:12] alignment:NSTextAlignmentCenter];
        [self.contentView addSubview:tLabel];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(tLabel.frame.size.width-tLabel.frame.size.height, 0, tLabel.frame.size.height, tLabel.frame.size.height);
        [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [tLabel addSubview:cancelBtn];
        tLabel.userInteractionEnabled = YES;
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PGHeightWith1080(33), PGHeightWith1080(33))];
        iv.image = [UIImage imageNamed:@"icon_del_lab"];
        [cancelBtn addSubview:iv];
        iv.center = CGPointMake(cancelBtn.frame.size.width/2, cancelBtn.frame.size.height/2);
        
        y += tLabel.frame.size.height;
        y += PGHeightWith1080(42);
        
        if(self.cellBlock)
        {
            for(int i = 0; i < self.mCount; i++)
            {
                UIButton *button = self.cellBlock(i);
                button.frame = CGRectMake(PGHeightWith1080(30), y, self.contentView.frame.size.width-2*PGHeightWith1080(30), PGHeightWith1080(136));
                button.tag = i;
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:button];
                y += button.frame.size.height;
                y += PGHeightWith1080(42);
            }
        }
        
        self.contentView.frame = CGRectMake(self.frame.size.width/2, (self.frame.size.height-y)/2, 0, 0);
        self.contentView.clipsToBounds = YES;
        
        self.contentHeight = y;
    }
}

- (void)cancelBtnClicked
{
    if(self.mCloseView) {
        self.mCloseView();
    }
    [self tappedCancel];
}

- (void)buttonClicked:(UIButton *)button
{
    if(self.mFinished)
    {
        self.mFinished(button.tag);
    }
    [self tappedCancel];
}

@end
