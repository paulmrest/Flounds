//
//  AlarmSoundSetterVC.h
//  Flounds
//
//  Created by Paul M Rest on 10/26/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlarmClockModel.h"

#import "SetAlarmSoundProtocol.h"

#import "FloundsAlarmSoundChooserVCBase.h"

@interface AlarmSoundSetterVC : FloundsAlarmSoundChooserVCBase

@property (nonatomic, strong) id<SetAlarmSoundProtocol> setAlarmSoundDelegate;

-(void)setInitialAlarmSound:(NSString *)alarmSound;

@end
