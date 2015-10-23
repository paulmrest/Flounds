//
//  AlarmSetterVC.h
//  Flounds
//
//  Created by Paul Rest on 7/5/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlarmClockModel.h"
#import "SetSnoozeDelegate.h"
#import "SnoozeSetterVC.h"

#import "VerticallyAlignedTextView.h"
#import "VerticallyCenteredTextView.h"

#import "FloundsVCBase.h"


@interface AlarmSetterVC : FloundsVCBase <UIGestureRecognizerDelegate, UIPickerViewDelegate, SetSnoozeDelegate>

@property (strong, nonatomic) AlarmClockModel *alarmClockModel;

@property (nonatomic, weak) IBOutlet UIDatePicker *timeSelector;


@property (weak, nonatomic) IBOutlet VerticallyAlignedTextView *snoozeTextView;

@property (weak, nonatomic) IBOutlet VerticallyCenteredTextView *snoozeTextContainerView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *snoozeTapRecognizer;


@property (weak, nonatomic) IBOutlet FloundsButton *alarmSetButton;

@property (weak, nonatomic) IBOutlet FloundsButton *deleteAlarmButton;

@property (weak, nonatomic) IBOutlet FloundsButton *cancelButton;


-(void)setAlarmTimeDate:(NSDate *)alarmTimeDate;

-(void)setCurrSnoozeMinutes:(NSUInteger)snoozeMinutes;

@end
