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


-(NSArray *)getAlarmTimes;

-(NSDate *)getNextActiveAlarm;

-(BOOL)checkAlarmTimes;

-(void)setAlarmSoundForAlarmTime:(NSDate *)alarmTimeDate
                    toAlarmSound:(NSString *)alarmSoundName;



-(NSDate *)alarmTimeAtIndex:(NSUInteger)index;

-(BOOL)alarmTimeIsActiveAtIndex:(NSUInteger)index;

-(void)makeAlarmTimeActiveAtIndex:(NSUInteger)index;

-(void)makeAlarmTimeInactiveAtIndex:(NSUInteger)index;

-(void)flipAlarmActiveState:(NSDate *)alarmTime;


-(BOOL)alarmCurrentlySounding;

-(NSDate *)getCurrentlySoundingAlarm;

-(NSString *)getAlarmSoundForSoundingAlarm;

-(NSString *)getAlarmSoundForAlarmTime:(NSDate *)alarmTimeDate;

-(BOOL)saveCurrentlySoundingAlarmToDisk;

-(BOOL)setCurrentlySoundingAlarmFromDisk;

-(BOOL)clearCurrentlySoundingAlarmFromDisk;

-(void)endCurrentSoundingAlarm;


-(NSTimeInterval)snoozeIntervalForSoundingAlarm;

-(NSUInteger)getDefaultSnoozeMinutes;

-(BOOL)setSnooze:(NSUInteger)newDefaultSnoozeMinutes;

-(NSUInteger)snoozeTimeMinutesForDate:(NSDate *)alarmTimeDate;


-(BOOL)addAlarmTime:(NSDate *)alarmTimeDate
         withSnooze:(NSUInteger)snooze
     withAlarmSound:(NSString *)alarmSound;

-(BOOL)removeAlarmTime:(NSDate *)alarmTime;

-(BOOL)modifyAlarmTime:(NSDate *)oldAlarmTimeDate
      newAlarmTimeDate:(NSDate *)newAlarmTimeDate
newAlarmTimeSnoozeMinutes:(NSUInteger)newAlarmSnoozeMinutes
     newAlarmTimeSound:(NSString *)alarmSound;

@end
