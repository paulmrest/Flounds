//
//  SettingUnwindDelegate.h
//  Flounds
//
//  Created by Paul Rest on 10/27/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SettingUnwindDelegate <NSObject>

@optional

-(void)cancelAndUnwindToSettingsTV;

-(void)setNewDefaultSnoozeValueAndUnwind;

-(void)setNewDifficultyAndUnwind;

-(void)unwindToSettingsTV;

@end
