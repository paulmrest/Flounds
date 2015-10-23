//
//  FloundsButtonUnwindProtocol.h
//  Flounds
//
//  Created by Paul M Rest on 8/23/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FloundsButton.h"

@protocol FloundsButtonUnwindProtocol <NSObject>

@property (nonatomic, strong) FloundsButton *unwindActivatingButton;

@end