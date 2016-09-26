//
//  PGPaySheetView.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIButton *(^cellBlock)(NSInteger index);

@interface PGPaySheetView : UIView

@property(nonatomic, copy)void(^mFinished)(NSInteger index);
@property(nonatomic, copy)void(^mCloseView)();

- (id)initWithDataCount:(NSUInteger)count cell:(cellBlock)cellBlock;

- (void)showInView:(UIView *)view;

@end
