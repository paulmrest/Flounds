//
//  AlarmTimeCell.h
//  Flounds
//
//  Created by Paul Rest on 6/29/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AlarmClockModel.h"

#import "FloundsTVCell.h"

#import "DeactivateSnoozeProtocol.h"

@interface AlarmTimeCell : FloundsTVCell

@property (nonatomic, strong) AlarmClockModel *alarmClockModel;

@property (nonatomic, strong) id<DeactivateSnoozeProtocol> deactivateSnoozeDelegate;

@property (nonatomic, strong) NSDate *alarmTimeDate;

@property (weak, nonatomic) IBOutlet UISwitch *activeSwitch;

-(void)resetDateFormatter;

-(void)setupCellDisplay;

@end
