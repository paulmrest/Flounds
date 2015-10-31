//
//  SettingsVC.h
//  Flounds
//
//  Created by Paul Rest on 10/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SettingsTVUnwindDelegate.h"
#import "SettingUnwindDelegate.h"

//>>>
#import "SettingBaseVC.h"
//<<<
#import "SnoozeDefaultPickerVC.h"
#import "DifficultySettingsVC.h"
#import "AlarmSoundDefaultChooserVC.h"

#import "AlarmClockModel.h"

#import "FloundsModel.h"

#import "FloundsVCBase.h"

@interface SettingsVC : FloundsVCBase <UITableViewDataSource, SettingUnwindDelegate>

@property (weak, nonatomic) id<SettingsTVUnwindDelegate> unwindDelegate;

//@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (weak, nonatomic) IBOutlet FloundsButton *doneButton;

@property (weak, nonatomic) IBOutlet UITableView *settingsTV;

@property (strong, nonatomic) AlarmClockModel *alarmClockModel;

@property (nonatomic, strong) FloundsModel *floundsModel;

@property (nonatomic, strong) AlarmSoundManager *soundManager;

@end
