//
//  AlarmSound.m
//  Flounds
//
//  Created by Paul M Rest on 10/22/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "AlarmSound.h"

@interface AlarmSound ()

@property (nonatomic, strong, readwrite) NSString *soundFileName;

@property (nonatomic, strong, readwrite) NSString *soundFilePath;

@property (nonatomic, strong, readwrite) NSString *soundDisplayName;

@end


@implementation AlarmSound

-(id)initWithSoundFileName:(NSString *)soundFileName
               andFilePath:(NSString *)soundFilePath
       andSoundDisplayName:(NSString *)soundDisplayName
{
    self = [super init];
    if (self)
    {
        if (soundFileName && soundFilePath && soundDisplayName)
        {
            _soundFileName = soundFileName;
            _soundFilePath = soundFilePath;
            _soundDisplayName = soundDisplayName;
            return self;
        }
    }
    return nil;
}

NSString *kSoundFileNameKey = @"SoundFileName";
NSString *kSoundFilePathKey = @"SoundFilePath";
NSString *kSoundDisplayNameKey = @"SoundDisplayName";

-(id)initWithCoder:(NSCoder *)aDecoder
{
    return [self initWithSoundFileName:[aDecoder decodeObjectForKey:kSoundFileNameKey]
                           andFilePath:[aDecoder decodeObjectForKey:kSoundFilePathKey]
                   andSoundDisplayName:[aDecoder decodeObjectForKey:kSoundDisplayNameKey]];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.soundFileName forKey:kSoundFileNameKey];
    [aCoder encodeObject:self.soundFilePath forKey:kSoundFilePathKey];
    [aCoder encodeObject:self.soundDisplayName forKey:kSoundDisplayNameKey];
}

@end
