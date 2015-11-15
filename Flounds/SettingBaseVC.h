//
//  SettingBaseVC.h
//  Flounds
//
//  Created by Paul Rest on 10/31/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloundsVCBase.h"

#import "AlarmClockModel.h"

NSString *CANCEL_BUTTON_TITLE;

@interface SettingBaseVC : FloundsVCBase


@property (strong, nonatomic) AlarmClockModel *alarmClockModel;

@property (weak, nonatomic) IBOutlet FloundsButton *cancelButton;


@end
