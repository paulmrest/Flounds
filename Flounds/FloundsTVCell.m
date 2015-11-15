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
    
    [self.layer addAnimation:slideRightAnimation forKey:nil];
}

-(void)setActive:(BOOL)active
{
    _active = active;
}



-(void)drawRect:(CGRect)rect
{
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.contentView];
    
    if (self.active)
    {
        self.cellText.alpha = 1.0f;
        self.layer.opacity = 1.0f;
    }
    else
    {
        self.cellText.alpha = 0.5f;
        self.layer.opacity = 0.5f;
    }
}


@end
