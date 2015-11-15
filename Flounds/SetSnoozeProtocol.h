//
//  SetSnoozeProtocol.h
//  Flounds
//
//  Created by Paul Rest on 11/6/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SetSnoozeProtocol <NSObject>

@property (nonatomic) NSUInteger initialSnoozeMinutes;

@property (nonatomic) NSUInteger currSnoozeMinutes;


-(void)unwindToAlarmSetter;

-(void)setSnoozeMinutes:(NSUInteger)snoozeMinutes;

@end
