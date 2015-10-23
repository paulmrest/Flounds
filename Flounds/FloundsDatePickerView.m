//
//  FloundsDatePickerView.m
//  Flounds
//
//  Created by Paul M Rest on 10/17/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsDatePickerView.h"


const NSInteger SHOW_TIME_24_NUMBER_OF_HOURS = 24;

const NSInteger SHOW_TIME_12_NUMBER_OF_HOURS = 12;

const NSInteger NUMBER_OF_MINUTES = 60;

const NSInteger NUMBER_OF_PERIODS = 2;


@interface FloundsDatePickerView ()


@property (nonatomic) NSUInteger numOfComponents;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation FloundsDatePickerView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(void)setShowTimeIn24HourFormat:(BOOL)showTimeIn24HourFormat
{
    _showTimeIn24HourFormat = showTimeIn24HourFormat;
    if (showTimeIn24HourFormat)
    {
        self.numOfComponents = 2;
    }
    else
    {
        self.numOfComponents = 3;
    }
}

-(void)setCurrSelectedTime:(NSDate *)currSelectedTime
{
    
}

#pragma UIPickerViewDataSource
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (self.alarmClockModel.showTimeIn24HourFormat)
    {
        if (component == 0)
        {
            return SHOW_TIME_24_NUMBER_OF_HOURS;
        }
        else if (component == 1)
        {
            return NUMBER_OF_MINUTES;
        }
    }
    else
    {
        if (component == 0)
        {
            return SHOW_TIME_12_NUMBER_OF_HOURS;
        }
        else if (component == 1)
        {
            return NUMBER_OF_MINUTES;
        }
        else if (component == 2)
        {
            return NUMBER_OF_PERIODS;
        }
    }
    return 0;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.numOfComponents;
}

#pragma UIPickerViewDelegate
-(CGFloat)pickerView:(UIPickerView *)pickerView
rowHeightForComponent:(NSInteger)component
{
    return 44.0f;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView
   widthForComponent:(NSInteger)component
{
    return 40.0f;
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView
            attributedTitleForRow:(NSInteger)row
                     forComponent:(NSInteger)component
{
    NSString *unformattedReturnString = nil;
    if (component == 0)
    {
        unformattedReturnString = [NSString stringWithFormat:@"%lu", row + 1];
    }
    else if (component == 1)
    {
        if (row < 10)
        {
            unformattedReturnString = [NSString stringWithFormat:@"%u", 0];
            unformattedReturnString = [unformattedReturnString stringByAppendingString:[NSString stringWithFormat:@"%lu", row]];
        }
        else
        {
            unformattedReturnString = [NSString stringWithFormat:@"%lu", row];
        }
    }
    else if (component == 2)
    {
        unformattedReturnString = row == 0 ? @"AM" : @"PM";
    }
    
    NSDictionary *attStringDictionary = @{NSFontAttributeName : self.displayFont,
                                          NSForegroundColorAttributeName : self.fontColor};
    return [[NSAttributedString alloc] initWithString:unformattedReturnString attributes:attStringDictionary];
}

-(void)pickerView:(UIPickerView *)pickerView
     didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSMutableString *dateAsString = nil;
    if (self.alarmClockModel.showTimeIn24HourFormat)
    {
        
    }
}

-(void)nothingNothing
{
    
    
    
    NSString *currSelectedTimeString = [self.alarmClockModel.dateFormatter stringFromDate:self.currSelectedTime];

    NSArray *parsedSelected24HourTimeArray = [currSelectedTimeString componentsSeparatedByString:@":"];
    
    NSMutableCharacterSet *parsingCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@":"];
    [parsingCharacterSet addCharactersInString:@" "];
    
    NSArray *parsedSelected12HourTimeArray = [currSelectedTimeString componentsSeparatedByCharactersInSet:parsingCharacterSet];
    
}

@end
