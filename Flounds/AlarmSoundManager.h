//
//  AlarmSoundManager.h
//  Flounds
//
//  Created by Paul Rest on 11/18/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmSoundManager : NSObject

-(NSURL *)currAlarmURL;

-(NSArray *)namesOfAvailableAlarmSounds;

-(BOOL)selectAlarm:(NSUInteger)indexOfAlarm;

@end
