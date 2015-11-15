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

static NSString *CANCEL_BUTTON_TEXT;


const CGFloat COUNT_DOWN_TEXT_VIEW_FONT_SIZE_FACTOR = 0.33;

const CGFloat ORDINAL_FONT_REDUCTION_FACTOR = 0.66f;

const CGFloat ORDINAL_FONT_SUPERSCRIPT_FACTOR = 1.75f;


@interface TryFloundsSplashVC ()

//@property (nonatomic) BOOL beforeSnooze;

@property (nonatomic) NSUInteger snoozeCount;

@property (nonatomic) NSInteger countdownValue;

@property (nonatomic, strong) NSTimer *countDownTimer;

@end


@implementation TryFloundsSplashVC

const NSInteger TIMER_START_VALUE = 5;

const NSInteger TIMER_FIRE_VALUE = -1;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.snoozeCount = 0;
    self.countdownValue = TIMER_START_VALUE;
    
    [self.tryItFloundsModel getNewStartingSequence];
    
    [self setLabelsColor:self.defaultUIColor];
    [self setLabelsFont:self.labelFont];
    
    [self calcCountDownLabelFont];
    
    [self setLabelsText];
    
    self.cancelButton.titleLabel.font = self.nonFullWidthFloundsButtonAndTVCellFont;
}

-(void)viewDidLayoutSubviews
{
    self.cancelButton.containingVC = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
        self.countDownTimer = [NSTimer timerWithTimeInterval:0.9
                                                      target:self
                                                    selector:@selector(updateCountdownDisplayFromTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSDefaultRunLoopMode];
    }
    
    self.cancelButton.titleLabel.text = CANCEL_BUTTON_TEXT;
    
    [self.view layoutIfNeeded];
}

-(void)setLabelsText
{
    INITIAL_WELCOME_LABEL = NSLocalizedString(@"Trying your settings", nil);
    SNOOZE_COUNT_LABEL = NSLocalizedString(@" Snooze", nil);
    
    INITIAL_LAUNCH_COUNTDOWN_LABEL = NSLocalizedString(@"Launching in...", nil);
    NON_INITIAL_LAUNCH_COUNTDOWN_LABEL = NSLocalizedString(@"Launching again in...", nil);
    
    TRY_IT_DIFFICULTY_LEVEL_LABEL = NSLocalizedString(@"Difficulty level: ", nil);
    
    TRY_IT_STARTING_SHAPES_LABEL = NSLocalizedString(@"Shapes in next Flounds: ", nil);
    
    CANCEL_BUTTON_TEXT = NSLocalizedString(@"Enough", nil);
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
    
    UIFont *superScriptFont = [UIFont fontWithName:[FloundsViewConstants getDefaultFontFamilyName]
                                              size:(self.labelFont.pointSize * ORDINAL_FONT_REDUCTION_FACTOR)];
    
    NSDictionary *superScriptAtt = @{(NSString *)kCTSuperscriptAttributeName : [NSNumber numberWithFloat:ORDINAL_FONT_SUPERSCRIPT_FACTOR],
                                    NSFontAttributeName : superScriptFont};
    
    NSAttributedString *ordinalSuperScript = [[NSAttributedString alloc] initWithString:ordinalString
                                                                             attributes:superScriptAtt];
    
    [returnAttString appendAttributedString:ordinalSuperScript];
    return returnAttString;
}

-(void)setLabelsColor:(UIColor *)labelColor
{
    self.welcomeLabel.textColor = labelColor;
    self.difficultyLabel.textColor = labelColor;
    self.startingShapesLabel.textColor = labelColor;
    self.launchLabel.textColor = labelColor;
    self.countDownLabel.textColor = labelColor;
}

-(void)setLabelsFont:(UIFont *)labelFont
{
    self.welcomeLabel.font = labelFont;
    self.difficultyLabel.font = labelFont;
    self.startingShapesLabel.font = labelFont;
    self.launchLabel.font = labelFont;
}

-(void)calcCountDownLabelFont
{
    CGFloat countDownLabelFontPointSize = self.view.frame.size.width * COUNT_DOWN_TEXT_VIEW_FONT_SIZE_FACTOR;
    self.countDownLabel.font = [UIFont fontWithName:[FloundsViewConstants getDefaultFontFamilyName]
                                               size:countDownLabelFontPointSize];
}

-(void)updateCountdownDisplayFromTimer:(NSTimer *)timer
{
    self.countdownValue = self.countdownValue - 1;
    if (self.countdownValue == TIMER_FIRE_VALUE)
    {
        [timer invalidate];
        if (self.snoozeCount == 0)
        {
            [self performSegueWithIdentifier:@"AbortNotice" sender:self];
        }
        else
        {
            [self performSegueWithIdentifier:@"TryFlounds" sender:self];
        }
    }
    else if (self.countdownValue >= TIMER_FIRE_VALUE)
    {
        self.countDownLabel.text = [NSString localizedStringWithFormat:@"%ld", (long)self.countdownValue];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.snoozeCount == 0)
    {
        if ([segue.identifier isEqualToString:@"AbortNotice"])
        {
            if ([segue.destinationViewController isKindOfClass:[AbortNoticeVC class]])
            {
                AbortNoticeVC *abortNoticeVC = (AbortNoticeVC *)segue.destinationViewController;
                abortNoticeVC.tryItFloundsModel = self.tryItFloundsModel;
                abortNoticeVC.patternMakerDelegate = self;
            }
        }
    }
    else
    {
        if ([segue.identifier isEqualToString:@"TryFlounds"])
        {
            if ([segue.destinationViewController isKindOfClass:[PatternMakerVC class]])
            {
                PatternMakerVC *tryItPatternMaker = (PatternMakerVC *)segue.destinationViewController;
                tryItPatternMaker.floundsModel = self.tryItFloundsModel;
                tryItPatternMaker.patternMakerDelegate = self;
                tryItPatternMaker.abortAvailable = YES;
            }
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
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)dismissPatternMakerFromAbort
{
    [self dismissViewControllerAnimated:YES completion:^(void)
     {
         [self.cancelButton sendActionsForControlEvents:UIControlEventTouchUpInside];
     }];
}

@end
