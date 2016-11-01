//
//  NSString+ruleCheck.m
//  PGFrame
//
//  Created by ouyanghua on 16/9/22.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "NSString+ruleCheck.h"

@implementation NSString (ruleCheck)

+ (BOOL)IsImageExtension:(NSString*)szFilename
{
    NSString* ext=[szFilename pathExtension];
    return [ext isEqualToString:@"png"]||[ext isEqualToString:@"jpg"];
}

+ (BOOL)IsNumberString:(NSString *)str
{
    if(str.length<=0)
        return NO;
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^[\\+-]?(?:|0|[0-9]\\d{0,})(?:\\.\\d*)?$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:str
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0, str.length)];
    
    if(numberofMatch > 0)
        return YES;
    
    return NO;
}

- (BOOL)IsNumberString
{
    return [NSString IsNumberString:self];
}

+ (BOOL)isEmailString:(NSString*)str
{
    NSString* exp=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; //@"\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*";
    NSPredicate* Predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",exp];
    return [Predicate evaluateWithObject:str];
}

- (BOOL)isEmailString
{
    return [NSString isEmailString:self];
}

+ (BOOL)isEnglishString:(NSString*)str
{
    NSString* exp=@"^[A-Za-z]+$";
    NSPredicate* Predicate=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",exp];
    return [Predicate evaluateWithObject:str];
}

- (BOOL)isEnglishString
{
    return [NSString isEnglishString:self];
}

+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：139,138,137,136,135,134[0-8],147,150,151,152,157,158,159,182,183,184,187,188
     * 联通：130,131,132,155,156,185,186,145
     * 电信：133,1349,153,180,181,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[0-9]|4[57])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[0127-9]|8[23478]|47)\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,155,156,185,186,145
     17         */
    NSString * CU = @"^1(3[0-2]|5[56]|8[56]|45)\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isMobileNumber
{
    return [NSString isMobileNumber:self];
}

#pragma mark -
const int factor[] = { 7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };//加权因子
const int checktable[] = { 1, 0, 10, 9, 8, 7, 6, 5, 4, 3, 2 };//校验值对应表

+ (BOOL)isIDCard:(NSString *)szIDCard
{
    BOOL result = NO;
    if(szIDCard==nil)
    {
        result = NO;
    }
    else if(szIDCard.length == 18)
    {
        char *ID = (char *)[szIDCard UTF8String];
        int IDNumber[19];
        for(int i = 0; i < 18; i ++)//相当于类型转换
            IDNumber[i] = ID[i] - 48;
        
        
        int checksum = 0;
        for (int i = 0; i < 17; i ++ )
            checksum += IDNumber[i] * factor[i];
        
        if (IDNumber[17] == checktable[checksum % 11] || (ID[17] == 'x' && checktable[checksum % 11] == 10))
            result = YES;
        else
            result = NO;
    }
    else if(szIDCard.length == 15)
    {
        if([szIDCard compare:@"111111111111111"] == NSOrderedSame)
            result = NO;
        else
        {
            NSString *strDate = [NSString stringWithFormat:@"19%@",[szIDCard substringWithRange:NSMakeRange(6, 6)]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            NSDate *date=[dateFormatter dateFromString:strDate];
            if(date != nil)
                result = YES;
            else
                result = NO;
        }
    }
    else
    {
        result = NO;
    }
    return result;
}

- (BOOL)isIDCard
{
    return [NSString isIDCard:self];
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff)
        {
            if (substring.length > 1)
            {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f)
                {
                    returnValue = YES;
                }
            }
        }
        else if(substring.length > 1)
        {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3)
            {
                returnValue = YES;
            }
        }
        else
        {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff)
            {
                returnValue = YES;
            }
            else if (0x2B05 <= hs && hs <= 0x2b07)
            {
                returnValue = YES;
            }
            else if (0x2934 <= hs && hs <= 0x2935)
            {
                returnValue = YES;
            }
            else if (0x3297 <= hs && hs <= 0x3299)
            {
                returnValue = YES;
            }
            else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50)
            {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

@end
