//
//  VerticallyCenteredTextView.h
//  Flounds
//
//  Created by Paul M Rest on 10/7/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloundsViewConstants.h"

#import "CAAnimationFactory.h"
#import "FloundsUserInteractionSegueProtocol.h"

@interface VerticallyCenteredTextView : UIView

@property (nonatomic, strong) NSString *displayText;

@property (nonatomic, strong) UIFont *displayFont;

@property (nonatomic, strong) UIColor *fontColor; //defaults to black if not otherwise set

@property (nonatomic) BOOL centerTextOnEachRedrawCycle;

@property (nonatomic, strong) UIViewController<FloundsUserInteractionSegueProtocol> *containingVC;

-(void)animateForSegueWithID:(NSString *)segueID
                  fromSender:(id)sender;

@end
