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

- (void)startListen;

- (void)executeLocalHot;

- (void)getHotData;

@end
