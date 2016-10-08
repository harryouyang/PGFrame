//
//  PGPatchManager.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/25.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGPatchManager : NSObject

+ (PGPatchManager *)shareInstance;

/*
 其实执行是 [JPEngine startEngine]
 */
- (void)startListen;

/*
 执行本要的脚本
 */
- (void)executeLocalHot;

/*
 从服务器上获取新的脚本
 */
- (void)getHotData;

@end
