//
//  AlarmSound.h
//  Flounds
//
//  Created by Paul M Rest on 10/22/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlarmSound : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSString *soundFileName;

@property (nonatomic, strong, readonly) NSString *soundFilePath;

@property (nonatomic, strong, readonly) NSString *soundDisplayName;

-(id)initWithSoundFileName:(NSString *)soundFileName
               andFilePath:(NSString *)soundFilePath
       andSoundDisplayName:(NSString *)soundDisplayName;

@end
