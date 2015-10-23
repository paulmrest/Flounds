//
//  AnimationQueueFinishDelegate.h
//  Flounds
//
//  Created by Paul Rest on 1/26/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AnimationQueueFinishDelegate <NSObject>

@optional

-(void)currentQueueOfAnimationsCompleted;

-(void)removeSublayersOnAnimationQueueCompletion;

-(void)removeSublayersOnAnimationQueueCompletionAndDismiss;

@end
