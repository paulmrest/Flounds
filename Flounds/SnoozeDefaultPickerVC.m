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
    
    self.setSnooze.titleLabel.font = self.nonFullWidthFloundsButtonAndTVCellFont;
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
    }
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

#pragma UIPickerViewDelegate
-(UIView *)pickerView:(UIPickerView *)pickerView
           viewForRow:(NSInteger)row
         forComponent:(NSInteger)component
          reusingView:(UIView *)view
{
    NSString *minuteString = row == 0 ? SNOOZE_PICKER_MINUTE_SINGULAR : SNOOZE_PICKER_MINUTES_PLURAL;
    NSString *finalString = [NSString stringWithFormat:@"%lu %@", (long)row + 1, minuteString];
    
    NSMutableAttributedString *returnLabelAttString = [[NSMutableAttributedString alloc] initWithString:finalString];
    NSMutableDictionary *attStringAttributes = [[NSMutableDictionary alloc] init];
    
    NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
    paragrapStyle.alignment = NSTextAlignmentCenter;
    
    [attStringAttributes setObject:paragrapStyle forKey:NSParagraphStyleAttributeName];
    
    [attStringAttributes setObject:self.nonFullWidthFloundsButtonAndTVCellFont forKey:NSFontAttributeName];
    
    [attStringAttributes setObject:self.defaultUIColor forKey:NSForegroundColorAttributeName];
    
    [returnLabelAttString addAttributes:attStringAttributes
                                  range:NSMakeRange(0, [finalString length])];
    
    UILabel *returnLabel = [[UILabel alloc] initWithFrame:view.frame];
    
    returnLabel.attributedText = returnLabelAttString;
    returnLabel.textAlignment = NSTextAlignmentCenter;
    
    return returnLabel;
}

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    self.currSnoozeMinutes = row + 1;
}

@end
