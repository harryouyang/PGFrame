//
//  NSString+encrypt.h
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (encrypt)

+ (NSString *)MD5Encrypt:(NSString *)string;
//纯DES
+ (NSString *)encryptUseDES:(NSString *)clearText key:(NSString *)key;
+ (NSString *)decryptUseDES:(NSString *)plainText key:(NSString *)key;

@end
