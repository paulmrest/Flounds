//
//  SettingBaseVC.h
//  Flounds
//
//  Created by Paul Rest on 10/31/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FloundsVCBase.h"

#import "SettingUnwindDelegate.h"
#import "AlarmClockModel.h"

@interface SettingBaseVC : FloundsVCBase

@property (nonatomic, weak) id<SettingUnwindDelegate> unwindToSettingsTVCDelegate;

@property (strong, nonatomic) AlarmClockModel *alarmClockModel;

@property (weak, nonatomic) IBOutlet FloundsButton *cancelButton;

@end
