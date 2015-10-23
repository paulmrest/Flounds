//
//  AlarmTimeCell.m
//  Flounds
//
//  Created by Paul Rest on 6/29/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "AlarmTimeCell.h"

@interface AlarmTimeCell ()


@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end


@implementation AlarmTimeCell


-(void)setAlarmTimeDate:(NSDate *)alarmTimeDate
{
    _alarmTimeDate = alarmTimeDate;
    if (alarmTimeDate)
    {
        self.cellText.text = [self.dateFormatter stringFromDate:alarmTimeDate];
    }
    else
    {
        self.cellText.text = @"Add alarm time...";
    }
}

-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.timeZone = [NSTimeZone localTimeZone];
        _dateFormatter.timeStyle = NSDateFormatterShortStyle;
        
        NSString *timeFormatString;
        if (self.alarmClockModel.showTimeIn24HourFormat)
        {
            timeFormatString = @"HH:mm";
        }
        else
        {
            timeFormatString = @"h:mm a";
        }
        [_dateFormatter setDateFormat:timeFormatString];
    }
    return _dateFormatter;
}

-(void)resetDateFormatter
{
    self.dateFormatter = nil;
    [self dateFormatter];
}

-(IBAction)flipActiveState:(UISwitch *)sender
{
    [self.alarmClockModel flipAlarmActiveState:self.alarmTimeDate];
    self.active = self.activeSwitch.isOn;
    [self updateCellDisplay];
}

-(void)switchAlarmActiveState
{
    self.active = !self.active;
//    [self.alarmTime isActive] ? [self.alarmTime makeInactive] : [self.alarmTime makeActive];
}

-(void)setupCellDisplay
{
    BOOL activeSwitchOn = (self.alarmTimeDate ? YES : NO);
    [self.activeSwitch setEnabled:activeSwitchOn];
    if (activeSwitchOn)
    {
        [self.activeSwitch setOn:self.active animated:NO];
        [self updateCellDisplay];
    }
}

-(void)updateCellDisplay
{
    if (self.active)
    {
        self.cellText.alpha = 1.0;
    }
    else
    {
        self.cellText.alpha = 0.5;
    }
    [self setNeedsDisplay];
}

@end
