//
//  FloundsAlarmSoundChooserVCBase.h
//  Flounds
//
//  Created by Paul M Rest on 10/26/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsVCBase.h"

#import "AlarmSoundManager.h"

#import "AlarmSoundInfoVC.h"
#import "AlarmSoundTVCell.h"


NSString *ALARM_SOUND_INFO_SEGUE_ID;


@interface FloundsAlarmSoundChooserVCBase : FloundsVCBase <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *alarmSoundsTV;

@property (nonatomic, strong) NSArray *alarmSoundNames;


@property (weak, nonatomic) IBOutlet FloundsButton *doneButton;

@property (nonatomic, strong) AlarmSoundManager *soundManager;

@end
