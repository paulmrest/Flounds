//
//  DeactivateSnoozeProtocol.h
//  Flounds
//
//  Created by Paul M Rest on 10/26/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

@protocol DeactivateSnoozeProtocol <NSObject>

-(void)deactivateSnoozeStateForAlarmTime:(NSDate *)alarmDate;

@end
