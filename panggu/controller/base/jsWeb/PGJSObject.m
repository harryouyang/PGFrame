//
//  PGJSObject.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/28.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "PGJSObject.h"
#import "NSDictionary+parse.h"

@implementation PGJSObject

//生成调用JS方法的字符串
- (NSString *)wakeUpNativeJSType:(NSInteger)type param:(NSString *)params
{
    NSString *szParams = [NSString stringWithFormat:@"wakeUpJS(%ld,'%@')",(long)type, params];
    
    return szParams;
}

#pragma mark -
//JS调用此方法并传递参数
- (void)wakeUpNativeObject:(NSString *)message
{
    if(message == nil || [message isKindOfClass:[NSNull class]])
    {
        if(self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(jsErrorMessage:)])
        {
            [self.jsDelegate jsErrorMessage:@"参数为空"];
        }
        return;
    }
    
    NSDictionary *dicInfo = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:kNilOptions
                                                              error:nil];
    
    UCJSType type = [[dicInfo objectForKey:@"type" type:EDictionTypeInteger] integerValue];
    NSObject *obj = [dicInfo objectForKey:@"param"];
    
    if(self.jsDelegate && [self.jsDelegate respondsToSelector:@selector(jsReponse:params:)])
    {
        [self.jsDelegate jsReponse:type params:obj];
    }
}

@end
