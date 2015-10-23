//
//  FloundsDatePickerView.h
//  Flounds
//
//  Created by Paul M Rest on 10/17/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlarmClockModel.h"

@interface FloundsDatePickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) AlarmClockModel *alarmClockModel;

@property (nonatomic, strong) NSDate *currSelectedTime;

@property (nonatomic) BOOL showTimeIn24HourFormat;

@property (nonatomic, strong) UIFont *displayFont;

@property (nonatomic, strong) UIColor *fontColor;

@property (nonatomic, strong) UIColor *backgroundColor;

@end
