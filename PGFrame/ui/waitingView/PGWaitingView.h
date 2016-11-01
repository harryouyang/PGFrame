//
//  PGWaitingView.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/21.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGWaitingView : UIView
@property(nonatomic, assign)NSInteger nShowNumCount;

- (void)showText:(NSString *)text;

@end
