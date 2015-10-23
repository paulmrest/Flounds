//
//  AlarmClockModel.h
//  Flounds
//
//  Created by Paul Rest on 7/6/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmTime.h"
#import "NSDateUtility.h"

extern const NSUInteger MAX_SNOOZE_MINUTES;
extern const NSUInteger MIN_SNOOZE_MINUTES;

extern const NSUInteger PICKERVIEW_COMPONENTS;
extern const NSUInteger SINGLE_PICKERVIEW_COMPONENT;


@interface AlarmClockModel : NSObject

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic) BOOL showTimeIn24HourFormat;

//debugging
//>>>
@property (nonatomic) BOOL debuggingSnoozeInSeconds;
//<<<


-(NSArray *)getAlarmTimes;

-(NSDate *)getNextActiveAlarm;

-(BOOL)checkAlarmTimes;


-(NSDate *)alarmTimeAtIndex:(NSUInteger)index;

-(BOOL)alarmTimeIsActiveAtIndex:(NSUInteger)index;

-(void)makeAlarmTimeActiveAtIndex:(NSUInteger)index;

-(void)makeAlarmTimeInactiveAtIndex:(NSUInteger)index;

-(void)flipAlarmActiveState:(NSDate *)alarmTime;


-(BOOL)alarmCurrentlySounding;

-(BOOL)saveCurrentlySoundingAlarmToDisk;

-(BOOL)setCurrentlySoundingAlarmFromDisk;

-(BOOL)clearCurrentlySoundingAlarmFromDisk;

-(void)endCurrentSoundingAlarm;

-(NSDate *)alarmTimeForSoundingAlarm;


-(NSTimeInterval)snoozeIntervalForSoundingAlarm;

-(NSUInteger)getDefaultSnoozeMinutes;

-(BOOL)setSnooze:(NSUInteger)newDefaultSnoozeMinutes;

-(NSUInteger)snoozeTimeMinutesForDate:(NSDate *)alarmTimeDate;


-(BOOL)addAlarmTime:(NSDate *)alarmTimeDate
         withSnooze:(NSUInteger)snooze;

-(BOOL)removeAlarmTime:(NSDate *)alarmTime;

-(BOOL)modifyAlarmTime:(NSDate *)oldAlarmTimeDate
      newAlarmTimeDate:(NSDate *)newAlarmTimeDate
newAlarmTimeSnoozeMinutes:(NSUInteger)newAlarmSnoozeMinutes;

@end
