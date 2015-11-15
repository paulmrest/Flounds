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


//resignedFromActiveStatus, snoozeCountDiskURL, appKillTime, appKillTimeDiskURL, and fileManager support
//the capability of the app to restore itself if the user accidently unlocks the device from a notification
//from another app, causing the device to switch to that other app at unlock (or if the user simply accidently
//switches to another app); in that event, the user has 15 seconds (SNOOZE_STATE_RECOVERY_WINDOW) to switch
//back to Flounds and pick upwhere they left off; after 15 seconds the app simply reenters its last saved state

@property (nonatomic) BOOL errorSavingStateAtShutdown;

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


@end


@implementation AlarmClockVC

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initHelperAlarmClockVC];
    }
    return self;
}

-(void)initHelperAlarmClockVC
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
    
    self.settingsEndSnoozeButton.fullWidthButton = YES;
    
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
    self.settingsEndSnoozeButton.titleLabel.font = self.fullWidthFloundsButtonFont;
    self.settingsEndSnoozeButton.containingVC = self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.showGeneralErrorOnViewWillAppear)
    {
        [self presentGeneralErrorAlert];
    }
    else
    {
        [self checkForSavedAlarmingAndFloundsStates];

        [[NSRunLoop currentRunLoop] addTimer:self.clockTimer forMode:NSDefaultRunLoopMode];
        self.stopUpdatingClocks = NO;
    }
}

NSString *kAlarmingStateSuccessfullySavedKey = @"errorSavingAlarmState";

NSString *kAttemptedToSaveAlarmingStateKey = @"attemptedToSaveAlarmingState";

//AppDelegate calls this every time the app enters the background, but the app only saves the
//appropriate states if [self.alarmClockModle alarmCurrentlySounding] returns yes
-(void)saveAlarmingAndFloundsState
{
    BOOL attemptedToSaveAlarmingState = NO;
    
    if ([self.alarmClockModel alarmCurrentlySounding]) //we will only be saving these if the user quits the app while an alarm is sounding
    {
        attemptedToSaveAlarmingState = YES;
        
        BOOL saveAlarmingStateSuccess = NO;
        
        if ([self.alarmClockModel saveCurrentlySoundingAlarmToDisk] && [self saveSnoozeCountToDisk])
        {
            NSDate *appKillTime = [NSDate date];
            if ([NSKeyedArchiver archiveRootObject:appKillTime toFile:self.appKillTimeDiskURL.path])
            {
                saveAlarmingStateSuccess = YES;
            }
        }
        [[NSUserDefaults standardUserDefaults] setBool:saveAlarmingStateSuccess
                                                forKey:kAlarmingStateSuccessfullySavedKey];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:attemptedToSaveAlarmingState
                                            forKey:kAttemptedToSaveAlarmingStateKey];
}

-(void)checkForSavedAlarmingAndFloundsStates
{
    BOOL attemptedToSaveAlarmingStatePreviously = [[NSUserDefaults standardUserDefaults] boolForKey:kAttemptedToSaveAlarmingStateKey];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAttemptedToSaveAlarmingStateKey];

    if (attemptedToSaveAlarmingStatePreviously)
    {
        BOOL alarmStateSavedSuccessfully = [[NSUserDefaults standardUserDefaults] boolForKey:kAlarmingStateSuccessfullySavedKey];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kAlarmingStateSuccessfullySavedKey];
        
        if (alarmStateSavedSuccessfully)
        {
            if ([self.fileManager fileExistsAtPath:self.snoozeCountDiskURL.path] &&
                [self.fileManager fileExistsAtPath:self.appKillTimeDiskURL.path])
            {
                NSDate *appKillTime = [NSKeyedUnarchiver unarchiveObjectWithFile:self.appKillTimeDiskURL.path];
                NSTimeInterval intervalSinceKillTime = [[NSDate date] timeIntervalSinceDate:appKillTime];
                if (intervalSinceKillTime <= SNOOZE_STATE_RECOVERY_WINDOW)
                {
                    [self restoreAlarmingAndFloundsStates];
                }
                
                //even if intervalSinceKillTime > SNOOZE_STATE_RECOVERY_WINDOW we still want to clean up the files
                //we saved to the disk for state recovery
                [self removeAlarmingAndFloundsStateFiles];
            }
        }
        else//
        {
            [self removeAlarmingAndFloundsStateFiles];
            [self presentRestoreAlarmingStateAlert];
        }
    }
}

-(void)presentRestoreAlarmingStateAlert
{
    if (self.clockTimer.valid)
    {
        [self.clockTimer invalidate];
    }
    
    NSString *restoreErrorAlertTitle = NSLocalizedString(@"Restore State Error", nil);
    NSString *restoreErrorAlertBody = NSLocalizedString(@"Flounds should have restored its alarm state, but something went wrong. Pleaes restart the app. If the problem persists contact the developer.", nil);
    
    UIAlertController *restoreErrorAlert = [UIAlertController alertControllerWithTitle:restoreErrorAlertTitle
                                                                               message:restoreErrorAlertBody
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    NSString *okayActionButtonTitle = NSLocalizedString(@"Okay", nil);
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:okayActionButtonTitle
                                                         style:UIAlertActionStyleDefault
                                                       handler:NULL];
    
    [restoreErrorAlert addAction:okayAction];
    
    [self presentViewController:restoreErrorAlert
                       animated:YES
                     completion:NULL];
}

-(void)restoreAlarmingAndFloundsStates
{
    NSNumber *snoozeCountFromDisk = [NSKeyedUnarchiver unarchiveObjectWithFile:self.snoozeCountDiskURL.path];
    NSInteger potentialSnoozeCount = [snoozeCountFromDisk integerValue];
    if (potentialSnoozeCount >= 0)
    {
        self.snoozeCount = potentialSnoozeCount;
        
        if ([self.alarmClockModel setCurrentlySoundingAlarmFromDisk] &&
            [self setAlarmNoisePlayerForImminentAlarmTime:[self.alarmClockModel getCurrentlySoundingAlarm]])
        {
            self.alarmNoisePlayer.numberOfLoops = -1; //loops indefinitely
            [self.alarmNoisePlayer prepareToPlay];
            
            if (self.snoozeCount > 0)
            {
                [self.floundsModel setNewSequenceForSnoozeCount:self.snoozeCount];
            }
            
            [self activateAudioSessionAndPlayAlarm];
            [self performSegueWithIdentifier:PATTERN_MAKER_SEGUE_ID sender:self];
        }
        else
        {
            [self presentGeneralErrorAlert];
        }
    }
}

-(void)removeAlarmingAndFloundsStateFiles
{
    NSError *removeSnoozeCountError = nil;
    BOOL removeSnoozeFromDiskResult = [self.fileManager removeItemAtPath:self.snoozeCountDiskURL.path
                                                                   error:&removeSnoozeCountError];
    
    NSError *removeAppKillTimeError = nil;
    BOOL removeAppKillTimeFromDiskResult = [self.fileManager removeItemAtPath:self.appKillTimeDiskURL.path
                                                                        error:&removeAppKillTimeError];
    
    BOOL removeSoundingAlarmFromAlarmClockModel = [self.alarmClockModel clearCurrentlySoundingAlarmFromDisk];
    
    if (!removeSnoozeFromDiskResult || removeSnoozeCountError ||
        !removeAppKillTimeFromDiskResult || removeAppKillTimeError ||
        !removeSoundingAlarmFromAlarmClockModel)
    {

    }
}

-(BOOL)saveSnoozeCountToDisk
{
    return [NSKeyedArchiver archiveRootObject:[NSNumber numberWithInteger:self.snoozeCount] toFile:self.snoozeCountDiskURL.path];
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
    self.resignedFromActiveStatus = YES;
}

-(void)returnToActiveStatus
{
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

        if (!_soundManager)
        {
            self.showGeneralErrorOnViewWillAppear = YES;
        }
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

-(BOOL)setAlarmNoisePlayerForImminentAlarmTime:(NSDate *)alarmTimeDate;
{
    NSError *error = nil;
    NSURL *alarmNoiseURL = [self.soundManager getAlarmURLForDisplayName:[self.alarmClockModel getAlarmSoundForAlarmTime:alarmTimeDate]];
    
    self.alarmNoisePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:alarmNoiseURL
                                                               error:&error];
    if (error || !self.alarmNoisePlayer)
    {
        return NO;
    }
    return YES;
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
        [self.alarmNoisePlayer play];
    }
    else
    {
        [self presentGeneralErrorAlert];
    }
}

-(void)deactivateAudioSessionAndStopAlarm
{
    [self.alarmNoisePlayer stop];
    
    NSError *audioSessionError = nil;
    BOOL deactivateResult = [self.audioSessionSingleton setActive:NO error:&audioSessionError];

    if (!deactivateResult || audioSessionError)
    {
        self.showGeneralErrorOnViewWillAppear = YES;
    }
}

#pragma DeactivateSnoozeProtocol
-(void)deactivateSnoozeStateForAlarmTime:(NSDate *)alarmDate
{
    if (self.alarmCurrentlySnoozing)
    {
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
                    if ([self setAlarmNoisePlayerForImminentAlarmTime:nextAlarmTime])
                    {
                        self.alarmNoisePlayer.numberOfLoops = -1; //loops indefinitely
                        [self.alarmNoisePlayer prepareToPlay];
                    }
                    else
                    {
                        [self presentGeneralErrorAlert];
                    }
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

#pragma UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat displayFontPointSize = self.nonFullWidthFloundsButtonAndTVCellFont.pointSize;
    
    CGFloat cellHeightReturnValue = displayFontPointSize + (displayFontPointSize * [FloundsViewConstants getTableViewCellHeightSizingFactor]);
    
    return cellHeightReturnValue;
}

#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.alarmClockModel getAlarmTimes] count] + 1;
    //+1 so that bottom cell will be an "Add alarm time..." cell
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"AlarmTime"];
    NSInteger rowForIndexPath = [indexPath row];
    
    tableViewCell.backgroundColor = self.defaultBackgroundColor;
    
    if ([tableViewCell isKindOfClass:[AlarmTimeCell class]])
    {
        AlarmTimeCell *alarmCell = (AlarmTimeCell *)tableViewCell;
        alarmCell.cellText.textColor = self.defaultUIColor;
        alarmCell.cellText.font = self.nonFullWidthFloundsButtonAndTVCellFont;
        alarmCell.containingVC = self;
        
        alarmCell.deactivateSnoozeDelegate = self;
        
        NSUInteger numberOfSetAlarms = [[self.alarmClockModel getAlarmTimes] count];

        NSDate *alarmTimeDate = nil;

        if (rowForIndexPath < numberOfSetAlarms + 1)
        {
            alarmTimeDate = [self.alarmClockModel alarmTimeAtIndex:indexPath.row];
            if (alarmTimeDate) //if cell is already populated with an alarm time we set active state based on self.alarmClockModel
            {
                alarmCell.active = [self.alarmClockModel alarmTimeIsActiveAtIndex:indexPath.row];
            }
            else //if cell is an "Add alarm time..." cell, we just set it as active
            {
                alarmCell.active = YES;
            }
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

//override super's implementation
-(void)presentGeneralErrorAlert
{
    if (self.clockTimer.valid)
    {
        [self.clockTimer invalidate];
    }
    [super presentGeneralErrorAlert];
}

#pragma ModalPatternMakerDelegate
-(void)dismissPatternMaker
{
    self.stopUpdatingClocks = NO;
    
    [self deactivateAudioSessionAndStopAlarm];
    
    NSTimeInterval intervalToNextAlarm = [self.alarmClockModel snoozeIntervalForSoundingAlarm];
    if (intervalToNextAlarm > 0.0)
    {        
        self.currSnoozeEndTime = [NSDate dateWithTimeIntervalSinceNow:intervalToNextAlarm];
    }
    
    self.snoozeCount++;
    self.alarmCurrentlySnoozing = YES;
    [self.floundsModel incrementDifficultyAndGetNewSequence];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
