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

NSString *SNOOZE_DISPLAY_STRING;

NSString *SEGUE_TO_SNOOZE_SETTER_ID = @"SetOneSnooze";

#import "AlarmSetterVC.h"

@interface AlarmSetterVC ()

@property (nonatomic, strong) NSDate *alarmTimeDate;

@property (nonatomic, strong) NSDate *currTimeSelectorDate;

@property (nonatomic) NSUInteger initSnoozeMinutes;

@property (nonatomic) NSUInteger currSnoozeMinutes;

//@property (weak, nonatomic) IBOutlet UITextView *snoozeTextView;

@property (nonatomic) BOOL unsavedChanges;

@end


@implementation AlarmSetterVC

-(void)viewDidLoad
{
    [super viewDidLoad];    
    
    self.initSnoozeMinutes = self.alarmTimeDate ?
                             [self.alarmClockModel snoozeTimeMinutesForDate:self.alarmTimeDate] :
                             [self.alarmClockModel getDefaultSnoozeMinutes];
    
    self.unsavedChanges = NO;
    
    self.snoozeTextContainerView.displayFont = [FloundsViewConstants getDefaultFont];
    self.currSnoozeMinutes = self.initSnoozeMinutes; //upon instantiation initSnoozeMinutes == currSnoozeMinutes
    
    [self.snoozeTapRecognizer addTarget:self
                                 action:@selector(handleSnoozeTap)];
    
    self.timeSelector.datePickerMode = UIDatePickerModeTime;    
    if (self.alarmClockModel.showTimeIn24HourFormat)
    {
        NSLocale *timeSelectorLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"NL"];
        [self.timeSelector setLocale:timeSelectorLocale];
    }
    [self.timeSelector addTarget:self
                          action:@selector(timeSelectorStateChange:)
                forControlEvents:UIControlEventValueChanged];
    
    [self.alarmSetButton setTitleColor:[FloundsViewConstants getdefaultTextColor] forState:UIControlStateNormal];
    [self.deleteAlarmButton setTitleColor:[FloundsViewConstants getdefaultTextColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[FloundsViewConstants getdefaultTextColor] forState:UIControlStateNormal];
}



-(void)viewDidLayoutSubviews
{
    [self layoutFloundsAppearance];
}

-(void)layoutFloundsAppearance
{
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.timeSelector];
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.snoozeTextContainerView];
    
    self.alarmSetButton.containingVC = self;
    self.deleteAlarmButton.containingVC = self;
    self.cancelButton.containingVC = self;
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.alarmSetButton];
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.deleteAlarmButton];
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.cancelButton];
    
    self.unwindActivatingButton = nil;
}

-(void)setButtonsText
{
    ADD_ALARM_BUTTON_STRING = NSLocalizedString(@"Set", nil);
    MODIFY_ALARM_BUTTON_STRING = NSLocalizedString(@"Modify", nil);
    DELETE_ALARM_BUTTON_STRING = NSLocalizedString(@"Delete", nil);
    CANCEL_BUTTON_STRING = NSLocalizedString(@"Cancel", nil);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self setButtonsText];

    [self updateView];
    [self updateSnoozeDisplay];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.currTimeSelectorDate)
    {
        [self.timeSelector setDate:self.currTimeSelectorDate animated:YES];
    }
    else
    {
        NSDate *currDate = [NSDate date];
        [self.timeSelector setDate:(self.alarmTimeDate ? self.alarmTimeDate : currDate) animated:YES];
        self.currTimeSelectorDate = currDate;
    }
    
}

-(void)unwindToAlarmSetter
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)setCurrSnoozeMinutes:(NSUInteger)snoozeMinutes
{
    if (snoozeMinutes != _currSnoozeMinutes)
    {
        if (snoozeMinutes >= MIN_SNOOZE_MINUTES && snoozeMinutes <= MAX_SNOOZE_MINUTES)
        {
            _currSnoozeMinutes = snoozeMinutes;
            [self updateSnoozeDisplay];
            
            if (self.alarmTimeDate)
            {
                self.unsavedChanges = _currSnoozeMinutes != self.initSnoozeMinutes ? YES : NO;
            }
        }
    }    
}

-(void)setSnoozeMinutes:(NSUInteger)snoozeMinutes
{
}

-(void)updateSnoozeDisplay
{
    NSString *snoozeDisplayText = [NSString stringWithFormat:@"Current snooze is: %lu minute", (unsigned long)self.currSnoozeMinutes];
    if (self.currSnoozeMinutes > 1)
    {
        snoozeDisplayText = [snoozeDisplayText stringByAppendingString:@"s"];
    }
    
    self.snoozeTextContainerView.displayText = snoozeDisplayText;
    [self.snoozeTextContainerView setNeedsDisplay];
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
    [self.deleteAlarmButton setTitle:DELETE_ALARM_BUTTON_STRING forState:UIControlStateNormal];
    
    if (self.alarmTimeDate) //if VC was inited with an alarmTimeDate already set from the parent VC
    {
        [self enableButtonWithAlphaShift:self.deleteAlarmButton];
        [self.alarmSetButton setTitle:MODIFY_ALARM_BUTTON_STRING forState:UIControlStateNormal];
        
        //if the snooze time has been changed from its initial state we enable the Set/Modify button, otherwise we disable it
        if (self.currSnoozeMinutes != self.initSnoozeMinutes)
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
    //>>>
    NSLog(@"AlarmSetterVC - handleSnoozeTap...");
    //<<<
    [self performSegueWithIdentifier:SEGUE_TO_SNOOZE_SETTER_ID sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:SEGUE_TO_SNOOZE_SETTER_ID])
    {
        if ([segue.destinationViewController isKindOfClass:[SnoozeSetterVC class]])
        {
            SnoozeSetterVC *snoozeSetter = (SnoozeSetterVC *)segue.destinationViewController;
            snoozeSetter.alarmClockModel = self.alarmClockModel;
            [snoozeSetter setInitSnoozeMinutes:self.currSnoozeMinutes];
            
            snoozeSetter.setSnoozeDelegate = self;
        }
    }
}

//-(void)setAlarmTime:(NSDate *)alarmTimeDate
//{
//    if (alarmTimeDate)
//    {
//        _alarmTimeDate = alarmTimeDate;
//    }
//}

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

-(void)displayDuplicateTimeAlert
{
    UIAlertView *dupTimeAlert = [[UIAlertView alloc] initWithTitle:@"Duplicate Time"
                                                           message:@"You are attempting to add an alert time that is already present"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles: nil];
    [dupTimeAlert show];
}

-(BOOL)addAlarmTime
{
    self.alarmTimeDate = self.timeSelector.date;
    return [self.alarmClockModel addAlarmTime:self.alarmTimeDate
                                   withSnooze:self.currSnoozeMinutes];
    }

-(BOOL)modifyAlarmTime
{
    NSDate *oldAlarmTime = self.alarmTimeDate;
    NSDate *newAlarmTime = self.timeSelector.date;
    self.alarmTimeDate = newAlarmTime;
    return [self.alarmClockModel modifyAlarmTime:oldAlarmTime
                                newAlarmTimeDate:newAlarmTime
                       newAlarmTimeSnoozeMinutes:self.currSnoozeMinutes];
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
            //>>>
            NSLog(@"AlarmSetterVC - deleteAlarmTime...");
            NSLog(@"model unable to delete alarm time for some reason");
            //<<<
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
            UIAlertController *unsavedChangesAlert = [UIAlertController alertControllerWithTitle:@"Unsaved Changes"
                                                                                         message:@"Alarm time has has unsaved changes. Still cancel?"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action) {
                                                                 self.unsavedChanges = NO;
                                                                 [self cancel:sender];
                                                             }];
            UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No"
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
