//
//  AlarmTime.m
//  Flounds
//
//  Created by Paul Rest on 8/2/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "AlarmTime.h"

@interface AlarmTime ()

@property (nonatomic, strong, readwrite) NSDate *alarmTimeDate;

@property (nonatomic, readwrite) NSUInteger snoozeMinutesPublic;

@property (nonatomic, strong) NSNumber *snoozeTimePrivate;

@property (nonatomic, strong) NSNumber *active;

@end


@implementation AlarmTime

-(id)initAlarmTime:(NSDate *)alarmTimeDate
 withSnoozeMinutes:(NSUInteger)snoozeMinutes
          asActive:(BOOL)active
    withAlarmSound:(NSString *)alarmSound

{
    return [self initAlarmTime:alarmTimeDate
             withSnoozeMinutes:[NSNumber numberWithInteger:snoozeMinutes]
              withActiveStatus:[NSNumber numberWithBool:active]
            withAlarmSoundName:alarmSound];
}

-(id)initAlarmTime:(NSDate *)alarmTimeDate
 withSnoozeMinutes:(NSNumber *)snoozeMinutes
  withActiveStatus:(NSNumber *)active
withAlarmSoundName:(NSString *)alarmSoundName
{
    if (self = [super init])
    {
        [self setAlarmTime:alarmTimeDate];
        self.snoozeTimePrivate = snoozeMinutes;
        self.snoozeMinutesPublic = [snoozeMinutes integerValue];
        self.active = active;
        self.alarmSoundDisplayName = alarmSoundName;
    }
    return self;
}

NSString *kAlarmTimeKey = @"AlarmTime";
NSString *kAlarmSnoozeKey = @"SnoozeMinutes";
NSString *kActiveKey = @"Active";
NSString *kAlarmSoundDisplayNameKey = @"AlarmSoundName";

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSDate *alarmTime = [aDecoder decodeObjectForKey:kAlarmTimeKey];
    NSNumber *snoozeMinutes = [aDecoder decodeObjectForKey:kAlarmSnoozeKey];
    NSNumber *activeAlarm = [aDecoder decodeObjectForKey:kActiveKey];
    NSString *alarmSoundDisplayName = [aDecoder decodeObjectForKey:kAlarmSoundDisplayNameKey];
    
    return [self initAlarmTime:alarmTime
             withSnoozeMinutes:snoozeMinutes
              withActiveStatus:activeAlarm
            withAlarmSoundName:alarmSoundDisplayName];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_alarmTimeDate forKey:kAlarmTimeKey];
    [aCoder encodeObject:_snoozeTimePrivate forKey:kAlarmSnoozeKey];
    [aCoder encodeObject:_active forKey:kActiveKey];
    [aCoder encodeObject:_alarmSoundDisplayName forKey:kAlarmSoundDisplayNameKey];
}

-(void)setAlarmTime:(NSDate *)alarmTime
{
    if (alarmTime)
    {
        NSDate *alarmTimeHoursMinutesOnly = [NSDateUtility timeWithHoursAndMinutesOnly:alarmTime];
        _alarmTimeDate = alarmTimeHoursMinutesOnly;
    }
}

-(BOOL)isActive
{
    return [self.active isEqualToNumber:[NSNumber numberWithBool:YES]];
}

-(void)flipActiveState
{
    [self isActive] ? [self makeInactive] : [self makeActive];
}

-(void)makeActive
{
    self.active = [NSNumber numberWithBool:YES];
}

-(void)makeInactive
{
    self.active = [NSNumber numberWithBool:NO];
}

-(BOOL)timeMatchesAlarmTimeToTheMinute:(NSDate *)compareTimeDate
{
    NSDate *compareTimeHoursMinutesOnly = [NSDateUtility timeWithHoursAndMinutesOnly:compareTimeDate];
    return [self.alarmTimeDate isEqualToDate:compareTimeHoursMinutesOnly];
}

-(BOOL)timeMatchesAlarmTimeToTheSecond:(NSDate *)compareTimeDate
{
    NSDate *compareTimeHoursMinutesSecondsNanosecondsOnly = [NSDateUtility timeWithHoursMinutesSecondsAndNanosecondsOnly:compareTimeDate];
    
    NSTimeInterval timeIntervalBetweenCompareAndSelf = [self.alarmTimeDate timeIntervalSinceDate:compareTimeHoursMinutesSecondsNanosecondsOnly];
    
    if (timeIntervalBetweenCompareAndSelf <= 0.0 && timeIntervalBetweenCompareAndSelf >= -3.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)setSnooze:(NSUInteger)snoozeMinutes
{
    
}

@end
