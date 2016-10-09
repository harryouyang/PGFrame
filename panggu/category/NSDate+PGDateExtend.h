//
//  NSDate+PGDateExtend.h
//  PGFrame
//
//  Created by ouyanghua on 16/10/9.
//  Copyright © 2016年 pangu. All rights reserved.
//

#import <Foundation/Foundation.h>

#define yMdHmsS      @"yyyy-MM-dd HH:mm:ss.SSS"

#define yMdHms      @"yyyy-MM-dd HH:mm:ss"

#define yMdHm       @"yyyy-MM-dd HH:mm"

#define yMd       @"yyyy-MM-dd"

@interface NSDate (PGDateExtend)

+ (NSString*)FormatNSDate:(NSDate*)date format:(NSString*)szFormat;

+ (NSDate*)FormatNSStringDate:(NSString*)date format:(NSString*)szFormat;

#pragma mark -
+ (NSInteger)numYearFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;

+ (NSInteger)numMonthFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;

+ (NSInteger)numDayFromDate:(NSDate *)sDate toDate:(NSDate *)eDate;

#pragma mark -
- (NSDate *)cc_dateByMovingToBeginningOfDay;
- (NSDate *)cc_dateByMovingToEndOfDay;
- (NSDate *)cc_dateByMovingToFirstDayOfTheMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfThePreviousMonth;
- (NSDate *)cc_dateByMovingToFirstDayOfTheFollowingMonth;
- (NSDateComponents *)cc_componentsForMonthDayAndYear;
- (NSUInteger)cc_weekday;
- (NSUInteger)cc_numberOfDaysInMonth;

@end
