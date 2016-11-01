//
//  NSString+ruleCheck.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ruleCheck)

+ (BOOL)IsImageExtension:(NSString*)szFilename;

+ (BOOL)IsNumberString:(NSString *)str;
- (BOOL)IsNumberString;

+ (BOOL)isEmailString:(NSString*)str;
- (BOOL)isEmailString;

+ (BOOL)isEnglishString:(NSString*)str;
- (BOOL)isEnglishString;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL)isMobileNumber;

+ (BOOL)isIDCard:(NSString *)szIDCard;
- (BOOL)isIDCard;

+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
