//
//  FloundsDatePickerView.h
//  Flounds
//
//  Created by Paul M Rest on 10/17/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloundsViewConstants.h"

#import "AlarmClockModel.h"


extern NSString *FLOUNDS_DATE_PICKER_VALUE_CHANGED_NOTIFICATION;


@interface FloundsDatePickerView : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSDate *currSelectedTime;

@property (nonatomic) BOOL showTimeIn24HourFormat;

@property (nonatomic, strong) UIFont *displayFont;

@property (nonatomic, strong) UIColor *fontColor;

@property (nonatomic, strong) UIColor *backgroundColor;

-(void)setShowTimeIn24HourFormat:(BOOL)showTimeIn24HourFormat
           withPickerViewRefresh:(BOOL)refreshPickerView;

-(void)setDisplayedTime:(NSDate *)displayTimeDate
               animated:(BOOL)animated;

@end
