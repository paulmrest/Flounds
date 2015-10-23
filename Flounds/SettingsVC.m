//
//  SettingsVC.m
//  Flounds
//
//  Created by Paul Rest on 10/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "SettingsVC.h"

NSString *SETTINGS_TV_TAG_SNOOZE_VALUE = @"Snooze";
NSString *SETTINGS_TV_TAG_DIFFICULTY_VALUE = @"Difficulty";
NSString *SETTINGS_TV_TAG_24HOUR_TOGGLE_VALUE = @"Display time in:";

//>>>
NSString *DEBUGGING_SETTINGS_TV_TAG_SNOOZE_SECONDS_TOGGLE = @"Snooze in: ";
//<<<

NSString *SEGUE_ID_SNOOZE = @"SetDefaultSnooze";
NSString *SEGUE_ID_DIFFICULTY = @"SetDifficulty";

@interface SettingsVC ()

@property (strong, nonatomic) NSDictionary *tableViewSettingsTags;

@end

@implementation SettingsVC

-(void)viewDidLayoutSubviews
{
    [FloundsAppearanceUtility addFloundsSublayerToView:self.doneButton withBorderThickness:2.0f];
    self.doneButton.containingVC = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.presentingVC removeAnimationsFromPresentingVC];
}

-(NSDictionary *)tableViewSettingsTags
{
    if (!_tableViewSettingsTags)
    {
        _tableViewSettingsTags = @{@0 : SETTINGS_TV_TAG_SNOOZE_VALUE,
                                   @1 : SETTINGS_TV_TAG_DIFFICULTY_VALUE,
                                   @2 : SETTINGS_TV_TAG_24HOUR_TOGGLE_VALUE,
                                   //>>>
                                   @3 : DEBUGGING_SETTINGS_TV_TAG_SNOOZE_SECONDS_TOGGLE
                                   //<<<
                                   };
    }
    return _tableViewSettingsTags;
}

-(IBAction)doneButtonPressed:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *doneFloundsButton = (FloundsButton *)sender;
        
        self.unwindActivatingButton = doneFloundsButton;
        [doneFloundsButton animateForPushDismissCurrView];
    }
}

-(void)removeAnimationsFromPresentingVC
{
    for (UITableViewCell *oneTVCell in self.settingsTV.visibleCells)
    {
        [oneTVCell.layer removeAllAnimations];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [self.tableViewSettingsTags count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TVCell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:TVCell];
    TVCell.backgroundColor = self.defaultBackgroundColor;
    
    if ([TVCell isKindOfClass:[FloundsTVCell class]])
    {
        FloundsTVCell *floundsTVCell = (FloundsTVCell *)TVCell;
        floundsTVCell.cellText.textColor = self.defaultUIColor;
        NSNumber *indexPathRow = [NSNumber numberWithInt:(int)indexPath.row];
        NSString *cellText = [self.tableViewSettingsTags objectForKey:indexPathRow];
        if ([cellText isEqualToString:SETTINGS_TV_TAG_24HOUR_TOGGLE_VALUE])
        {
            floundsTVCell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.alarmClockModel.showTimeIn24HourFormat)
            {
                cellText = [cellText stringByAppendingString:@" 24h format"];
            }
            else
            {
                cellText = [cellText stringByAppendingString:@" 12h format"];
            }
        }
        
        //>>>
        if ([cellText isEqualToString:DEBUGGING_SETTINGS_TV_TAG_SNOOZE_SECONDS_TOGGLE])
        {
            if (self.alarmClockModel.debuggingSnoozeInSeconds)
            {
                cellText = [cellText stringByAppendingString:@"seconds"];
            }
            else
            {
                cellText = [cellText stringByAppendingString:@"minutes"];
            }
        }
        //<<<
        
        floundsTVCell.cellText.text = cellText;
    }
    return TVCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TVCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([TVCell isKindOfClass:[FloundsTVCell class]])
    {
        FloundsTVCell *floundsTVCell = (FloundsTVCell *)TVCell;
        floundsTVCell.containingVC = self;
        NSNumber *indexPathRow = [NSNumber numberWithInt:(int)indexPath.row];
        
        if ([[self.tableViewSettingsTags objectForKey:indexPathRow] isEqualToString:SETTINGS_TV_TAG_24HOUR_TOGGLE_VALUE])
        {
            [self.alarmClockModel setShowTimeIn24HourFormat:!self.alarmClockModel.showTimeIn24HourFormat];
            [self.settingsTV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
        
        //>>>
        else if ([[self.tableViewSettingsTags objectForKey:indexPathRow] isEqualToString:DEBUGGING_SETTINGS_TV_TAG_SNOOZE_SECONDS_TOGGLE])
        {
            self.alarmClockModel.debuggingSnoozeInSeconds = !self.alarmClockModel.debuggingSnoozeInSeconds;
            [self.settingsTV reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
        //<<<

        else
        {
            if ([[self.tableViewSettingsTags objectForKey:indexPathRow] isEqualToString:SETTINGS_TV_TAG_SNOOZE_VALUE])
            {
                [floundsTVCell animateCellForSelectionToPerformSegue:SEGUE_ID_SNOOZE];
            }
            if ([[self.tableViewSettingsTags objectForKey:indexPathRow] isEqualToString:SETTINGS_TV_TAG_DIFFICULTY_VALUE])
            {
                [floundsTVCell animateCellForSelectionToPerformSegue:SEGUE_ID_DIFFICULTY];
            }
            [self animateNonSelectedTableViewCells:tableView];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_ID_SNOOZE])
    {
        if ([segue.destinationViewController isKindOfClass:[SnoozeDefaultPickerVC class]])
        {
            SnoozeDefaultPickerVC *snoozePicker = (SnoozeDefaultPickerVC *)segue.destinationViewController;
            snoozePicker.unwindToSettingsTVCDelegate = self;
            snoozePicker.alarmClockModel = self.alarmClockModel;
            snoozePicker.presentingVC = self;
        }
    }
    else if ([segue.identifier isEqualToString:SEGUE_ID_DIFFICULTY])
    {
        if ([segue.destinationViewController isKindOfClass:[DifficultySettingsVC class]])
        {
            DifficultySettingsVC *difficultySettingsVC = (DifficultySettingsVC *)segue.destinationViewController;
            difficultySettingsVC.unwindToSettingsTVCDelegate = self;
            difficultySettingsVC.alarmClockModel = self.alarmClockModel;
            difficultySettingsVC.floundsModel = self.floundsModel;
            difficultySettingsVC.presentingVC = self;
        }
    }
    //>>>
    else if ([segue.destinationViewController isKindOfClass:[SettingBaseVC class]])
    {
        SettingBaseVC *settingBaseVC = (SettingBaseVC *)segue.destinationViewController;
        settingBaseVC.unwindToSettingsTVCDelegate = self;
        settingBaseVC.alarmClockModel = self.alarmClockModel;
        settingBaseVC.presentingVC = self;
    }
    //<<<
}

#pragma SettingUnwindDelegate
-(void)unwindToSettingsTV
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end