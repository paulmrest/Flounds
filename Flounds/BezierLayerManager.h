//
//  BezierLayerManager.h
//  Flounds
//
//  Created by Paul Rest on 12/28/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "BezierShape.h"
#import "BezierShapeLayer.h"
#import "AnimationQueueFinishDelegate.h"

#import "CAAnimationCluster.h"

NSString *SEGREGATED_LAYER_COPY_ANIMATION;

@interface BezierLayerManager : NSObject

@property (nonatomic, strong, readonly) NSArray *shapeLayersAndCopiesForDisplay;

@property (nonatomic, strong, readonly) NSArray *baseShapeLayers;

@property (nonatomic) NSUInteger layerCopiesNeeded;

@property (nonatomic, weak) id<AnimationQueueFinishDelegate> animationQueueFinishDelegate;

@property (nonatomic) BOOL removeDelegateSublayersOnAnimationQueueCompletion;

@property (nonatomic) BOOL removeDelegateSublayersAndDismissOnAnimationQueueCompletion;


-(id)initWithBezierShapes:(NSArray *)bezierShapes
      withAnimationCopies:(NSUInteger)copiesForAnimation;


-(void)queueAnimationClusters:(NSArray *)animationClusters
                 withSequence:(NSArray *)shapeIDSequence
                timerInterval:(NSTimeInterval)timerInterval;

-(void)queueOneAnimationForAllShapes:(CAAnimation *)animation
                        withSequence:(NSArray *)shapeIDSequence
                       timerInterval:(NSTimeInterval)timerInterval;

-(void)queueAnimation:(CAAnimation *)animation
           forShapeID:(NSUInteger)shapeID;

-(void)directlyAnimateShape:(NSUInteger)shapeID
              withAnimation:(CAAnimation *)animation;

-(void)startAnimationQueue;

@end
