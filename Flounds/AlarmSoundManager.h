//
//  AlarmSoundManager.h
//  Flounds
//
//  Created by Paul Rest on 11/18/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AlarmSound.h"

@interface AlarmSoundManager : NSObject

-(id)initWithAvailableSounds;

-(NSString *)getDefaultAlarmSoundName;

-(BOOL)setDefaultAlarmFromDisplayName:(NSString *)alarmDisplayName;

-(NSURL *)getCurrentlySelectedAlarmURL;

-(NSURL *)getAlarmURLForDisplayName:(NSString *)alarmDisplayName;

-(NSArray *)getAlarmSoundNames;

-(BOOL)selectAlarm:(NSUInteger)indexOfAlarm;

@end
