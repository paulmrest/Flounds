//
//  SettingsVC.m
//  Flounds
//
//  Created by Paul Rest on 10/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "SettingsVC.h"

NSString *SETTINGS_TV_TAG_DIFFICULTY_VALUE;
NSString *SETTINGS_TV_TAG_SNOOZE_VALUE;
NSString *SETTINGS_TV_TAG_ALARM_SOUNDS_VALUE;
NSString *SETTINGS_TV_TAG_24HOUR_TOGGLE_VALUE;

static NSString *SEGUE_ID_SNOOZE = @"SetDefaultSnooze";
static NSString *SEGUE_ID_DIFFICULTY = @"SetDifficulty";
static NSString *SEGUE_ID_ALARM_SOUNDS = @"SetDefaultAlarmSound";

@interface SettingsVC ()

@property (strong, nonatomic) NSDictionary *tableViewSettingsTags;

@end


@implementation SettingsVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.doneButton.titleLabel.font = self.fullWidthFloundsButtonFont;
    
    SETTINGS_TV_TAG_DIFFICULTY_VALUE = NSLocalizedString(@"Difficulty", nil);
    SETTINGS_TV_TAG_SNOOZE_VALUE = NSLocalizedString(@"Default Snooze", nil);
    SETTINGS_TV_TAG_ALARM_SOUNDS_VALUE = NSLocalizedString(@"Default Alarm Sound", nil);
    SETTINGS_TV_TAG_24HOUR_TOGGLE_VALUE = NSLocalizedString(@"Display time in:", nil);

    self.doneButton.containingVC = self;
}

-(NSDictionary *)tableViewSettingsTags
{
    if (!_tableViewSettingsTags)
    {
        _tableViewSettingsTags = @{@0 : SETTINGS_TV_TAG_DIFFICULTY_VALUE,
                                   @1 : SETTINGS_TV_TAG_SNOOZE_VALUE,
                                   @2 : SETTINGS_TV_TAG_ALARM_SOUNDS_VALUE,
                                   @3 : SETTINGS_TV_TAG_24HOUR_TOGGLE_VALUE};
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
    [super removeAnimationsFromPresentingVC];
    for (UITableViewCell *oneTVCell in self.settingsTV.visibleCells)
    {
        [oneTVCell.layer removeAllAnimations];
    }
}

#pragma UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat displayFontPointSize = self.nonFullWidthFloundsButtonAndTVCellFont.pointSize;
    
    CGFloat cellHeightReturnValue = displayFontPointSize + (displayFontPointSize * [FloundsViewConstants getTableViewCellHeightSizingFactor]);
    
    return cellHeightReturnValue;
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
    
    TVCell.backgroundColor = self.defaultBackgroundColor;
    
    if ([TVCell isKindOfClass:[FloundsTVCell class]])
    {
        FloundsTVCell *floundsTVCell = (FloundsTVCell *)TVCell;
        floundsTVCell.active = YES;
        floundsTVCell.cellText.textColor = self.defaultUIColor;
        floundsTVCell.cellText.font = self.nonFullWidthFloundsButtonAndTVCellFont;
        
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
        else
        {
            if ([[self.tableViewSettingsTags objectForKey:indexPathRow] isEqualToString:SETTINGS_TV_TAG_SNOOZE_VALUE])
            {
                [floundsTVCell animateCellForSelectionToPerformSegue:SEGUE_ID_SNOOZE];
            }
            else if ([[self.tableViewSettingsTags objectForKey:indexPathRow] isEqualToString:SETTINGS_TV_TAG_DIFFICULTY_VALUE])
            {
                [floundsTVCell animateCellForSelectionToPerformSegue:SEGUE_ID_DIFFICULTY];
            }
            else if ([[self.tableViewSettingsTags objectForKey:indexPathRow] isEqualToString:SETTINGS_TV_TAG_ALARM_SOUNDS_VALUE])
            {
                [floundsTVCell animateCellForSelectionToPerformSegue:SEGUE_ID_ALARM_SOUNDS];
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
            snoozePicker.alarmClockModel = self.alarmClockModel;
            snoozePicker.presentingVC = self;
        }
    }
    else if ([segue.identifier isEqualToString:SEGUE_ID_DIFFICULTY])
    {
        if ([segue.destinationViewController isKindOfClass:[DifficultySettingsVC class]])
        {
            DifficultySettingsVC *difficultySettingsVC = (DifficultySettingsVC *)segue.destinationViewController;
            difficultySettingsVC.alarmClockModel = self.alarmClockModel;
            difficultySettingsVC.floundsModel = self.floundsModel;
            difficultySettingsVC.presentingVC = self;
        }
    }
    if ([segue.identifier isEqualToString:SEGUE_ID_ALARM_SOUNDS])
    {
        if ([segue.destinationViewController isKindOfClass:[AlarmSoundDefaultChooserVC class]])
        {
            AlarmSoundDefaultChooserVC *alarmSoundDefaultChooserVC = (AlarmSoundDefaultChooserVC *)segue.destinationViewController;
            alarmSoundDefaultChooserVC.soundManager = self.soundManager;
            alarmSoundDefaultChooserVC.presentingVC = self;
        }
    }
}

@end
