//
//  AbortNoticeVC.m
//  Flounds
//
//  Created by Paul M Rest on 10/28/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "AbortNoticeVC.h"

NSString *ABORT_NOTICE_TEXT;

@interface AbortNoticeVC ()

@end

@implementation AbortNoticeVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    ABORT_NOTICE_TEXT = NSLocalizedString(@"Tap any shape three times to abort", nil);
}

-(void)viewDidLayoutSubviews
{
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.abortNoticeLabel];
    
    self.abortNoticeLabel.textColor = [FloundsViewConstants getDefaultTextColor];
    self.abortNoticeLabel.text = ABORT_NOTICE_TEXT;
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.okayButton];
    self.okayButton.containingVC = self;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TryItFromAbortNotice"])
    {
        if ([segue.destinationViewController isKindOfClass:[PatternMakerVC class]])
        {
            PatternMakerVC *patternMakerVC = (PatternMakerVC *)segue.destinationViewController;
            
            patternMakerVC.floundsModel = self.tryItFloundsModel;
            patternMakerVC.patternMakerDelegate = self;
            patternMakerVC.abortAvailable = YES;
            
            patternMakerVC.presentingVC = self;
        }
    }
}

-(void)removeAnimationsFromPresentingVC
{
    [self.okayButton.layer removeAllAnimations];
}

-(IBAction)okayButtonPushed:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *okayFloundsButton = (FloundsButton *)sender;
        [okayFloundsButton animateForPushPerformSegueWithIdentifier:@"TryItFromAbortNotice"];
    }
}

-(void)dismissPatternMaker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self.patternMakerDelegate dismissPatternMaker];
}

@end
