//
//  NSDateUtility.h
//  Flounds
//
//  Created by Paul Rest on 10/6/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

const NSUInteger SECONDS_PER_DAY;


@interface NSDateUtility : NSObject

+(NSDate *)timeWithHoursAndMinutesOnly:(NSDate *)date;

+(NSDate *)timeWithHoursMinutesAndSecondsOnly:(NSDate *)date;

+(NSDate *)timeWithHoursMinutesSecondsAndNanosecondsOnly:(NSDate *)date;

//returns an instance of NSDate with the parameter's time but with year, date and month all set to whenever that time next occurs
+(NSDate *)nextOccurrenceOfTime:(NSDate *)date;

+(NSDate *)timeWithCurrDate:(NSDate *)date;

@end
