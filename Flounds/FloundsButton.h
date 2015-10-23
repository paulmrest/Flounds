//
//  FloundsButton.h
//  Flounds
//
//  Created by Paul M Rest on 7/11/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloundsViewConstants.h"

#import "DismissContainingVCDelegate.h"

#import "CAAnimationFactory.h"


@interface FloundsButton : UIButton <DismissContainingVCDelegate>

//DismissContinaingVCDelegate property
@property (nonatomic) BOOL dismissContainingVCOnPush;

@property (nonatomic, weak) UIViewController *containingVC;

-(void)animateForPushDismissCurrView;

-(void)animateForPushPerformSegueWithIdentifier:(NSString *)identifer;

-(void)animateForPushActionFailed;

-(void)animateForPushNoSegue;

@end
