//
//  AlarmClockVC.h
//  Flounds
//
//  Created by Paul Rest on 6/21/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClockViewText.h"

#import "AlarmTimeCell.h"
#import "DeactivateSnoozeProtocol.h"

#import "AlarmSetterVC.h"
#import "AlarmClockModel.h"

//#import "SettingsButtonContainer.h"

#import "PatternMakerVC.h"
#import "ModalPatternMakerDelegate.h"
#import "FloundsModel.h"

#import "FloundsVCBase.h"

#import "SettingsVC.h"
//#import "SettingsTVUnwindDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import "AlarmSoundManager.h"

#import "FloundsAppearanceUtility.h"

@interface AlarmClockVC : FloundsVCBase <UITableViewDataSource, UITableViewDelegate, ModalPatternMakerDelegate, DeactivateSnoozeProtocol>


@property (weak, nonatomic) IBOutlet ClockViewText *clockView;

@property (weak, nonatomic) IBOutlet FloundsButton *settingsEndSnoozeButton;

@property (nonatomic, weak) IBOutlet UITableView *alarmTimesTV;

@property (nonatomic, weak) IBOutlet PatternMakerVC *patternMakerVC;


-(void)deactivateSnoozeStateForAlarmTime:(NSDate *)alarmDate;

-(void)saveAlarmingAndFloundsState;

@end
