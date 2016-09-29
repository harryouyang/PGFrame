//
//  PGJSBaseController.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGWebBaseController.h"
#import "PGJSObject.h"

@interface PGJSBaseController : PGWebBaseController<PGJSObjectDelegate>
@property(nonatomic, strong)PGJSObject *jsObj;
@end
