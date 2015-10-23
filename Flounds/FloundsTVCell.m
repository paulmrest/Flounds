//
//  FloundsTVCell.m
//  Flounds
//
//  Created by Paul M Rest on 9/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsTVCell.h"

@implementation FloundsTVCell

-(void)animateCellForSelectionToPerformSegue:(NSString *)identifier
{
    CABasicAnimation *slideRightAnimation = [self slideAnimation];
    slideRightAnimation.toValue = [NSNumber numberWithDouble:self.frame.size.width];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [self.containingVC performSegueWithIdentifier:identifier sender:self];
    }];
    [self.layer addAnimation:slideRightAnimation forKey:nil];
    [CATransaction commit];
}

-(void)animateCellForNonSelection
{
    CABasicAnimation *slideLeftAnimation = [self slideAnimation];
    slideLeftAnimation.toValue = [NSNumber numberWithDouble:-self.frame.size.width];
    
    [self.layer addAnimation:slideLeftAnimation forKey:nil];
}

-(CABasicAnimation *)slideAnimation
{
    CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    slideAnimation.duration = 0.1f;
    slideAnimation.fillMode = kCAFillModeForwards;
    slideAnimation.removedOnCompletion = NO;
    return slideAnimation;
}

@end
