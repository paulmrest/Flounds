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

@interface AlarmTimeCell : FloundsTVCell

@property (nonatomic, strong) AlarmClockModel *alarmClockModel;

@property (nonatomic, strong) NSDate *alarmTimeDate;

@property (nonatomic) BOOL active;

@property (weak, nonatomic) IBOutlet UISwitch *activeSwitch;

-(void)resetDateFormatter;

-(void)setupCellDisplay;

@end