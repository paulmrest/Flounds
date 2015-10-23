//
//  SetSnoozeDelegate.h
//  Flounds
//
//  Created by Paul Rest on 11/6/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SetSnoozeDelegate <NSObject>

-(void)unwindToAlarmSetter;

-(void)setCurrSnoozeMinutes:(NSUInteger)snoozeMinutes;

@end
