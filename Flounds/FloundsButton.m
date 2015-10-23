
//  FloundsButton.m
//  Flounds
//
//  Created by Paul M Rest on 7/11/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "FloundsButton.h"


@interface FloundsButton ()

@end


@implementation FloundsButton

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.dismissContainingVCOnPush = NO;
    }
    return self;
}

-(void)setContainingVC:(UIViewController *)containingVC
{
    if (containingVC)
    {
        self.dismissContainingVCOnPush = YES;
    }
    _containingVC = containingVC;
}

-(void)animateForPushDismissCurrView
{
//    CAAnimation *buttonPulseAnimation = [CAAnimationFactory fastPulseInAndFadeAnimation];
    CAAnimation *buttonPulseAnimation = [CAAnimationFactory fastPulseInAnimation];
    buttonPulseAnimation.fillMode = kCAFillModeForwards;
    buttonPulseAnimation.removedOnCompletion = NO;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (self.dismissContainingVCOnPush)
        {
            [self.containingVC performSegueWithIdentifier:@"FloundsUnwind" sender:self.containingVC];
        }
    }];
    [self.layer addAnimation:buttonPulseAnimation forKey:nil];
    [CATransaction commit];
}

-(void)animateForPushPerformSegueWithIdentifier:(NSString *)identifer
{
    CAAnimation *buttonPulseAnimation = [CAAnimationFactory fastPulseInAnimation];
    buttonPulseAnimation.fillMode = kCAFillModeForwards;
    buttonPulseAnimation.removedOnCompletion = NO;
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (self.dismissContainingVCOnPush)
        {
            [self.containingVC performSegueWithIdentifier:identifer sender:self.containingVC];
        }
    }];
    [self.layer addAnimation:buttonPulseAnimation forKey:nil];
    [CATransaction commit];
}

-(void)animateForPushActionFailed
{
    CAAnimation *buttonShakeAnimation = [CAAnimationFactory shakeAnimationForContainingRect:self.frame];
    
    [self.layer addAnimation:buttonShakeAnimation forKey:nil];
}

-(void)animateForPushNoSegue
{
    [self.layer addAnimation:[CAAnimationFactory fastPulseInThenOutAnimation] forKey:nil];
    [self setNeedsDisplay];
}

@end
