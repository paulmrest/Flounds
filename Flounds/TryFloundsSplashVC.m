//
//  TryFloundsSplashVC.m
//  Flounds
//
//  Created by Paul Rest on 2/22/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "TryFloundsSplashVC.h"

static NSString *INITIAL_WELCOME_LABEL;

static NSString *INITIAL_LAUNCH_COUNTDOWN_LABEL;

static NSString *NON_INITIAL_LAUNCH_COUNTDOWN_LABEL;

static NSString *SNOOZE_COUNT_LABEL;

static NSString *TRY_IT_DIFFICULTY_LEVEL_LABEL;

static NSString *TRY_IT_STARTING_SHAPES_LABEL;


@interface TryFloundsSplashVC ()

//@property (nonatomic) BOOL beforeSnooze;

@property (nonatomic) NSUInteger snoozeCount;

@property (nonatomic) NSInteger countdownValue;

@property (nonatomic, strong) NSTimer *countDownTimer;

@end


@implementation TryFloundsSplashVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    //>>>
    NSLog(@"TryItFloundsSplashVC - viewDidLoad");
    //<<<
    
    //>>>
//    self.beforeSnooze = NO;
//    self.snoozeCount = 1;
    //<<<
//    self.beforeSnooze = YES;
    self.snoozeCount = 0;
    self.countdownValue = TIMER_START_VALUE;
    
    [self.tryItFloundsModel getNewStartingSequence];
    
    [self setLabelsText];
}

-(void)setLabelsText
{
    INITIAL_WELCOME_LABEL = NSLocalizedString(@"We are going to try your settings", nil);
    SNOOZE_COUNT_LABEL = NSLocalizedString(@" snooze, next Flounds will have:", nil);
    
    INITIAL_LAUNCH_COUNTDOWN_LABEL = NSLocalizedString(@"Launching in...", nil);
    NON_INITIAL_LAUNCH_COUNTDOWN_LABEL = NSLocalizedString(@"Launching again in...", nil);
    
    TRY_IT_DIFFICULTY_LEVEL_LABEL = NSLocalizedString(@"Difficulty level at: ", nil);
    
    TRY_IT_STARTING_SHAPES_LABEL = NSLocalizedString(@"Shapes in next Flounds: ", nil);
}

-(NSMutableAttributedString *)ordinalAttributedStringForInteger:(NSUInteger)integer
{
    NSMutableAttributedString *returnAttString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%lu", (unsigned long)integer]];
    
    NSString *ordinalString = nil;
    if (integer == 1)
    {
        ordinalString = @"st";
    }
    else if (integer == 2)
    {
        ordinalString = @"nd";
    }
    else if (integer == 3)
    {
        ordinalString = @"rd";
    }
    else
    {
        ordinalString = @"th";
    }
    
    NSDictionary *superScriptAtt = @{(NSString *)kCTSuperscriptAttributeName : [NSNumber numberWithFloat:1.75],
                                     NSFontAttributeName : [UIFont systemFontOfSize:([UIFont systemFontSize] / 1.5)]};
    NSAttributedString *ordinalSuperScript = [[NSAttributedString alloc] initWithString:ordinalString
                                                                             attributes:superScriptAtt];
    
    [returnAttString appendAttributedString:ordinalSuperScript];
    return returnAttString;
}

-(void)viewDidLayoutSubviews
{
    self.cancelButton.containingVC = self;
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.cancelButton];
}

const NSInteger TIMER_START_VALUE = 3;

const NSInteger TIMER_FIRE_VALUE = -1;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //>>>
//    NSLog(@"TryItFloundsSplashVC - viewWillAppear");
    //<<<
    
    //doing setup in viewWillAppear instead of viewWillLayoutSubviews due to bug
    if (self.snoozeCount == 0)
    {
        self.welcomeLabel.text = INITIAL_WELCOME_LABEL;
        self.launchLabel.text = INITIAL_LAUNCH_COUNTDOWN_LABEL;
    }
    else
    {
        NSMutableAttributedString *ordinalAttString = [self ordinalAttributedStringForInteger:self.snoozeCount];
        
        NSAttributedString *snoozeCountAttString = [[NSAttributedString alloc] initWithString:SNOOZE_COUNT_LABEL];
        [ordinalAttString appendAttributedString:snoozeCountAttString];
        
        self.welcomeLabel.attributedText = ordinalAttString;
        
        self.launchLabel.text = NON_INITIAL_LAUNCH_COUNTDOWN_LABEL;
    }
    
    NSString *difficultyLevel = [NSString localizedStringWithFormat:@" %lu", (unsigned long)self.tryItFloundsModel.difficultyLevel];
    self.difficultyLabel.text = [TRY_IT_DIFFICULTY_LEVEL_LABEL stringByAppendingString:difficultyLevel];
    
    NSString *numOfStartingShapes = [NSString localizedStringWithFormat:@" %lu", (unsigned long)self.tryItFloundsModel.currNumberOfShapes];
    self.startingShapesLabel.text = [TRY_IT_STARTING_SHAPES_LABEL stringByAppendingString:numOfStartingShapes];
    
    if (!self.countDownTimer)
    {
        self.countDownLabel.text = [NSString localizedStringWithFormat:@"%ld", (long)self.countdownValue];
        //    self.countDownLabel.text = [NSString stringWithFormat:@"%d", self.countdownValue];
        self.countDownTimer = [NSTimer timerWithTimeInterval:0.9
                                                      target:self
                                                    selector:@selector(updateCountdownDisplayFromTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
    }
    
    [self.view layoutIfNeeded];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    //>>>
//    NSLog(@"TryItFloundsSplashVC - viewDidAppear");
//    //<<<
//}

-(void)updateCountdownDisplayFromTimer:(NSTimer *)timer
{
    //>>>
//    NSLog(@"updateCountdownDisplayFromTimer");
//    NSLog(@"timer address: %p", timer);
    //<<<
    self.countdownValue = self.countdownValue - 1;
    if (self.countdownValue == TIMER_FIRE_VALUE)
    {
        //>>>
//        NSLog(@"updateCountdownDisplayFromTimer - SEGUE!");
        //<<<
        [timer invalidate];
        [self performSegueWithIdentifier:@"TryFlounds" sender:self];
    }
    else if (self.countdownValue >= TIMER_FIRE_VALUE)
    {
        self.countDownLabel.text = [NSString localizedStringWithFormat:@"%ld", (long)self.countdownValue];
//        self.countDownLabel.text = [NSString stringWithFormat:@"%d", self.countdownValue];
        [self.view setNeedsDisplay];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TryFlounds"])
    {
        if ([segue.destinationViewController isKindOfClass:[PatternMakerVC class]])
        {
            PatternMakerVC *tryItPatternMaker = (PatternMakerVC *)segue.destinationViewController;
            tryItPatternMaker.patternMakerDelegate = self;
            tryItPatternMaker.abortAvailable = YES;
            tryItPatternMaker.floundsModel = self.tryItFloundsModel;
        }
    }
}

-(IBAction)cancelButton:(id)sender
{
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    self.tryItFloundsModel = nil;
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsCancelButton = (FloundsButton *)sender;
        self.unwindActivatingButton = floundsCancelButton;
        [floundsCancelButton animateForPushDismissCurrView];
    }
}

#pragma ModalPatternMakerDelegate
-(void)dismissPatternMaker
{
    self.snoozeCount = self.snoozeCount + 1;
    self.countDownTimer = nil;
    self.countdownValue = TIMER_START_VALUE;
    [self.tryItFloundsModel incrementDifficultyAndGetNewSequence];
    [self.view setNeedsDisplay];
//    [self.view layoutIfNeeded];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)dismissPatternMakerFromAbort
{
    [self dismissViewControllerAnimated:YES completion:^(void)
     {
         [self.cancelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
     }];
}

-(void)dismissPatternMakerFromCompletion
{
    
}

@end
