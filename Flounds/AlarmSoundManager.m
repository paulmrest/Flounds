//
//  AlarmSoundManager.m
//  Flounds
//
//  Created by Paul Rest on 11/18/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "AlarmSoundManager.h"

@interface AlarmSoundManager ()

@property (nonatomic, strong) NSDictionary *availableSounds;

@property (nonatomic, strong) NSFileManager *fileManager;

@end


@implementation AlarmSoundManager

-(id)initWithAvailableSounds
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(NSFileManager *)fileManager
{
    if (!_fileManager)
    {
        _fileManager = [[NSFileManager alloc] init];
    }
    return _fileManager;
}

-(void)loadAvailableSounds
{
    NSMutableDictionary *tempBuildingDictionary = [[NSMutableDictionary alloc] init];
    
}

-(NSURL *)currAlarmURL
{
    NSString *alarmSoundPath = [[NSBundle mainBundle] pathForResource:@"198841__bone666138__analog-alarm-clock"
                                                               ofType:@"wav"];
    NSURL *alarmSoundURL = [NSURL fileURLWithPath:alarmSoundPath];
    return alarmSoundURL;
}

-(NSArray *)namesOfAvailableAlarmSounds
{
    return nil;
}

-(BOOL)selectAlarm:(NSUInteger)indexOfAlarm
{
    return YES;
}

@end
