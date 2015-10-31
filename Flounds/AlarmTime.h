//
//  AlarmTime.h
//  Flounds
//
//  Created by Paul Rest on 8/2/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateUtility.h"

//#import "AlarmSound.h"

@interface AlarmTime : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSDate *alarmTimeDate;

@property (nonatomic, readonly) NSUInteger snoozeMinutesPublic;

@property (nonatomic, strong) NSString *alarmSoundDisplayName;


-(id)initAlarmTime:(NSDate *)alarmTimeDate
 withSnoozeMinutes:(NSUInteger)snoozeMinutes
          asActive:(BOOL)active
    withAlarmSound:(NSString *)alarmSound;

-(BOOL)timeMatchesAlarmTimeToTheMinute:(NSDate *)compareTimeDate;

-(BOOL)timeMatchesAlarmTimeToTheSecond:(NSDate *)compareTimeDate;

-(BOOL)isActive;

-(void)flipActiveState;

-(void)makeActive;

-(void)makeInactive;

-(void)setSnooze:(NSUInteger)snoozeMinutes;

@end
