//
//  SnoozePickerVC.m
//  Flounds
//
//  Created by Paul Rest on 10/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "SnoozeDefaultPickerVC.h"

NSString *SNOOZE_PICKER_MINUTE_SINGULAR;

NSString *SNOOZE_PICKER_MINUTES_PLURAL;

NSString *SET_SNOOZE_BUTTON_TITLE;

NSString *CANCEL_BUTTON_TITLE;

@interface SnoozeDefaultPickerVC ()

@property (nonatomic) NSUInteger currSnoozeMinutes;

@end


@implementation SnoozeDefaultPickerVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    SNOOZE_PICKER_MINUTE_SINGULAR = NSLocalizedString(@"Minute", nil);
    SNOOZE_PICKER_MINUTES_PLURAL = NSLocalizedString(@"Minutes", nil);
    
    SET_SNOOZE_BUTTON_TITLE = NSLocalizedString(@"Set Default Snooze", nil);
    CANCEL_BUTTON_TITLE = NSLocalizedString(@"Cancel", nil);
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.snoozePicker];
    [self.snoozePicker selectRow:([self.alarmClockModel getDefaultSnoozeMinutes] - 1)
                     inComponent:SINGLE_PICKERVIEW_COMPONENT
                        animated:YES];
    self.currSnoozeMinutes = [self.snoozePicker selectedRowInComponent:SINGLE_PICKERVIEW_COMPONENT] + 1;
    
    [self.setSnooze setTitle:SET_SNOOZE_BUTTON_TITLE forState:UIControlStateNormal];
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.setSnooze];
    self.setSnooze.containingVC = self;
    
    [self.cancelButton setTitle:CANCEL_BUTTON_TITLE forState:UIControlStateNormal];
}

-(IBAction)setSnooze:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsSetSnoozeButton = (FloundsButton *)sender;
        if ([self.alarmClockModel setSnooze:self.currSnoozeMinutes])
        {
            self.unwindActivatingButton = floundsSetSnoozeButton;
            [floundsSetSnoozeButton animateForPushDismissCurrView];
        }
        else
        {
            //>>>
            NSLog(@"SnoozePickerVC - setSnooze... model's set snooze returned NO");
            //<<<
        }
    }
}

-(IBAction)cancelAndReturn:(UIButton *)sender
{
    [self.unwindToSettingsTVCDelegate unwindToSettingsTV];
}

#pragma UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return PICKERVIEW_COMPONENTS;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return MAX_SNOOZE_MINUTES - MIN_SNOOZE_MINUTES;
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView
            attributedTitleForRow:(NSInteger)row
                     forComponent:(NSInteger)component
{
    NSString *minuteString = row == 0 ? SNOOZE_PICKER_MINUTE_SINGULAR : SNOOZE_PICKER_MINUTES_PLURAL;
    NSString *finalString = [NSString stringWithFormat:@"%lu %@", (long)row + 1, minuteString];
    
    NSMutableAttributedString *attrbStringTitleRow = [[NSMutableAttributedString alloc] initWithString:finalString];
    NSMutableDictionary *attStringAttributes = [[NSMutableDictionary alloc] init];
    
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    
    [attStringAttributes setObject:paragrapStyle forKey:NSParagraphStyleAttributeName];
    
    [attStringAttributes setObject:[FloundsViewConstants getDefaultFont] forKey:NSFontAttributeName];
    
    [attStringAttributes setObject:[FloundsViewConstants getDefaultTextColor] forKey:NSForegroundColorAttributeName];
    
    [attrbStringTitleRow addAttributes:attStringAttributes
                                 range:NSMakeRange(0, [finalString length])];
    return attrbStringTitleRow;
}

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.currSnoozeMinutes = row + 1;
}

@end
