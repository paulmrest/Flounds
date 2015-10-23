//
//  SnoozeSetterVC.m
//  Flounds
//
//  Created by Paul Rest on 11/5/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "SnoozeSetterVC.h"

@interface SnoozeSetterVC ()

@property (nonatomic) NSUInteger initSnoozeMinutes;

@property (nonatomic) NSUInteger currSnoozeMinutes;

@end

@implementation SnoozeSetterVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.currSnoozeMinutes = self.initSnoozeMinutes;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateView];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.snoozePicker selectRow:self.initSnoozeMinutes - 1
                     inComponent:SINGLE_PICKERVIEW_COMPONENT
                        animated:YES];
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.snoozePicker];
    
    self.setSnooze.containingVC = self;
    self.cancel.containingVC = self;

    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.setSnooze];
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.cancel];
}

-(void)setInitSnoozeMinutes:(NSUInteger)snoozeMinutes
{
    if (snoozeMinutes >= MIN_SNOOZE_MINUTES && snoozeMinutes <= MAX_SNOOZE_MINUTES)
    {
        _initSnoozeMinutes = snoozeMinutes;
    }
}

-(IBAction)setSnooze:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsSetSnoozeButton = (FloundsButton *)sender;
        self.unwindActivatingButton = floundsSetSnoozeButton;
        [self.setSnoozeDelegate setCurrSnoozeMinutes:self.currSnoozeMinutes];
        [floundsSetSnoozeButton animateForPushDismissCurrView];
    }
}

-(IBAction)cancelAndReturn:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsCancelButton = (FloundsButton *)sender;
        self.unwindActivatingButton = floundsCancelButton;
        [floundsCancelButton animateForPushDismissCurrView];
    }
}

-(void)updateView
{
    if (self.currSnoozeMinutes != self.initSnoozeMinutes)
    {
        [self enableButtonWithAlphaShift:self.setSnooze];
    }
    else
    {
        [self disableButtonWithAlphaShift:self.setSnooze];
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
    [self updateView];
}

@end
