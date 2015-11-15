//
//  AbortNoticeLabel.h
//  Flounds
//
//  Created by Paul M Rest on 10/29/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CAAnimationFactory.h"

@interface AbortNoticeLabel : UILabel

-(void)animateForSegueWithID:(NSString *)segueID
                  fromSender:(UIViewController *)sender;

@end
