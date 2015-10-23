//
//  SnoozePickerVC.m
//  Flounds
//
//  Created by Paul Rest on 10/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "SnoozeDefaultPickerVC.h"

@interface SnoozeDefaultPickerVC ()

@property (nonatomic) NSUInteger currSnoozeMinutes;

@end


@implementation SnoozeDefaultPickerVC

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.setSnooze.containingVC = self;
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.setSnooze];
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.snoozePicker];
    
    [self.snoozePicker selectRow:([self.alarmClockModel getDefaultSnoozeMinutes] - 1)
                     inComponent:SINGLE_PICKERVIEW_COMPONENT
                        animated:YES];
    self.currSnoozeMinutes = [self.snoozePicker selectedRowInComponent:SINGLE_PICKERVIEW_COMPONENT] + 1;
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
    NSString *minuteString = row == 0 ? @"Minute" : @"Minutes";
    NSString *finalString = [NSString stringWithFormat:@"%lu %@", (long)row + 1, minuteString];
    NSMutableAttributedString *attrbStringTitleRow = [[NSMutableAttributedString alloc] initWithString:finalString];
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    [attrbStringTitleRow addAttribute:NSParagraphStyleAttributeName
                                value:paragrapStyle
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
