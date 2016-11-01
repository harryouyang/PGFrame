//
//  PGPatchObject.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/25.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseObj.h"

/**
 补丁，用于热修复
 */
@interface PGPatchObject : PGBaseObj
/*
 补丁ID
 */
@property(nonatomic, strong)NSString *mFixID;
/*
 补丁js脚本，最好是加密的脚本，使用时再解密。
 */
@property(nonatomic, strong)NSString *mFixString;

@end
