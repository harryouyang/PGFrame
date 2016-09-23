//
//  PGContext.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGContext : NSObject
/*
 是否是登录状态
 */
@property(nonatomic, assign)BOOL bLogin;
/*
 是否再次打开App
 */
@property(nonatomic, assign)BOOL bAgainOpen;
/*
 用户账号
 */
@property(nonatomic, copy)NSString *userAccount;
/*
 用户token
 */
@property(nonatomic, copy)NSString *userToken;

+ (PGContext *)shareInstance;
/*
 图片路径
 */
+ (NSString *)imagePath;
/*
 缓存跟用户无关的数据路径
 */
+ (NSString *)dataPathForCache;
/*
 用户相关的数据路径
 */
+ (NSString *)userPathForCache;
/*
 用户数据路径，可用于icloud同步
 */
+ (NSString *)userPathDocument;

/*
 读取通用性的全局数据
 */
- (void)readInfo;
/*
 保存通用性全局数据
 */
- (void)writeInfo;

/*
 创建文件路径
 */
- (void)createFileDir;
/*
 创建用户路径
 */
- (void)createUserDir;

/*
 保存用户密码
 */
- (void)savePsw:(NSString *)szPsw;

/*
 用户用户密码
 */
- (NSString *)getPsw:(NSString *)szuser;

@end
