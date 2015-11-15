    //
//  ClockViewText.m
//  Flounds
//
//  Created by Paul Rest on 10/25/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "ClockViewText.h"

const CGFloat CLOCK_DISPLAY_NON24HOUR_PERIOD_SPACE_FACTOR = 0.35f;

@interface ClockViewText ()

//only used if displaying time in a 12-hour format, if displaying in a 24-hour format class uses
//the textDrawOriginPoint property inherited from super
@property (nonatomic, strong) NSAttributedString *hoursMinutesSecondsAttString;
@property (nonatomic) CGPoint hoursMinutesSecondsDrawOrigin;
@property (nonatomic, strong) NSAttributedString *AMorPMAttString;
@property (nonatomic) CGPoint AMorPMDrawOrigin;
@property (nonatomic) BOOL non24HourDrawingPointsSet;

@end

@implementation ClockViewText

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initHelperClockView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initHelperClockView];
    }
    return self;
}

-(void)initHelperClockView
{
    self.centerTextOnEachRedrawCycle = NO;
    self.checkFontSizeOnEachRedrawCycle = NO;
    self.dateFormatter = self.alarmClockModel.dateFormatter;
    self.non24HourDrawingPointsSet = NO;
}

-(void)setAlarmClockModel:(AlarmClockModel *)alarmClockModel
{
    _alarmClockModel = alarmClockModel;
    if (_alarmClockModel)
    {
        self.dateFormatter = _alarmClockModel.dateFormatter;
    }
}

-(void)updateDisplayedTime
{
    NSDate *currDate = [NSDate date];
    NSString *currentTimeString = [self.dateFormatter stringFromDate:currDate];
    if (self.alarmClockModel.showTimeIn24HourFormat)
    {
        self.displayText = currentTimeString;
    }
    //since the client class is likely using a non-monospaced font for self.displayfont, if we are displaying
    //the time in 12-hour format, if we simply use super's single textDrawOriginPoint property the "AM/PM" part
    //of the time unnecessarily jumps around at the size of the characters changes
    //the below code cuts the string into two strings, one with the hours and minutes, and the other with the AM/PM;
    //it generates the NSAttributedStrings and the CGPoints used to draw those strings in drawRect
    else
    {
        if (!self.displayFont)
        {
            self.displayFont = [FloundsAppearanceUtility getFloundsFontForBounds:self.frame
                                                                 givenSampleText:currentTimeString
                                                                forBorderedSpace:NO];
        }
        
        NSDictionary *attTextAttributes = @{NSFontAttributeName : self.displayFont, NSForegroundColorAttributeName : self.fontColor};
        
        NSDateFormatter *dateFormatterHoursMinutesSecondsOnly = [self.dateFormatter copy];
        [dateFormatterHoursMinutesSecondsOnly setDateFormat:@"h:mm:ss"];
        NSString *hoursMinutesSecondsOnly = [dateFormatterHoursMinutesSecondsOnly stringFromDate:currDate];
        self.hoursMinutesSecondsAttString = [[NSAttributedString alloc] initWithString:hoursMinutesSecondsOnly
                                                                            attributes:attTextAttributes];
        
        NSDateFormatter *dateFormatterAMPMOnly = [self.dateFormatter copy];
        [dateFormatterAMPMOnly setDateFormat:@"a"];
        NSString *AMPMOnly = [dateFormatterAMPMOnly stringFromDate:currDate];
        self.AMorPMAttString = [[NSAttributedString alloc] initWithString:AMPMOnly
                                                               attributes:attTextAttributes];
        
        if (!self.non24HourDrawingPointsSet)
        {
            CGFloat AMorPMSpace = self.AMorPMAttString.size.height * CLOCK_DISPLAY_NON24HOUR_PERIOD_SPACE_FACTOR;
            
            CGFloat yDrawingPoint = (self.frame.size.height - self.hoursMinutesSecondsAttString.size.height) / 2.0f;
            CGFloat totalWidth = self.hoursMinutesSecondsAttString.size.width + self.AMorPMAttString.size.width + AMorPMSpace;
            self.hoursMinutesSecondsDrawOrigin = CGPointMake((self.frame.size.width - totalWidth) / 2.0f,
                                                             yDrawingPoint);
            
            
            self.AMorPMDrawOrigin = CGPointMake(self.hoursMinutesSecondsDrawOrigin.x + self.hoursMinutesSecondsAttString.size.width + AMorPMSpace,
                                                yDrawingPoint);
            self.non24HourDrawingPointsSet = YES;
        }
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    if (self.alarmClockModel.showTimeIn24HourFormat)
    {
        [super drawRect:rect];
    }
    else
    {
        [self.hoursMinutesSecondsAttString drawAtPoint:self.hoursMinutesSecondsDrawOrigin];
        [self.AMorPMAttString drawAtPoint:self.AMorPMDrawOrigin];
    }

}

@end
