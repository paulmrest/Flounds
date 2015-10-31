//
//  AlarmSoundManager.m
//  Flounds
//
//  Created by Paul Rest on 11/18/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "AlarmSoundManager.h"

@interface AlarmSoundManager ()

@property (nonatomic, strong) NSArray *availableSounds;

@property (nonatomic, strong) NSArray *namesOfAvailableSounds;

@property (nonatomic, strong) AlarmSound *currentlySelectedSound;

@property (nonatomic, strong) NSURL *currentlySelectedSoundURL;

@property (nonatomic, strong) NSFileManager *fileManager;

@end


@implementation AlarmSoundManager

-(id)initWithAvailableSounds
{
    self = [super init];
    if (self)
    {
        [self loadAvailableSounds];
        [self namesOfAvailableAlarmSounds];
        [self setCurrentlySelectedSoundFromDisk];
    }
    return self;
}

-(NSFileManager *)fileManager
{
    if (!_fileManager)
    {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

-(void)loadAvailableSounds
{
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    
    NSError *getAllBundleFilesError = nil;
    NSArray *unfilteredBundleFiles = [self.fileManager contentsOfDirectoryAtPath:bundleRoot error:&getAllBundleFilesError];
    if (!getAllBundleFilesError)
    {
        NSPredicate *wavFileFilter = [NSPredicate predicateWithFormat:@"self ENDSWITH[c] '.wav'"];
        NSArray *onlyWavFiles = [unfilteredBundleFiles filteredArrayUsingPredicate:wavFileFilter];
        
        NSMutableArray *tempBuildingArray = [[NSMutableArray alloc] initWithCapacity:[onlyWavFiles count]];
        for (NSString *wavFileName in onlyWavFiles)
        {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:wavFileName
                                                                 ofType:nil];
            NSString *soundDisplayName = [wavFileName componentsSeparatedByString:@"."][0];
            
            [tempBuildingArray addObject:[[AlarmSound alloc] initWithSoundFileName:wavFileName
                                                                       andFilePath:filePath
                                                               andSoundDisplayName:soundDisplayName]];
        }
        self.availableSounds = [NSArray arrayWithArray:tempBuildingArray];
    }
}

-(NSArray *)namesOfAvailableAlarmSounds
{
    if (!_namesOfAvailableSounds)
    {
        NSMutableArray *tempBuildingArray = [[NSMutableArray alloc] initWithCapacity:[self.availableSounds count]];
        for (AlarmSound *oneSound in self.availableSounds)
        {
            [tempBuildingArray addObject:oneSound.soundDisplayName];
        }
        _namesOfAvailableSounds = [tempBuildingArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }
    return _namesOfAvailableSounds;
}

NSString *kCurrentlySelectedSoundUserDefaultKey = @"currentlySelectedSound";

-(NSURL *)currentlySelectedSoundURL
{
    if (!_currentlySelectedSoundURL)
    {
        NSArray *possibleURLs = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        if ([possibleURLs count] > 0)
        {
            NSURL *baseURL = possibleURLs[0];
            _currentlySelectedSoundURL = [baseURL URLByAppendingPathComponent:@"CurrentSound"];
        }
    }
    return _currentlySelectedSoundURL;
}

-(void)setCurrentlySelectedSoundFromDisk
{
    NSString *currentlySelectedSoundFileName = [[NSUserDefaults standardUserDefaults] stringForKey:kCurrentlySelectedSoundUserDefaultKey];
    if (currentlySelectedSoundFileName)
    {
        for (AlarmSound *oneSound in self.availableSounds)
        {
            if ([currentlySelectedSoundFileName isEqualToString:oneSound.soundFileName])
            {
                self.currentlySelectedSound = oneSound;
                return;
            }
        }
    }
    //if !currentlySelectedSoundStringPath or the string retreived from NSUserDefaults doesn't match any of the soundFileNames
    //in self.availableSounds
    self.currentlySelectedSound = self.availableSounds[0];
}

-(BOOL)setDefaultAlarmFromDisplayName:(NSString *)alarmDisplayName
{
    for (AlarmSound *oneSound in self.availableSounds)
    {
        if ([oneSound.soundDisplayName isEqualToString:alarmDisplayName])
        {
            self.currentlySelectedSound = oneSound;
            [[NSUserDefaults standardUserDefaults] setObject:oneSound.soundFileName
                                                      forKey:kCurrentlySelectedSoundUserDefaultKey];
            if ([[NSUserDefaults standardUserDefaults] synchronize])
            {
                return YES;
            }
        }
    }
    return NO;
}

-(NSArray *)getAlarmSoundNames
{
    return [NSArray arrayWithArray:self.namesOfAvailableSounds];
}

-(NSString *)getDefaultAlarmSoundName
{
    return self.currentlySelectedSound.soundDisplayName;
}

-(NSURL *)getCurrentlySelectedAlarmURL
{
    //>>>
//    NSString *returnPath = self.currentlySelectedSound.soundFilePath;
//    NSURL *returnURL = [NSURL fileURLWithPath:returnPath isDirectory:NO];
    //<<<
    return [NSURL fileURLWithPath:self.currentlySelectedSound.soundFilePath isDirectory:NO];
}

-(NSURL *)getAlarmURLForDisplayName:(NSString *)alarmDisplayName
{
    for (AlarmSound *oneSound in self.availableSounds)
    {
        if ([alarmDisplayName isEqualToString:oneSound.soundDisplayName])
        {
            return [NSURL fileURLWithPath:oneSound.soundFilePath isDirectory:NO];
        }
    }
    return nil;
}

-(BOOL)selectAlarm:(NSUInteger)indexOfAlarm
{
    return YES;
}

@end
