//
//  ClockViewText.h
//  Flounds
//
//  Created by Paul Rest on 10/25/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerticallyAlignedTextView.h"
#import "VerticallyCenteredTextView.h"

#import "AlarmClockModel.h"

@interface ClockViewText : VerticallyCenteredTextView

@property (nonatomic, strong) AlarmClockModel *alarmClockModel;

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

-(void)updateDisplayedTime;

@end
