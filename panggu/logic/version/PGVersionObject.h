//
//  PGVersionObject.h
//  PGFrame
//
//  Created by ouyanghua on 16/10/9.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGBaseObj.h"

typedef NS_ENUM(NSInteger, PGVersionUpdateType) {
    VERION_UPDATE_TYPE_NONE = 1,//没有更新
    VERION_UPDATE_TYPE_OPTIONAL,//可选更新
    VERION_UPDATE_TYPE_FORCE,//强制更新
};

@interface PGVersionObject : PGBaseObj

/*
 版本号
 */
@property(nonatomic, strong)NSString *szVersion;
/*
 更新地址
 */
@property(nonatomic, strong)NSString *szUrl;
/*
 更新内容简述
 */
@property(nonatomic, strong)NSString *szDesc;
/*
 0:没有更新，1：有更新，2：强制更新
 */
@property(nonatomic, assign)PGVersionUpdateType updateType;

@end
