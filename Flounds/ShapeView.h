//
//  ShapeView.h
//  Flounds
//
//  Created by Paul Rest on 5/19/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>

#import "ModalPatternMakerDelegate.h"

#import "BezierLayerManager.h"
#import "BezierShapeLayer.h"
#import "BezierShapeLayerDelegate.h"
#import "CAAnimationCluster.h"
#import "AnimationQueueFinishProtocol.h"

#import "CAAnimationFactory.h"


#define ARC4RANDOM_MAX 0x100000000

@interface ShapeView : UIView <AnimationQueueFinishProtocol>

@property (nonatomic, strong) NSArray *currMatchingSequence;

@property (nonatomic, weak) id<ModalPatternMakerDelegate> patternMakerDelegate;


-(void)setShapesToDisplay:(NSArray *)shapesToDisplay;


-(void)displaySequenceWithPulses:(NSArray *)sequence;

-(void)pulseOneShapeOnly:(NSUInteger)shapeID;

-(void)presentShapes;

-(void)shakeAllShapes;

-(void)bounceAllShapesTowardsPoint:(CGPoint)origin;


-(void)pulseAllShapesAndDismiss;

-(void)pulseAllShapes;


-(void)dismissShapesOnly;

-(void)dismissShapesAndPatternMaker;


@end
