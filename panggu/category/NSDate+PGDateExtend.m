//
//  NSDate+PGDateExtend.m
//  PGFrame
//
//  Created by ouyanghua on 16/10/9.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import "NSDate+PGDateExtend.h"

@implementation NSDate (PGDateExtend)

+ (NSString*)FormatNSDate:(NSDate*)date format:(NSString*)szFormat
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:szFormat];
    return [formatter stringFromDate:date];
}

+ (NSDate*)FormatNSStringDate:(NSString*)date format:(NSString*)szFormat
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:szFormat];
    return [formatter dateFromString:date];
}

#pragma mark -
+ (NSInteger)numYearFromDate:(NSDate *)sDate toDate:(NSDate *)eDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit fromDate:sDate toDate:eDate options:0];
    return [comps year];
}

+ (NSInteger)numMonthFromDate:(NSDate *)sDate toDate:(NSDate *)eDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSMonthCalendarUnit fromDate:sDate toDate:eDate options:0];
    return [comps month];
}

+ (NSInteger)numDayFromDate:(NSDate *)sDate toDate:(NSDate *)eDate
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSDayCalendarUnit fromDate:sDate toDate:eDate options:0];
    return [comps day];
}

#pragma mark -
- (NSDate *)cc_dateByMovingToBeginningOfDay
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [parts setHour:0];
    [parts setMinute:0];
    [parts setSecond:0];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToEndOfDay
{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents* parts = [[NSCalendar currentCalendar] components:flags fromDate:self];
    [parts setHour:23];
    [parts setMinute:59];
    [parts setSecond:59];
    return [[NSCalendar currentCalendar] dateFromComponents:parts];
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth
{
    NSDate *d = nil;
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit startDate:&d interval:NULL forDate:self];
    NSAssert1(ok, @"Failed to calculate the first day the month based on %@", self);
    return d;
}

- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.month = -1;
    return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth
{
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.month = 1;
    return [[[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0] cc_dateByMovingToFirstDayOfTheMonth];
}

- (NSDateComponents *)cc_componentsForMonthDayAndYear
{
    return [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
}

- (NSUInteger)cc_weekday
{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:self];
}

- (NSUInteger)cc_numberOfDaysInMonth
{
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:self].length;
}

@end
