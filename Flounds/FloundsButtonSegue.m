//
//  FloundsButtonSegue.m
//  Flounds
//
//  Created by Paul M Rest on 8/4/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "FloundsButtonSegue.h"

@implementation FloundsButtonSegue

-(void)perform
{
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    [sourceViewController.view.superview addSubview:destinationViewController.view];
    
    void (^animationCompletionBlock)(BOOL) = ^void(BOOL finished){
        [self performSelector:@selector(presentViewControllerRemoveSnapShot:)
                   withObject:sourceViewController
                   afterDelay:0.0];
    };
    
    if (self.pressedButton)
    {
        CGPoint originalDestinationVCCenter = destinationViewController.view.center;
        destinationViewController.view.center = self.pressedButton.center;
        destinationViewController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);
        
        destinationViewController.view.alpha = 0.0;
        
        [UIView animateWithDuration:0.4
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             destinationViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                             destinationViewController.view.center = originalDestinationVCCenter;
                             
                             destinationViewController.view.alpha = 1.0f;
                             
                         }
                         completion:animationCompletionBlock];
    }
    else
    {
        
    }
}


-(void)presentViewControllerRemoveSnapShot:(UIViewController *)sourceViewController
{
    [sourceViewController dismissViewControllerAnimated:NO
                                             completion:NULL];
}

@end
