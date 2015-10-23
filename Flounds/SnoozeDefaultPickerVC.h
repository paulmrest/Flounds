//
//  SnoozeDefaultPickerVC.h
//  Flounds
//
//  Created by Paul Rest on 10/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingBaseVC.h"

@interface SnoozeDefaultPickerVC : SettingBaseVC <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *snoozePicker;

@property (weak, nonatomic) IBOutlet FloundsButton *setSnooze;

@end
