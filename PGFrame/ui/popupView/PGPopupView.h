//
//  PGPopupView.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/24.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGPopupView : UIView

/*
 创建popview,子视图由block回调实现自定义样式
 */
- (id)initWithContent:(UIView * (^)(id target, SEL closeSEL))contentBlock;
/*
 添加到view上并显示
 */
- (void)showInView:(UIView *)view;
/*
 关闭
 */
- (void)closeView;

@end
