//
//  SettingsVC.h
//  Flounds
//
//  Created by Paul Rest on 10/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "SettingUnwindDelegate.h"

#import "SnoozeDefaultPickerVC.h"
#import "DifficultySettingsVC.h"
#import "AlarmSoundDefaultChooserVC.h"

#import "AlarmClockModel.h"

#import "FloundsModel.h"

#import "FloundsVCBase.h"

@interface SettingsVC : FloundsVCBase <UITableViewDataSource>


@property (strong, nonatomic) AlarmClockModel *alarmClockModel;

@property (nonatomic, strong) FloundsModel *floundsModel;

@property (nonatomic, strong) AlarmSoundManager *soundManager;


@property (weak, nonatomic) IBOutlet UITableView *settingsTV;

@property (weak, nonatomic) IBOutlet FloundsButton *doneButton;

@end
