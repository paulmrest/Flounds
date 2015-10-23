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
 withSnoozeMinutes:(NSNumber *)snoozeMinutes
  withActiveStatus:(NSNumber *)active
{
    if (self = [super init])
    {
        [self setAlarmTime:alarmTimeDate];
        self.snoozeTimePrivate = snoozeMinutes;
        self.snoozeMinutesPublic = [snoozeMinutes integerValue];
        self.active = active;
    }
    return self;
}

-(id)initAlarmTime:(NSDate *)alarmTimeDate
 withSnoozeMinutes:(NSUInteger)snoozeMinutes
          asActive:(BOOL)active
{
    return [self initAlarmTime:alarmTimeDate
             withSnoozeMinutes:[NSNumber numberWithInteger:snoozeMinutes]
              withActiveStatus:[NSNumber numberWithBool:active]];
}


NSString *kAlarmTimeKey = @"AlarmTime";
NSString *kAlarmSnoozeKey = @"SnoozeMinutes";
NSString *kActiveKey = @"Active";

-(id)initWithCoder:(NSCoder *)aDecoder
{
    NSDate *alarmTime = [aDecoder decodeObjectForKey:kAlarmTimeKey];
    NSNumber *snoozeMinutes = [aDecoder decodeObjectForKey:kAlarmSnoozeKey];
    NSNumber *activeAlarm = [aDecoder decodeObjectForKey:kActiveKey];
    
    return [self initAlarmTime:alarmTime
             withSnoozeMinutes:snoozeMinutes
              withActiveStatus:activeAlarm];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_alarmTimeDate forKey:kAlarmTimeKey];
    [aCoder encodeObject:_snoozeTimePrivate forKey:kAlarmSnoozeKey];
    [aCoder encodeObject:_active forKey:kActiveKey];
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
//    NSDate *compareTimeHoursMinutesSecondsOnly = [NSDateUtility timeWithHoursMinutesAndSecondsOnly:compareTimeDate];
    
    NSDate *compareTimeHoursMinutesSecondsNanosecondsOnly = [NSDateUtility timeWithHoursMinutesSecondsAndNanosecondsOnly:compareTimeDate];
    
    NSTimeInterval timeIntervalBetweenCompareAndSelf = [self.alarmTimeDate timeIntervalSinceDate:compareTimeHoursMinutesSecondsNanosecondsOnly];
    
    //>>>
    NSLog(@"AlarmTime - timeMatchesAlarmTimeToTheSecond...");
    NSLog(@"timeIntervalBetweenCompareAndSelf: %f", timeIntervalBetweenCompareAndSelf);
    //<<<
    
    if (timeIntervalBetweenCompareAndSelf <= 0.0 && timeIntervalBetweenCompareAndSelf >= -3.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
//    return [self.alarmTimeDate isEqualToDate:compareTimeHoursMinutesSecondsOnly];
}

-(void)setSnooze:(NSUInteger)snoozeMinutes
{
    
}

@end
