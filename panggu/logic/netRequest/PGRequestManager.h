//
//  PGRequestManager.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGAPI.h"

@interface PGRequestManager : NSObject

//普通接口请求
+ (void)startPostClient:(PGApiType)type param:(NSDictionary *)param target:(id<PGApiDelegate>)target tag:(NSString *)tag;
+ (void)startGetClient:(PGApiType)type param:(NSDictionary *)param target:(id<PGApiDelegate>)target tag:(NSString *)tag;

//取消请求
+ (void)cancelClientWithTarget:(id)target tag:(NSString *)tag;

@end
