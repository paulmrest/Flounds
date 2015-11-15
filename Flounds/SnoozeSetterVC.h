//
//  SnoozeSetterVC.h
//  Flounds
//
//  Created by Paul Rest on 11/5/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmClockModel.h"
#import "SetSnoozeProtocol.h"
#import "AlarmSetterVC.h"

#import "FloundsVCBase.h"


@interface SnoozeSetterVC : FloundsVCBase <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) AlarmClockModel *alarmClockModel;


@property (nonatomic, weak) IBOutlet UIPickerView *snoozePicker;


@property (weak, nonatomic) IBOutlet FloundsButton *setSnooze;

@property (weak, nonatomic) IBOutlet FloundsButton *cancel;


@property (nonatomic, weak) id<SetSnoozeProtocol> setSnoozeDelegate;


-(void)setInitSnoozeMinutes:(NSUInteger)snoozeMinutes;

@end
