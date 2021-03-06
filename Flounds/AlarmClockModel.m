
//  AlarmClockModel.m
//  Flounds
//
//  Created by Paul Rest on 7/6/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

const NSUInteger NSTIMEINCREMENTS_PER_MINUTE = 60;
const NSUInteger MAX_SNOOZE_MINUTES = 60;
const NSUInteger MIN_SNOOZE_MINUTES = 1;
const NSUInteger DEFAULT_SNOOZE_MINUTES = 9;

const NSUInteger PICKERVIEW_COMPONENTS = 1;
const NSUInteger SINGLE_PICKERVIEW_COMPONENT = 0;

const BOOL DEFAULT_SHOW_24_TIME = NO;


#import "AlarmClockModel.h"

@interface AlarmClockModel ()

@property (nonatomic, strong) NSMutableArray *storedAlarmTimes;
@property (nonatomic, strong) NSURL *alarmTimesURL;

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSDate *nextActiveAlarm;

@property (nonatomic, strong) AlarmTime *soundingAlarm; //nil until an alarm sounds
@property (nonatomic, strong) NSURL *defaultSoundingAlarmURL;

@property (nonatomic) NSUInteger defaultSnoozeTimeMinutes;
@property (nonatomic) NSTimeInterval defaultSnoozeInterval;
@property (nonatomic, strong) NSURL *defaultSnoozeURL;

@property (nonatomic, strong) NSURL *show24TimeURL;

@end


@implementation AlarmClockModel

-(id)init
{
    self = [super init];
    if (self)
    {
        [self dateFormatter];
        [self getShowTimeIN24HourFormatFromDisk];
        [self defaultSnoozeInterval];
    }
    return self;
}

-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    }
    return _dateFormatter;
}

-(NSURL *)show24TimeURL
{
    if (!_show24TimeURL)
    {
        NSArray *possibleStorageURLs = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        if ([possibleStorageURLs count] >= 1)
        {
            NSURL *userDirectoryURL = possibleStorageURLs[0];
            if (userDirectoryURL)
            {
                _show24TimeURL = [userDirectoryURL URLByAppendingPathComponent:@"Show24Time"];
            }
        }
    }
    return _show24TimeURL;
}

-(void)getShowTimeIN24HourFormatFromDisk
{
    NSNumber *show24HourTimeNumber = [NSKeyedUnarchiver unarchiveObjectWithFile:self.show24TimeURL.path];
    if (show24HourTimeNumber)
    {
        self.showTimeIn24HourFormat = [show24HourTimeNumber boolValue];
    }
    else
    {
        self.showTimeIn24HourFormat = DEFAULT_SHOW_24_TIME;
    }
}

-(void)setShowTimeIn24HourFormat:(BOOL)showTimeIn24HourFormat
{
    if (showTimeIn24HourFormat != _showTimeIn24HourFormat)
    {
        _showTimeIn24HourFormat = showTimeIn24HourFormat;
        [NSKeyedArchiver archiveRootObject:[NSNumber numberWithBool:_showTimeIn24HourFormat] toFile:self.show24TimeURL.path];
        NSString *timeFormatString;
        if (showTimeIn24HourFormat)
        {
            timeFormatString = @"HH:mm:ss";
        }
        else
        {
            timeFormatString = @"h:mm:ss a";
        }
        [self.dateFormatter setDateFormat:timeFormatString];
    }
}

-(NSURL *)alarmTimesURL
{
    if (!_alarmTimesURL)
    {
        NSArray *possibleStorageURLs = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        if ([possibleStorageURLs count] >= 1)
        {
            NSURL *userDirectoryURL = possibleStorageURLs[0];
            if (userDirectoryURL)
            {
                _alarmTimesURL = [userDirectoryURL URLByAppendingPathComponent:@"AlarmTimes"];
            }
        }
    }
    return _alarmTimesURL;
}

-(NSMutableArray *)storedAlarmTimes
{
    if (!_storedAlarmTimes)
    {
        _storedAlarmTimes = [NSKeyedUnarchiver unarchiveObjectWithFile:self.alarmTimesURL.path];
        if (!_storedAlarmTimes)
        {
            _storedAlarmTimes = [[NSMutableArray alloc] init];
        }
    }
    return _storedAlarmTimes;
}

-(NSFileManager *)fileManager
{
    if (!_fileManager)
    {
        _fileManager = [[NSFileManager alloc] init];
    }
    return _fileManager;
}

-(NSTimeInterval)defaultSnoozeInterval
{
    if (!_defaultSnoozeInterval)
    {
        NSNumber *defaultSnoozeFromDisk = [NSKeyedUnarchiver unarchiveObjectWithFile:self.defaultSnoozeURL.path];
        NSUInteger defaultSnooze = defaultSnoozeFromDisk ? [defaultSnoozeFromDisk integerValue] : DEFAULT_SNOOZE_MINUTES;
        _defaultSnoozeTimeMinutes = defaultSnooze;
        _defaultSnoozeInterval = defaultSnooze * NSTIMEINCREMENTS_PER_MINUTE;
    }
    return _defaultSnoozeInterval;
}

-(BOOL)setSnooze:(NSUInteger)newDefaultSnoozeMinutes
{
    if (newDefaultSnoozeMinutes >= MIN_SNOOZE_MINUTES && newDefaultSnoozeMinutes <= MAX_SNOOZE_MINUTES)
    {
        NSNumber *snoozeMinutesNumber = [NSNumber numberWithInteger:newDefaultSnoozeMinutes];
        if ([NSKeyedArchiver archiveRootObject:snoozeMinutesNumber toFile:self.defaultSnoozeURL.path])
        {
            self.defaultSnoozeTimeMinutes = newDefaultSnoozeMinutes;
            self.defaultSnoozeInterval = newDefaultSnoozeMinutes * NSTIMEINCREMENTS_PER_MINUTE;
            return YES;
        }
    }
    return NO;
}


-(NSURL *)defaultSnoozeURL
{
    if (!_defaultSnoozeURL)
    {
        NSArray *possibleURLs = [self.fileManager URLsForDirectory:NSCachesDirectory
                                                         inDomains:NSUserDomainMask];
        if ([possibleURLs count] >= 1)
        {
            NSURL *userDirectoryURL = possibleURLs[0];
            if (userDirectoryURL)
            {
                _defaultSnoozeURL = [userDirectoryURL URLByAppendingPathComponent:@"DefaultSnooze"];
            }
        }
    }
    return _defaultSnoozeURL;
}

-(NSURL *)defaultSoundingAlarmURL
{
    if (!_defaultSoundingAlarmURL)
    {
        NSArray *possibleURLs = [self.fileManager URLsForDirectory:NSCachesDirectory
                                                         inDomains:NSUserDomainMask];
        if ([possibleURLs count] >= 1)
        {
            NSURL *userDirectoryURL = possibleURLs[0];
            if (userDirectoryURL)
            {
                _defaultSoundingAlarmURL = [userDirectoryURL URLByAppendingPathComponent:@"SoundingAlarm"];
            }
        }
    }
    return _defaultSoundingAlarmURL;
}

-(NSString *)getAlarmSoundForAlarmTime:(NSDate *)alarmTimeDate
{
    for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
    {
        if ([oneAlarmTime timeMatchesAlarmTimeToTheSecond:alarmTimeDate])
        {
            return oneAlarmTime.alarmSoundDisplayName;
        }
    }
    return nil;
}

-(void)setAlarmSoundForAlarmTime:(NSDate *)alarmTimeDate
                    toAlarmSound:(NSString *)alarmSoundName
{
    for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
    {
        if ([oneAlarmTime timeMatchesAlarmTimeToTheSecond:alarmTimeDate])
        {
            oneAlarmTime.alarmSoundDisplayName = alarmSoundName;
            [self saveStoredAlarmTimesToDisk];
        }
    }
}

-(BOOL)saveCurrentlySoundingAlarmToDisk
{
    return [NSKeyedArchiver archiveRootObject:self.soundingAlarm toFile:self.defaultSoundingAlarmURL.path];
}

-(BOOL)clearCurrentlySoundingAlarmFromDisk
{
    BOOL fileRemoved = NO;
    if ([self.fileManager fileExistsAtPath:self.defaultSoundingAlarmURL.path])
    {
        NSError *removeFileError = nil;
        fileRemoved = [self.fileManager removeItemAtPath:self.defaultSoundingAlarmURL.path
                                                        error:&removeFileError];
        if (fileRemoved && !removeFileError)
        {
            fileRemoved = YES;
        }
    }
    return fileRemoved;
}

-(BOOL)setCurrentlySoundingAlarmFromDisk
{
    self.soundingAlarm = nil;
    self.soundingAlarm = [self getCurrentlySoundingAlarmFromDisk];
    if (self.soundingAlarm)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(AlarmTime *)getCurrentlySoundingAlarmFromDisk
{
    AlarmTime *currentlySoundingAlarmFromDisk = [NSKeyedUnarchiver unarchiveObjectWithFile:self.defaultSoundingAlarmURL.path];
    if (currentlySoundingAlarmFromDisk)
    {
        return currentlySoundingAlarmFromDisk;
    }
    return nil;
}

-(NSUInteger)getDefaultSnoozeMinutes
{
    return self.defaultSnoozeTimeMinutes;
}

-(NSTimeInterval)snoozeIntervalForSoundingAlarm
{
    if (self.soundingAlarm)
    {
        NSUInteger snoozeMinutesForSoundingAlarm = [self.soundingAlarm snoozeMinutesPublic];
        NSTimeInterval snoozeTimeInterval = snoozeMinutesForSoundingAlarm * NSTIMEINCREMENTS_PER_MINUTE;
        return snoozeTimeInterval;
    }
    return 0.0;
}

-(NSUInteger)snoozeTimeMinutesForDate:(NSDate *)alarmTimeDate
{
    for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
    {
        if ([oneAlarmTime timeMatchesAlarmTimeToTheMinute:alarmTimeDate])
        {
            return oneAlarmTime.snoozeMinutesPublic;
        }
    }
    return 0;
}

-(BOOL)alarmCurrentlySounding
{
    return self.soundingAlarm ? YES : NO;
}

-(NSString *)getAlarmSoundForSoundingAlarm
{
    return [self.soundingAlarm.alarmSoundDisplayName copy];
}

-(NSDate *)getCurrentlySoundingAlarm
{
    return [self.soundingAlarm.alarmTimeDate copy];
}

-(void)endCurrentSoundingAlarm
{
    self.soundingAlarm = nil;
    [self determineNextActiveAlarm];
}

-(BOOL)checkAlarmTimes
{
    NSDate *currTime = [NSDate date];
    for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
    {
        if ([oneAlarmTime timeMatchesAlarmTimeToTheSecond:currTime])
        {
            self.soundingAlarm = oneAlarmTime;
            return YES;
        }
    }
    return NO;
}

-(void)determineNextActiveAlarm
{
    NSDate *currDate = [NSDate date];
    NSTimeInterval timeIntervalToAlarm = SECONDS_PER_DAY;
    for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
    {
        if ([oneAlarmTime isActive])
        {
            NSDate *nextOccurrenceOfAlarmTime = [NSDateUtility nextOccurrenceOfTime:oneAlarmTime.alarmTimeDate];
            NSTimeInterval tempComparisonInterval = [nextOccurrenceOfAlarmTime timeIntervalSinceDate:currDate];
            if (tempComparisonInterval < timeIntervalToAlarm)
            {
                timeIntervalToAlarm = tempComparisonInterval;
                self.nextActiveAlarm = nextOccurrenceOfAlarmTime;
            }
        }
    }
}

-(NSDate *)getNextActiveAlarm
{
    return [self.nextActiveAlarm dateByAddingTimeInterval:0.0];
}

-(NSArray *)getAlarmTimes
{
    return [NSArray arrayWithArray:self.storedAlarmTimes];
}

-(BOOL)addAlarmTime:(NSDate *)alarmTimeDate
         withSnooze:(NSUInteger)snooze
     withAlarmSound:(NSString *)alarmSound
{
    if (alarmTimeDate)
    {
        if (![self alarmTimeAlreadyPresent:alarmTimeDate])
        {
            AlarmTime *newAlarmTime = [[AlarmTime alloc] initAlarmTime:alarmTimeDate
                                                     withSnoozeMinutes:snooze
                                                              asActive:YES
                                                        withAlarmSound:alarmSound];
            [self.storedAlarmTimes addObject:newAlarmTime];
            [self saveStoredAlarmTimesToDisk];
            [self determineNextActiveAlarm];
            return YES;
        }
    }
    return NO;
}

-(BOOL)removeAlarmTime:(NSDate *)alarmTimeDate
{
    if (alarmTimeDate)
    {
        AlarmTime *alarmTimeToRemove = nil;
        for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
        {
            if ([oneAlarmTime timeMatchesAlarmTimeToTheMinute:alarmTimeDate])
            {
                alarmTimeToRemove = oneAlarmTime;
                break;
            }
        }
        if (alarmTimeToRemove)
        {
            [self.storedAlarmTimes removeObject:alarmTimeToRemove];
            if ([self saveStoredAlarmTimesToDisk])
            {
                [self determineNextActiveAlarm];
                return YES;
            }
        }
    }
    return NO;
}

-(BOOL)modifyAlarmTime:(NSDate *)oldAlarmTimeDate
      newAlarmTimeDate:(NSDate *)newAlarmTimeDate
newAlarmTimeSnoozeMinutes:(NSUInteger)newAlarmSnoozeMinutes
     newAlarmTimeSound:(NSString *)newAlarmSound
{
    if (oldAlarmTimeDate)
    {
        AlarmTime *oldAlarmTime = nil;
        for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
        {
            if ([oneAlarmTime timeMatchesAlarmTimeToTheMinute:oldAlarmTimeDate])
            {
                oldAlarmTime = oneAlarmTime;
                break;
            }
        }
        if (oldAlarmTime)
        {
            if (newAlarmTimeDate)
            {
                if (![self alarmTimeAlreadyPresent:newAlarmTimeDate] ||
                    (newAlarmSnoozeMinutes != oldAlarmTime.snoozeMinutesPublic) ||
                    ![newAlarmSound isEqualToString:oldAlarmTime.alarmSoundDisplayName])
                {
                    AlarmTime *newAlarmTime = [[AlarmTime alloc] initAlarmTime:newAlarmTimeDate
                                                             withSnoozeMinutes:newAlarmSnoozeMinutes
                                                                      asActive:[oldAlarmTime isActive]
                                                                withAlarmSound:newAlarmSound];
                    
                    [self.storedAlarmTimes replaceObjectAtIndex:[self.storedAlarmTimes indexOfObject:oldAlarmTime]
                                                     withObject:newAlarmTime];
                    if ([self saveStoredAlarmTimesToDisk])
                    {
                        [self determineNextActiveAlarm];
                        return YES;
                    }
                }
            }            
        }
    }
    return NO;
}


-(void)flipAlarmActiveState:(NSDate *)alarmTimeDate
{
    if (alarmTimeDate)
    {
        for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
        {
            if ([oneAlarmTime timeMatchesAlarmTimeToTheMinute:alarmTimeDate])
            {
                [oneAlarmTime flipActiveState];
                [self saveStoredAlarmTimesToDisk];
                [self determineNextActiveAlarm];
            }
        }
    }
}

-(BOOL)saveStoredAlarmTimesToDisk
{
    BOOL saveSuccess = [NSKeyedArchiver archiveRootObject:self.storedAlarmTimes toFile:self.alarmTimesURL.path];
    if (saveSuccess)
    {
        return YES;
    }
    return NO;
}

-(BOOL)alarmTimeAlreadyPresent:(NSDate *)alarmTime
{
    for (AlarmTime *oneAlarmTime in self.storedAlarmTimes)
    {
        if ([oneAlarmTime timeMatchesAlarmTimeToTheMinute:alarmTime])
        {
            return YES;
        }
    }
    return NO;
}

-(NSDate *)alarmTimeAtIndex:(NSUInteger)index
{
    if ([self.storedAlarmTimes count] != 0)
    {
        if (index <= ([self.storedAlarmTimes count] - 1))
        {
            return [[self.storedAlarmTimes objectAtIndex:index] alarmTimeDate];
        }
    }
    return nil;
}

-(BOOL)alarmTimeIsActiveAtIndex:(NSUInteger)index
{
    if (index <= ([self.storedAlarmTimes count] - 1))
    {
        return [[self.storedAlarmTimes objectAtIndex:index] isActive];
    }
    return NO;
}

-(void)makeAlarmTimeActiveAtIndex:(NSUInteger)index
{
    if (index <= ([self.storedAlarmTimes count] - 1))
    {
        [[self.storedAlarmTimes objectAtIndex:index] makeActive];
        [self saveStoredAlarmTimesToDisk];
    }
}

-(void)makeAlarmTimeInactiveAtIndex:(NSUInteger)index
{
    if (index <= ([self.storedAlarmTimes count] - 1))
    {
        [[self.storedAlarmTimes objectAtIndex:index] makeInactive];
        [self saveStoredAlarmTimesToDisk];
    }
}

@end
