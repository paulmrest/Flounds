//
//  FloundsUserInteractionSegueProtocol.h
//  Flounds
//
//  Created by Paul M Rest on 10/10/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FloundsButton.h"

@protocol FloundsUserInteractionSegueProtocol <NSObject>

@optional

@property (nonatomic, strong) UIViewController *presentingVC;

-(void)removeAnimationsFromPresentingVC;

@end