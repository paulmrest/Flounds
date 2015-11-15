//
//  AlarmSetterVC.h
//  Flounds
//
//  Created by Paul Rest on 7/5/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlarmClockModel.h"
#import "AlarmSoundManager.h"
#import "SetSnoozeProtocol.h"

#import "SnoozeSetterVC.h"
#import "AlarmSoundSetterVC.h"
#import "SetAlarmSoundProtocol.h"

#import "FloundsDatePickerView.h"

#import "VerticallyCenteredTextView.h"

#import "FloundsVCBase.h"


@interface AlarmSetterVC : FloundsVCBase <UIGestureRecognizerDelegate, UIPickerViewDelegate, SetSnoozeProtocol, SetAlarmSoundProtocol>

@property (strong, nonatomic) AlarmClockModel *alarmClockModel;

@property (nonatomic, strong) AlarmSoundManager *soundManager;


@property (nonatomic, weak) IBOutlet FloundsDatePickerView *floundsTimeSelector;


@property (weak, nonatomic) IBOutlet VerticallyCenteredTextView *snoozeMinutesTextView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *snoozeTapRecognizer;

@property (weak, nonatomic) IBOutlet VerticallyCenteredTextView *alarmSoundTextView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *alarmSoundTapRecognizer;


@property (weak, nonatomic) IBOutlet FloundsButton *alarmSetButton;

@property (weak, nonatomic) IBOutlet FloundsButton *deleteAlarmButton;

@property (weak, nonatomic) IBOutlet FloundsButton *cancelButton;


#pragma SetSnoozeProtocol
@property (nonatomic) NSUInteger initialSnoozeMinutes;

@property (nonatomic) NSUInteger currSnoozeMinutes;

#pragma SetAlarmSoundProtocol
@property (nonatomic, strong) NSString *initialAlarmSound;

@property (nonatomic, strong) NSString *currAlarmSound;



-(void)setAlarmTimeDate:(NSDate *)alarmTimeDate;

//-(void)setSnoozeMinutes:(NSUInteger)snoozeMinutes;

@end
