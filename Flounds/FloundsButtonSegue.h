//
//  FloundsButtonSegue.h
//  Flounds
//
//  Created by Paul M Rest on 8/4/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "FloundsButton.h"
#import "FloundsButtonUnwindProtocol.h"
#import "FloundsVCBase.h"

@interface FloundsButtonSegue : UIStoryboardSegue

@property (nonatomic, strong) FloundsButton *pressedButton;

@end
