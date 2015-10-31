//
//  AlarmSetterVC.m
//  Flounds
//
//  Created by Paul Rest on 7/5/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

NSString *ADD_ALARM_BUTTON_STRING;
NSString *MODIFY_ALARM_BUTTON_STRING;
NSString *DELETE_ALARM_BUTTON_STRING;
NSString *CANCEL_BUTTON_STRING;

NSString *BASE_SNOOZE_DISPLAY_STRING;
NSString *MINUTE_SINGULAR_STRING;
NSString *MINUTE_PLURAL_STRING;

NSString *BASE_ALARM_SOUND_DISPLAY_STRING;

NSString *UNSAVED_CHANGES_ALERT_TITLE_STRING;
NSString *UNSAVED_CHANGES_ALERT_BODY_STRING;
NSString *UNSAVED_CHANGES_ALERT_YES_BUTTON_STRING;
NSString *UNSAVED_CHANGES_ALERT_NO_BUTTON_STRING;

NSString *SNOOZE_SETTER_SEGUE_ID = @"SetOneSnoozeSegue";
NSString *ALARM_SOUND_SETTER_SEGUE_ID = @"SetOneAlarmSoundSegue";

#import "AlarmSetterVC.h"

@interface AlarmSetterVC ()

@property (nonatomic, strong) NSDate *alarmTimeDate;

@property (nonatomic, strong) NSDate *currTimeSelectorDate;

//@property (weak, nonatomic) IBOutlet UITextView *snoozeTextView;

@property (nonatomic) BOOL unsavedChanges;

@end


@implementation AlarmSetterVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.unsavedChanges = NO;
    
    self.initialSnoozeMinutes = self.alarmTimeDate ?
                             [self.alarmClockModel snoozeTimeMinutesForDate:self.alarmTimeDate] :
                             [self.alarmClockModel getDefaultSnoozeMinutes];
    self.currSnoozeMinutes = self.initialSnoozeMinutes;
    
    self.snoozeTextContainerView.displayFont = [FloundsViewConstants getDefaultFont];
    
    self.initialAlarmSound = self.alarmTimeDate ?
                            [self.alarmClockModel getAlarmSoundForAlarmTime:self.alarmTimeDate] :
                            [self.soundManager getDefaultAlarmSoundName];

    self.currAlarmSound = self.initialAlarmSound;
    
    self.alarmSoundTextView.displayFont = [FloundsViewConstants getDefaultFont];
    
    [self.snoozeTapRecognizer addTarget:self
                                 action:@selector(handleSnoozeTap)];
    
    [self.alarmSoundTapRecognizer addTarget:self
                                     action:@selector(handleAlarmSoundTap)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(floundsTimeSelectorStateChange:)
                                                 name:FLOUNDS_DATE_PICKER_VALUE_CHANGED_NOTIFICATION
                                               object:self.floundsTimeSelector];
    
    [self setDisplayStrings];
    
    [self.alarmSetButton setTitleColor:[FloundsViewConstants getDefaultTextColor] forState:UIControlStateNormal];
    [self.deleteAlarmButton setTitleColor:[FloundsViewConstants getDefaultTextColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[FloundsViewConstants getDefaultTextColor] forState:UIControlStateNormal];
}



-(void)viewDidLayoutSubviews
{
    [self layoutFloundsAppearance];
}

-(void)layoutFloundsAppearance
{
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.floundsTimeSelector];
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.snoozeTextContainerView];
    self.snoozeTextContainerView.containingVC = self;
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.alarmSoundTextView];

    [self.deleteAlarmButton setTitle:DELETE_ALARM_BUTTON_STRING forState:UIControlStateNormal];
    
    self.alarmSetButton.containingVC = self;
    self.deleteAlarmButton.containingVC = self;
    self.cancelButton.containingVC = self;
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.alarmSetButton];
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.deleteAlarmButton];
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.cancelButton];
    
    self.unwindActivatingButton = nil;
}

-(void)setDisplayStrings
{
    ADD_ALARM_BUTTON_STRING = NSLocalizedString(@"Set", nil);
    MODIFY_ALARM_BUTTON_STRING = NSLocalizedString(@"Modify", nil);
    DELETE_ALARM_BUTTON_STRING = NSLocalizedString(@"Delete", nil);
    CANCEL_BUTTON_STRING = NSLocalizedString(@"Cancel", nil);
    
    BASE_SNOOZE_DISPLAY_STRING = NSLocalizedString(@"Current snooze: ", nil);
    MINUTE_SINGULAR_STRING = NSLocalizedString(@"Minute", nil);
    MINUTE_PLURAL_STRING = NSLocalizedString(@"Minutes", nil);
    
    BASE_ALARM_SOUND_DISPLAY_STRING = NSLocalizedString(@"Current sound: ", nil);
    
    UNSAVED_CHANGES_ALERT_TITLE_STRING = NSLocalizedString(@"Unsaved Changes", nil);
    UNSAVED_CHANGES_ALERT_BODY_STRING = NSLocalizedString(@"Still cancel?", nil);
    UNSAVED_CHANGES_ALERT_YES_BUTTON_STRING = NSLocalizedString(@"Yes", nil);
    UNSAVED_CHANGES_ALERT_NO_BUTTON_STRING = NSLocalizedString(@"No", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.floundsTimeSelector setShowTimeIn24HourFormat:self.alarmClockModel.showTimeIn24HourFormat];
    
    [self updateView];
    [self updateSnoozeDisplay];
    [self updateAlarmSoundDisplay];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.currTimeSelectorDate)
    {
        [self.floundsTimeSelector setDisplayedTime:self.currTimeSelectorDate animated:YES];
    }
    else
    {
        NSDate *dateToSet = self.alarmTimeDate ? self.alarmTimeDate : [NSDate date];
        [self.floundsTimeSelector setDisplayedTime:dateToSet animated:YES];
        self.currTimeSelectorDate = dateToSet;
    }
    
}

-(void)unwindToAlarmSetter
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma SetSnoozeDelegate
-(void)setSnoozeMinutes:(NSUInteger)snoozeMinutes
{
    if (snoozeMinutes != _currSnoozeMinutes)
    {
        if (snoozeMinutes >= MIN_SNOOZE_MINUTES && snoozeMinutes <= MAX_SNOOZE_MINUTES)
        {
            _currSnoozeMinutes = snoozeMinutes;
            [self updateSnoozeDisplay];
            
            if (self.alarmTimeDate)
            {
                self.unsavedChanges = _currSnoozeMinutes != self.initialSnoozeMinutes ? YES : NO;
            }
        }
    }
}

#pragma SetAlarmSoundProtocol
-(void)setAlarmSound:(NSString *)currAlarmSound
{
    if (![_currAlarmSound isEqualToString:currAlarmSound])
    {
        _currAlarmSound = currAlarmSound;
        [self updateAlarmSoundDisplay];
        
        if (self.alarmTimeDate)
        {
            self.unsavedChanges = ![_currAlarmSound isEqualToString:self.initialAlarmSound] ? YES : NO;
        }
    }
}

-(void)updateSnoozeDisplay
{
    NSString *snoozeDisplayText = nil;
    snoozeDisplayText = [BASE_ALARM_SOUND_DISPLAY_STRING stringByAppendingString:[NSString stringWithFormat:@"%lu ", self.currSnoozeMinutes]];
    if (self.currSnoozeMinutes == 1)
    {
        snoozeDisplayText = [snoozeDisplayText stringByAppendingString:MINUTE_SINGULAR_STRING];
    }
    else
    {
        snoozeDisplayText = [snoozeDisplayText stringByAppendingString:MINUTE_PLURAL_STRING];
    }
    
    self.snoozeTextContainerView.displayText = snoozeDisplayText;
    [self.snoozeTextContainerView setNeedsDisplay];
}


-(void)updateAlarmSoundDisplay
{
    NSString *alarmSoundDisplayText = [BASE_ALARM_SOUND_DISPLAY_STRING stringByAppendingString:self.currAlarmSound];
    
    self.alarmSoundTextView.displayText = alarmSoundDisplayText;
    [self.alarmSoundTextView setNeedsDisplay];
}

-(void)setAlarmTimeDate:(NSDate *)alarmTimeDate
{
    _alarmTimeDate = alarmTimeDate;
}

//updates the display of the Set/Modify and the Delete buttons based on the VC's initial state
//versus its current state
//Note: changes to the actual alarmTimeDate from the embedded UIPickerView are handled but another method: timeSelectorStateChange
-(void)updateView
{
    if (self.alarmTimeDate) //if VC was inited with an alarmTimeDate already set from the parent VC
    {
        [self enableButtonWithAlphaShift:self.deleteAlarmButton];
        [self.alarmSetButton setTitle:MODIFY_ALARM_BUTTON_STRING forState:UIControlStateNormal];
        
        //if the snooze time has been changed from its initial state we enable the Set/Modify button, otherwise we disable it
        if (self.currSnoozeMinutes != self.initialSnoozeMinutes ||
            ![self.currAlarmSound isEqualToString:self.initialAlarmSound])
        {
            [self enableButtonWithAlphaShift:self.alarmSetButton];
        }
        else
        {
            [self disableButtonWithAlphaShift:self.alarmSetButton];
        }
    }
    else
    {
        [self disableButtonWithAlphaShift:self.deleteAlarmButton];
    }
}

-(void)timeSelectorStateChange:(id)sender
{
    if ([sender isKindOfClass:[UIDatePicker class]])
    {
        self.currTimeSelectorDate = self.timeSelector.date;
        if (self.alarmTimeDate)
        {
            if (![self.alarmTimeDate isEqualToDate:self.currTimeSelectorDate])
            {
                [self enableButtonWithAlphaShift:self.alarmSetButton];
                self.unsavedChanges = YES;
            }
            else
            {
                [self disableButtonWithAlphaShift:self.alarmSetButton];
                self.unsavedChanges = NO;
            }
        }
    }
}

-(void)floundsTimeSelectorStateChange:(NSNotification *)notification
{
    self.currTimeSelectorDate = self.floundsTimeSelector.currSelectedTime;
    if (self.alarmTimeDate)
    {
        if (![self.alarmTimeDate isEqualToDate:self.currTimeSelectorDate])
        {
            [self enableButtonWithAlphaShift:self.alarmSetButton];
            self.unsavedChanges = YES;
        }
        else
        {
            [self disableButtonWithAlphaShift:self.alarmSetButton];
            self.unsavedChanges = NO;
        }
    }
}

-(void)enableButtonWithAlphaShift:(UIButton *)button
{
    button.enabled = YES;
    button.alpha = 1.0;
}

-(void)disableButtonWithAlphaShift:(UIButton *)button
{
    button.enabled = NO;
    button.alpha = 0.4;
}

-(void)handleSnoozeTap
{
    [self.snoozeTextContainerView animateForSegueWithID:SNOOZE_SETTER_SEGUE_ID fromSender:self];
}

-(void)handleAlarmSoundTap
{
    [self.alarmSoundTextView animateForSegueWithID:ALARM_SOUND_SETTER_SEGUE_ID fromSender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SNOOZE_SETTER_SEGUE_ID])
    {
        if ([segue.destinationViewController isKindOfClass:[SnoozeSetterVC class]])
        {
            SnoozeSetterVC *snoozeSetter = (SnoozeSetterVC *)segue.destinationViewController;
            snoozeSetter.alarmClockModel = self.alarmClockModel;
            [snoozeSetter setInitSnoozeMinutes:self.currSnoozeMinutes];
            
            snoozeSetter.presentingVC = self;
            snoozeSetter.setSnoozeDelegate = self;
        }
    }
    else if ([segue.identifier isEqualToString:ALARM_SOUND_SETTER_SEGUE_ID])
    {
        if ([segue.destinationViewController isKindOfClass:[AlarmSoundSetterVC class]])
        {
            AlarmSoundSetterVC *soundSetter = (AlarmSoundSetterVC *)segue.destinationViewController;
            [soundSetter setInitialAlarmSound:self.currAlarmSound];
            
            soundSetter.setAlarmSoundDelegate = self;
            soundSetter.soundManager = self.soundManager;
            soundSetter.presentingVC = self;
        }
    }
}

-(IBAction)addOrModifyAlarmTime:(id)sender
{
    BOOL alarmTimeAddSuccess = NO;
    alarmTimeAddSuccess = self.alarmTimeDate ? [self modifyAlarmTime] : [self addAlarmTime];
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsAddOrModifyButton = (FloundsButton *)sender;
        self.unwindActivatingButton = floundsAddOrModifyButton;
        if (alarmTimeAddSuccess)
        {
            [floundsAddOrModifyButton animateForPushDismissCurrView];
        }
        else
        {
            [floundsAddOrModifyButton animateForPushActionFailed];
        }
    }
}

-(BOOL)addAlarmTime
{
    self.alarmTimeDate = self.floundsTimeSelector.currSelectedTime;
    
    return [self.alarmClockModel addAlarmTime:self.alarmTimeDate
                                   withSnooze:self.currSnoozeMinutes
                               withAlarmSound:self.currAlarmSound];
    }

-(BOOL)modifyAlarmTime
{
    NSDate *oldAlarmTime = self.alarmTimeDate;
    
    NSDate *newAlarmTime = self.floundsTimeSelector.currSelectedTime;
    
    self.alarmTimeDate = newAlarmTime;
    return [self.alarmClockModel modifyAlarmTime:oldAlarmTime
                                newAlarmTimeDate:newAlarmTime
                       newAlarmTimeSnoozeMinutes:self.currSnoozeMinutes
                               newAlarmTimeSound:self.currAlarmSound];
}


-(IBAction)deleteAlarmTime:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsDeleteButton = (FloundsButton *)sender;
        self.unwindActivatingButton = floundsDeleteButton;
        if ([self.alarmClockModel removeAlarmTime:self.alarmTimeDate])
        {
            [floundsDeleteButton animateForPushDismissCurrView];
        }
        else
        {
            NSLog(@"AlarmSetterVC - deleteAlarmTime...");
            NSLog(@"delete alarm time from self.alarmClockModel failed");
        }
    }
}

-(IBAction)cancel:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsCancelButton = (FloundsButton *)sender;
        if (self.unsavedChanges)
        {
            UIAlertController *unsavedChangesAlert = [UIAlertController alertControllerWithTitle:UNSAVED_CHANGES_ALERT_TITLE_STRING
                                                                                         message:UNSAVED_CHANGES_ALERT_BODY_STRING
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:UNSAVED_CHANGES_ALERT_YES_BUTTON_STRING
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 self.unsavedChanges = NO;
                                                                 [self cancel:sender];
                                                             }];
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:UNSAVED_CHANGES_ALERT_NO_BUTTON_STRING
                                                              style:UIAlertActionStyleCancel
                                                            handler:NULL];
            [unsavedChangesAlert addAction:noAction];
            [unsavedChangesAlert addAction:yesAction];
            
            [self presentViewController:unsavedChangesAlert
                               animated:YES
                             completion:NULL];
        }
        else
        {
            self.unwindActivatingButton = floundsCancelButton;
            [floundsCancelButton animateForPushDismissCurrView];
        }
    }
}

@end
