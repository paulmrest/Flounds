    //
//  AlarmClockVC.m
//  Flounds
//
//  Created by Paul Rest on 6/21/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "AlarmClockVC.h"

NSString *ALARM_SETTER_SEGUE_ID = @"AlarmSetterSegue";

NSString *PATTERN_MAKER_SEGUE_ID = @"PatternMakerSnoozeSegue";


NSString *SETTINGS_BUTTON_TITLE;

NSString *END_SNOOZE_BUTTON_TITLE;

const NSTimeInterval SNOOZE_STATE_RECOVERY_WINDOW = 15.0;


@interface AlarmClockVC ()

@property (nonatomic, strong) AlarmClockModel *alarmClockModel;

@property (nonatomic) BOOL showTimeIn24HourFormat;

@property (nonatomic) BOOL stopUpdatingClocks;

@property (nonatomic, strong) NSDate *currSnoozeEndTime;

@property (nonatomic) NSUInteger snoozeCount;


//resignedFromActiveStatus, snoozeCountDiskURL, appKillTime, appKillTimeDiskURL, and fileManager support the capability of the app to restore
//itself if the user accidently unlocks the device from a notification, causing the device to switch to another
//app; in that event, the user has 15 seconds (SNOOZE_STATE_RECOVERY_WINDOW) to switch back to Flounds and pick up
//where they left off; after 15 seconds the app simply reenters its last saved state

@property (nonatomic) BOOL resignedFromActiveStatus;

@property (nonatomic, strong) NSURL *snoozeCountDiskURL;

@property (nonatomic, strong) NSDate *appKillTime;

@property (nonatomic, strong) NSURL *appKillTimeDiskURL;

@property (nonatomic, strong) NSFileManager *fileManager;


@property (nonatomic) BOOL alarmCurrentlySnoozing;

@property (nonatomic, strong) NSTimer *clockTimer;

@property (nonatomic, strong) AVAudioPlayer *alarmNoisePlayer;

@property (nonatomic, strong) AVAudioSession *audioSessionSingleton;

@property (nonatomic, strong) AlarmSoundManager *soundManager;

@property (nonatomic, strong) FloundsModel *floundsModel;

//>>>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *snoozeNowButton;

@property (nonatomic, strong) NSDate *segueStartTime;

@property (nonatomic) NSUInteger snoozeNowCount;
//<<<

@end


@implementation AlarmClockVC

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initHelper];
    }
    return self;
}

-(void)initHelper
{
    self.alarmClockModel = [[AlarmClockModel alloc] init];
    
    self.floundsModel = [[FloundsModel alloc] initWithUserSettings];
    
    self.audioSessionSingleton = [AVAudioSession sharedInstance];
    [self soundManager];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.snoozeCount = 0;
    self.alarmCurrentlySnoozing = NO;
    self.showTimeIn24HourFormat = [self.alarmClockModel showTimeIn24HourFormat];
    
    self.clockView.alarmClockModel = self.alarmClockModel;
    
    self.alarmTimesTV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    SETTINGS_BUTTON_TITLE = NSLocalizedString(@"Settings", nil);
    END_SNOOZE_BUTTON_TITLE = NSLocalizedString(@"End Snooze", nil);
    
    self.clockTimer = [NSTimer timerWithTimeInterval:0.25
                                              target:self
                                            selector:@selector(updateClocks)
                                            userInfo:nil
                                             repeats:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resignFromActiveStatus)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(returnToActiveStatus)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self.alarmClockModel alarmCurrentlySounding])
    {
        [self.settingsEndSnoozeButton setTitle:END_SNOOZE_BUTTON_TITLE forState:UIControlStateNormal];
    }
    else
    {
        [self.settingsEndSnoozeButton setTitle:SETTINGS_BUTTON_TITLE forState:UIControlStateNormal];
    }
    
    if (self.showTimeIn24HourFormat != self.alarmClockModel.showTimeIn24HourFormat)
    {
        self.showTimeIn24HourFormat = self.alarmClockModel.showTimeIn24HourFormat;
        [self.alarmTimesTV.visibleCells makeObjectsPerformSelector:@selector(resetDateFormatter)];
    }
    [self.alarmTimesTV reloadData];
}

-(void)viewDidLayoutSubviews
{
    self.settingsEndSnoozeButton.containingVC = self;
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.settingsEndSnoozeButton];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self restoreAlarmingAndFloundsStates];

    [[NSRunLoop currentRunLoop] addTimer:self.clockTimer forMode:NSDefaultRunLoopMode];
    self.stopUpdatingClocks = NO;
}

//AppDelegate calls this every time the app enters the background, but the app only saves the
//appropriate states if [self.alarmClockModle alarmCurrentlySounding] returns yes
-(void)saveAlarmingAndFloundsState
{
    if ([self.alarmClockModel alarmCurrentlySounding]) //we will only be saving these if the user quits the app while an alarm is sounding
    {
        if ([self.alarmClockModel saveCurrentlySoundingAlarmToDisk] && [self saveSnoozeCountToDisk])
        {
            NSDate *appKillTime = [NSDate date];
            if (![NSKeyedArchiver archiveRootObject:appKillTime toFile:self.appKillTimeDiskURL.path])
            {
                NSLog(@"AlarmClockVC - saveAlarmingAndFloundsState");
                NSLog(@"there was an error saving appKillTime to disk");
            }
        }
    }
}

-(void)restoreAlarmingAndFloundsStates
{
    if ([self.fileManager fileExistsAtPath:self.snoozeCountDiskURL.path] &&
        [self.fileManager fileExistsAtPath:self.appKillTimeDiskURL.path])
    {
        NSDate *appKillTime = [NSKeyedUnarchiver unarchiveObjectWithFile:self.appKillTimeDiskURL.path];
        NSTimeInterval intervalSinceKillTime = [[NSDate date] timeIntervalSinceDate:appKillTime];
        if (intervalSinceKillTime <= SNOOZE_STATE_RECOVERY_WINDOW)
        {
            NSNumber *snoozeCountFromDisk = [NSKeyedUnarchiver unarchiveObjectWithFile:self.snoozeCountDiskURL.path];
            NSInteger potentialSnoozeCount = [snoozeCountFromDisk integerValue];
            if (potentialSnoozeCount >= 0)
            {
                self.snoozeCount = potentialSnoozeCount;
                
                [self.alarmClockModel setCurrentlySoundingAlarmFromDisk];
                
                [self alarmNoisePlayerForImminentAlarmTime:[self.alarmClockModel getCurrentlySoundingAlarm]];
                self.alarmNoisePlayer.numberOfLoops = -1; //loops indefinitely
                [self.alarmNoisePlayer prepareToPlay];
                
                if (self.snoozeCount > 0)
                {
                    [self.floundsModel setNewSequenceForSnoozeCount:self.snoozeCount];
                }
                
                [self activateAudioSessionAndPlayAlarm];
                [self performSegueWithIdentifier:PATTERN_MAKER_SEGUE_ID sender:self];
            }
        }
        
        //even if intervalSinceKillTime > SNOOZE_STATE_RECOVERY_WINDOW we still want to clean up the files
        //we saved to the disk for state recovery
        NSError *removeSnoozeCountError = nil;
        BOOL removeSnoozeFromDiskResult = [self.fileManager removeItemAtPath:self.snoozeCountDiskURL.path
                                                                       error:&removeSnoozeCountError];
        
        NSError *removeAppKillTimeError = nil;
        BOOL removeAppKillTimeFromDiskResult = [self.fileManager removeItemAtPath:self.appKillTimeDiskURL.path
                                                                            error:&removeAppKillTimeError];
        if (!removeSnoozeFromDiskResult || removeSnoozeCountError || !removeAppKillTimeFromDiskResult || removeAppKillTimeError)
        {
            NSLog(@"AlarmClockVC - restoreAlarmingAndFloundsStates");
            NSLog(@"there was an error removing the saved snoozeCount from the disk");
        }
    }
}

-(BOOL)saveSnoozeCountToDisk
{
    BOOL snoozeSaved = NO;
    snoozeSaved = [NSKeyedArchiver archiveRootObject:[NSNumber numberWithInteger:self.snoozeCount] toFile:self.snoozeCountDiskURL.path];
    if (!snoozeSaved)
    {
        
    }
    return snoozeSaved;
}

-(NSURL *)snoozeCountDiskURL
{
    if (!_snoozeCountDiskURL)
    {
        NSArray *possibleURLs = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        if ([possibleURLs count] > 0)
        {
            NSURL *tempSnoozeCountDiskURL = possibleURLs[0];
            tempSnoozeCountDiskURL = [tempSnoozeCountDiskURL URLByAppendingPathComponent:@"SnoozeCount"];
            if (tempSnoozeCountDiskURL)
            {
                _snoozeCountDiskURL = tempSnoozeCountDiskURL;
            }
        }
    }
    return _snoozeCountDiskURL;
}

-(NSURL *)appKillTimeDiskURL
{
    if (!_appKillTimeDiskURL)
    {
        NSArray *possibleURLs = [self.fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        if ([possibleURLs count] > 0)
        {
            NSURL *tempAppKillTimeDiskURL = possibleURLs[0];
            tempAppKillTimeDiskURL = [tempAppKillTimeDiskURL URLByAppendingPathComponent:@"AppKillTime"];
            if (tempAppKillTimeDiskURL)
            {
                _appKillTimeDiskURL = tempAppKillTimeDiskURL;
            }
        }
    }
    return _appKillTimeDiskURL;
}

-(NSFileManager *)fileManager
{
    if (!_fileManager)
    {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

-(void)resignFromActiveStatus
{
    //>>>
//    NSLog(@"AlarmClockVC - resignFromActiveStatus");
    //<<<
    self.resignedFromActiveStatus = YES;
}

-(void)returnToActiveStatus
{
    //>>>
//    NSLog(@"AlarmClockVC - returnToActiveStatus");
    //<<<
    self.resignedFromActiveStatus = NO;
    if ([self.alarmClockModel alarmCurrentlySounding] && !self.alarmCurrentlySnoozing)
    {
        [self performSegueWithIdentifier:PATTERN_MAKER_SEGUE_ID sender:self];
    }
}

-(AlarmSoundManager *)soundManager
{
    if (!_soundManager)
    {
        _soundManager = [[AlarmSoundManager alloc] initWithAvailableSounds];
    }
    return _soundManager;
}

-(AVAudioPlayer *)alarmNoisePlayer
{
    if (!_alarmNoisePlayer)
    {
        _alarmNoisePlayer = [[AVAudioPlayer alloc] init];
    }
    return _alarmNoisePlayer;
}

-(AVAudioPlayer *)alarmNoisePlayerForImminentAlarmTime:(NSDate *)alarmTimeDate;
{
    if (!_alarmNoisePlayer)
    {
        NSError *error = nil;
        NSURL *alarmNoiseURL = [self.soundManager getAlarmURLForDisplayName:[self.alarmClockModel getAlarmSoundForAlarmTime:alarmTimeDate]];
        
        //>>>
        if (!alarmNoiseURL)
        {
            alarmNoiseURL = [self.soundManager getCurrentlySelectedAlarmURL];
        }
        //<<<
        
        
        _alarmNoisePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:alarmNoiseURL
                                                                   error:&error];
        if (error)
        {
            //>>>
            NSLog(@"AlarmClockVC - alarmNoisePlayer lazy init");
            NSLog(@"error found when initing from getCurrentlySelectedAlarmURL of self.soundManager");
            //<<<
        }
    }
    return _alarmNoisePlayer;
}

-(void)activateAudioSessionAndPlayAlarm
{
    NSError *audioSessionError = nil;
    BOOL setCategoryResult = [self.audioSessionSingleton setCategory:AVAudioSessionCategoryPlayback
                                                         withOptions:AVAudioSessionCategoryOptionDuckOthers
                                                               error:&audioSessionError];
    BOOL activateResult = [self.audioSessionSingleton setActive:YES error:&audioSessionError];
    if (setCategoryResult && activateResult && !audioSessionError)
    {
        //>>>
//        NSLog(@"BEEP BEEP BEEP BEEP");
        //<<<
        [self.alarmNoisePlayer play];
    }
    else
    {
        NSLog(@"AlarmClockVC - activateAudioSessionAndPlayAlarm - error setting up self.audioSessionSingleton");
    }
}

-(void)deactivateAudioSessionAndStopAlarm
{
    [self.alarmNoisePlayer stop];
    
    NSError *audioSessionError = nil;
    BOOL deactivateResult = [self.audioSessionSingleton setActive:NO error:&audioSessionError];
    
    if (deactivateResult && !audioSessionError)
    {

    }
    else
    {
        NSLog(@"AlarmClockVC - deactivateAudioSessionAndStopAlarm - error setting up self.audioSessionSingleton");
    }
}

-(void)stopAlarmSound
{
    
}

#pragma DeactivateSnoozeProtocol
-(void)deactivateSnoozeStateForAlarmTime:(NSDate *)alarmDate
{
    if (self.alarmCurrentlySnoozing)
    {
        //>>>
//        NSLog(@"AlarmClockVC - deactivateSnoozeStateForAlarmTime:...");
//        NSLog(@"alarmDate: %@", [alarmDate description]);
//        NSLog(@"[self.alarmClockModel getCurrentlySoundingAlarm]: %@", [[self.alarmClockModel getCurrentlySoundingAlarm] description]);
        //<<<
        
        if ([alarmDate isEqualToDate:[self.alarmClockModel getCurrentlySoundingAlarm]])
        {
            [self settingsEndSnoozeButtonPush:self.settingsEndSnoozeButton];
        }
    }
}

#pragma Update ClockView
-(void)updateClocks
{
    if (!self.stopUpdatingClocks)
    {
        [self.clockView updateDisplayedTime];
        if (![self.alarmClockModel alarmCurrentlySounding])
        {
            if ([self.alarmClockModel checkAlarmTimes])
            {
                [self activateAudioSessionAndPlayAlarm];
                
                if (!self.resignedFromActiveStatus)
                {
                    [self performSegueWithIdentifier:PATTERN_MAKER_SEGUE_ID sender:self]; //only called when alarm goes off with device unlocked
                }
            }
            else
            {
                NSDate *nextAlarmTime = [self.alarmClockModel getNextActiveAlarm];
                NSTimeInterval intervalToNextAlarm = [nextAlarmTime timeIntervalSinceNow];
                if (intervalToNextAlarm < 1.0 && intervalToNextAlarm > 0.0)
                {
                    [self alarmNoisePlayerForImminentAlarmTime:nextAlarmTime];
                    self.alarmNoisePlayer.numberOfLoops = -1; //loops indefinitely
                    [self.alarmNoisePlayer prepareToPlay];
                }
            }
        }
        else
        {
            NSTimeInterval comparisonInterval = [self.currSnoozeEndTime timeIntervalSinceNow];
            if (comparisonInterval < 0.0 && self.alarmCurrentlySnoozing)
            {
                self.alarmCurrentlySnoozing = NO;
                [self activateAudioSessionAndPlayAlarm];
                if (!self.resignedFromActiveStatus)
                {
                    [self performSegueWithIdentifier:PATTERN_MAKER_SEGUE_ID sender:self]; //only called when snooze ends with device unlocked
                }
            }
        }
    }
}

-(void)checkForSetAlarm
{
    [self.alarmClockModel checkAlarmTimes];
}

#pragma UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.alarmClockModel getAlarmTimes] count] + 1; //bottom cell will be empty but will not be nil to allow adding another alarm time
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AlarmTime"];
    
    tableViewCell.backgroundColor = self.defaultBackgroundColor;
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:tableViewCell];
    
    if ([tableViewCell isKindOfClass:[AlarmTimeCell class]])
    {
        AlarmTimeCell *alarmCell = (AlarmTimeCell *)tableViewCell;
        alarmCell.cellText.textColor = self.defaultUIColor;
        alarmCell.containingVC = self;
        
        alarmCell.deactivateSnoozeDelegate = self;
        
        NSUInteger numberOfSetAlarms = [[self.alarmClockModel getAlarmTimes] count];

        NSDate *alarmTimeDate = nil;
        if (indexPath.row < numberOfSetAlarms)
        {
            alarmTimeDate = [self.alarmClockModel alarmTimeAtIndex:indexPath.row];
            alarmCell.active = [self.alarmClockModel alarmTimeIsActiveAtIndex:indexPath.row];
            alarmCell.alarmClockModel = self.alarmClockModel;
        }
        alarmCell.alarmTimeDate = alarmTimeDate;
        [alarmCell setupCellDisplay];
        return alarmCell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedTVCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedTVCell isKindOfClass:[FloundsTVCell class]])
    {
        FloundsTVCell *selectedFloundsTVCell = (FloundsTVCell *)selectedTVCell;
        [selectedFloundsTVCell animateCellForSelectionToPerformSegue:ALARM_SETTER_SEGUE_ID];
    }
    [self animateNonSelectedTableViewCells:tableView];
}

//>>>
-(IBAction)snoozeNowAction:(UIBarButtonItem *)sender
{
//    self.segueStartTime = [NSDate date];
    [self performSegueWithIdentifier:PATTERN_MAKER_SEGUE_ID sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue
                sender:(id)sender
{
    if ([segue.identifier isEqualToString:ALARM_SETTER_SEGUE_ID])
    {
        if ([sender isKindOfClass:[AlarmTimeCell class]])
        {
            AlarmTimeCell *selectedAlarmCell = (AlarmTimeCell *)sender;
            NSIndexPath *selectedPath = [self.alarmTimesTV indexPathForCell:selectedAlarmCell];
            if (selectedPath)
            {
                if ([segue.destinationViewController isKindOfClass:[AlarmSetterVC class]])
                {
                    AlarmSetterVC *alarmSetterVC = (AlarmSetterVC *)segue.destinationViewController;
                    
                    [alarmSetterVC setAlarmTimeDate:selectedAlarmCell.alarmTimeDate];
                    alarmSetterVC.alarmClockModel = self.alarmClockModel;
                    alarmSetterVC.soundManager = self.soundManager;
                    self.stopUpdatingClocks = YES;
                    alarmSetterVC.presentingVC = self;
                }
            }
        }
    }
    if ([segue.identifier isEqualToString:PATTERN_MAKER_SEGUE_ID])
    {
        if ([segue.destinationViewController isKindOfClass:[PatternMakerVC class]])
        {
            PatternMakerVC *patternMaker = (PatternMakerVC *)segue.destinationViewController;
            self.stopUpdatingClocks = YES;
            patternMaker.patternMakerDelegate = self;
            if (self.snoozeCount == 0)
            {
                [self.floundsModel getNewStartingSequence];
            }
            patternMaker.floundsModel = self.floundsModel;
        }
    }
    if ([segue.identifier isEqualToString:@"SnoozeNow"])
    {        
        PatternMakerVC *patternMaker = (PatternMakerVC *)segue.destinationViewController;
        self.stopUpdatingClocks = YES;
        patternMaker.patternMakerDelegate = self;
        if (self.snoozeCount == 0)
        {
            [self.floundsModel getNewStartingSequence];
        }
        patternMaker.floundsModel = self.floundsModel;
    }
    if ([segue.identifier isEqualToString:@"ToSettings"])
    {
        if ([segue.destinationViewController isKindOfClass:[SettingsVC class]])
        {
            SettingsVC *settingsVC = (SettingsVC *)segue.destinationViewController;
            settingsVC.alarmClockModel = self.alarmClockModel;
            settingsVC.floundsModel = self.floundsModel;
            settingsVC.soundManager = self.soundManager;
            settingsVC.presentingVC = self;
        }
    }
}

-(IBAction)settingsEndSnoozeButtonPush:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *settingsEndSnoozeFloundsButton = (FloundsButton *)sender;
        if ([settingsEndSnoozeFloundsButton.titleLabel.text isEqualToString:SETTINGS_BUTTON_TITLE])
        {
            [settingsEndSnoozeFloundsButton animateForPushPerformSegueWithIdentifier:@"ToSettings"];
        }
        else if ([settingsEndSnoozeFloundsButton.titleLabel.text isEqualToString:END_SNOOZE_BUTTON_TITLE])
        {
            [self.alarmClockModel endCurrentSoundingAlarm];
            self.alarmCurrentlySnoozing = NO;
            self.snoozeCount = 0;
            self.currSnoozeEndTime = nil;
            self.alarmNoisePlayer = nil;
            
            [self.settingsEndSnoozeButton setTitle:SETTINGS_BUTTON_TITLE forState:UIControlStateNormal];
            [self.settingsEndSnoozeButton animateForPushNoSegue];
        }
    }
}

-(void)removeAnimationsFromPresentingVC
{
    [super removeAnimationsFromPresentingVC];
    [self.settingsEndSnoozeButton.layer removeAllAnimations];
}

#pragma ModalPatternMakerDelegate
-(void)dismissPatternMaker
{
    self.stopUpdatingClocks = NO;
    
    [self deactivateAudioSessionAndStopAlarm];
    
    NSTimeInterval intervalToNextAlarm = [self.alarmClockModel snoozeIntervalForSoundingAlarm];
    if (intervalToNextAlarm > 0.0)
    {
        //>>>
        //convert minutes to seconds for testing
        if (self.alarmClockModel.debuggingSnoozeInSeconds)
        {
            intervalToNextAlarm = intervalToNextAlarm / 60;            
        }
        //<<<
        
        self.currSnoozeEndTime = [NSDate dateWithTimeIntervalSinceNow:intervalToNextAlarm];
    }
    
    self.snoozeCount++;
    self.alarmCurrentlySnoozing = YES;
    [self.floundsModel incrementDifficultyAndGetNewSequence];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
