//
//  SetAlarmSoundProtocol.h
//  Flounds
//
//  Created by Paul M Rest on 10/27/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SetAlarmSoundProtocol <NSObject>

@property (nonatomic, strong) NSString *initialAlarmSound;

@property (nonatomic, strong) NSString *currAlarmSound;


-(void)setAlarmSound:(NSString *)currAlarmSound;

@end
