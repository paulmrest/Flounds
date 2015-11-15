//
//  NSDateUtility.m
//  Flounds
//
//  Created by Paul Rest on 10/6/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

const NSUInteger SECONDS_PER_DAY = 60 * 60 * 24;

#import "NSDateUtility.h"

@implementation NSDateUtility

+(NSDate *)timeWithHoursAndMinutesOnly:(NSDate *)date
{
    unsigned int hoursAndMinutesFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *currCalendar = [NSCalendar currentCalendar];
    NSDateComponents *hoursAndMintuesComponents = [currCalendar components:hoursAndMinutesFlags
                                                                  fromDate:date];
    [hoursAndMintuesComponents setYear:2000]; //creates time offset if year is set at 1
    return [currCalendar dateFromComponents:hoursAndMintuesComponents];
}

+(NSDate *)timeWithHoursMinutesAndSecondsOnly:(NSDate *)date
{
    unsigned int hoursMinutesAndSecondsFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSCalendar *currCalendar = [NSCalendar currentCalendar];
    NSDateComponents *hoursMintuesAndSecondsComponents = [currCalendar components:hoursMinutesAndSecondsFlags
                                                                         fromDate:date];
    [hoursMintuesAndSecondsComponents setYear:2000]; //creates time offset if year is set at 1
    return [currCalendar dateFromComponents:hoursMintuesAndSecondsComponents];
}

+(NSDate *)timeWithHoursMinutesSecondsAndNanosecondsOnly:(NSDate *)date
{
    unsigned int hoursMinutesSecondsAndNanosecondsFlags =
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond;
    NSCalendar *currCalendar = [NSCalendar currentCalendar];
    NSDateComponents *hoursMinutesSecondsAndNanosecondsComponents = [currCalendar components:hoursMinutesSecondsAndNanosecondsFlags
                                                                                    fromDate:date];
    [hoursMinutesSecondsAndNanosecondsComponents setYear:2000];
    return [currCalendar dateFromComponents:hoursMinutesSecondsAndNanosecondsComponents];
}


+(NSDate *)nextOccurrenceOfTime:(NSDate *)date
{
    unsigned int yearMonthDayHoursMinutesSecondsFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *currDate = [NSDate date];
    NSCalendar *currCal = [NSCalendar currentCalendar];
    NSDateComponents *currDateComponents = [currCal components:yearMonthDayHoursMinutesSecondsFlags fromDate:currDate];
        
    NSDateComponents *paramDateComponents = [currCal components:yearMonthDayHoursMinutesSecondsFlags fromDate:date];
    
    [paramDateComponents setYear:currDateComponents.year];
    [paramDateComponents setMonth:currDateComponents.month];
    [paramDateComponents setDay:currDateComponents.day];
    
    NSDate *paramDateWithCurrYearMonthDay = [currCal dateFromComponents:paramDateComponents];

    if ([currDate isEqualToDate:paramDateWithCurrYearMonthDay]) //if param date is the same as currDate, return nil
    {
        return nil;
    }
    else if (currDate == [currDate earlierDate:paramDateWithCurrYearMonthDay]) //if param date will occur in the same day
    {
        return paramDateWithCurrYearMonthDay;
    }
    else //param date will occur the following day
    {
        NSDate *paramDatePlusOneDay = [NSDate dateWithTimeInterval:SECONDS_PER_DAY sinceDate:paramDateWithCurrYearMonthDay];
        return paramDatePlusOneDay;
    }
}

+(NSDate *)timeWithCurrDate:(NSDate *)date
{
    unsigned int yearMonthDayHoursMinutesSecondsFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDate *currDate = [NSDate date];
    NSCalendar *currCal = [NSCalendar currentCalendar];
    NSDateComponents *currDateComponents = [currCal components:yearMonthDayHoursMinutesSecondsFlags fromDate:currDate];
    
    NSDateComponents *paramDateComponents = [currCal components:yearMonthDayHoursMinutesSecondsFlags fromDate:date];
    
    [paramDateComponents setYear:currDateComponents.year];
    [paramDateComponents setMonth:currDateComponents.month];
    [paramDateComponents setDay:currDateComponents.day];
    
    NSDate *paramDateWithCurrYearMonthDay = [currCal dateFromComponents:paramDateComponents];
    return paramDateWithCurrYearMonthDay;
}

@end
