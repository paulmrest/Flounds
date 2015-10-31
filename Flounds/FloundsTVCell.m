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
    CABasicAnimation *slideRightAnimation = [CAAnimationFactory slideAnimation];
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
    CABasicAnimation *slideLeftAnimation = [CAAnimationFactory slideAnimation];
    slideLeftAnimation.toValue = [NSNumber numberWithDouble:-self.frame.size.width];
    
    [self.layer addAnimation:slideLeftAnimation forKey:nil];
}

-(void)animateCellForSelectionWithoutSegue
{
    CABasicAnimation *slideRightAnimation = [CAAnimationFactory slideAnimation];
    slideRightAnimation.toValue = [NSNumber numberWithDouble:self.frame.size.width];
//    slideRightAnimation.delegate = self;
    
    [self.layer addAnimation:slideRightAnimation forKey:nil];
}

-(void)animateCellForNonSelectionWithoutSegue
{
    
}

//-(CABasicAnimation *)slideAnimation
//{
//    CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
//    slideAnimation.duration = 0.1f;
//    slideAnimation.fillMode = kCAFillModeForwards;
//    slideAnimation.removedOnCompletion = NO;
//    return slideAnimation;
//}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}

@end
