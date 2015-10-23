//
//  DismissContainingVCDelegate.h
//  Flounds
//
//  Created by Paul M Rest on 7/21/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol DismissContainingVCDelegate <NSObject>

@property (nonatomic) BOOL dismissContainingVCOnPush;

@property (nonatomic, weak) UIViewController *containingVC;

@end