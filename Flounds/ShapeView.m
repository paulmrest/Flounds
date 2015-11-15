//
//  ShapeView.m
//  Flounds
//
//  Created by Paul Rest on 5/19/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.


const NSUInteger LAYER_COPIES_FOR_ANIMATION = 3;

#import "ShapeView.h"


@interface ShapeView ()

@property (nonatomic, strong) BezierLayerManager *layerManager;

@property (nonatomic, strong) NSArray *shapeLayersForDisplay;

@property (nonatomic, strong) BezierShapeLayerDelegate *shapeLayerDelegate;

@end


@implementation ShapeView

-(void)setShapesToDisplay:(NSArray *)shapesToDisplay
{
    self.layerManager = [[BezierLayerManager alloc] initWithBezierShapes:shapesToDisplay
                                                     withAnimationCopies:LAYER_COPIES_FOR_ANIMATION];
    self.layerManager.animationQueueFinishDelegate = self;
    
    self.shapeLayersForDisplay = [self.layerManager shapeLayersAndCopiesForDisplay];
}

-(BezierShapeLayerDelegate *)shapeLayerDelegate
{
    if (!_shapeLayerDelegate)
    {
        _shapeLayerDelegate = [[BezierShapeLayerDelegate alloc] init];
    }
    return _shapeLayerDelegate;
}

-(void)drawRect:(CGRect)rect
{
    for (BezierShapeLayer *oneShapeLayer in [self.layerManager shapeLayersAndCopiesForDisplay])
    {
        self.shapeLayerDelegate.strokeColor = oneShapeLayer.strokeColor;
        oneShapeLayer.delegate = self.shapeLayerDelegate;
        [self.layer addSublayer:oneShapeLayer];
    }
}

-(void)presentShapes
{
    for (BezierShapeLayer *oneShapeLayer in [self.layerManager shapeLayersAndCopiesForDisplay])
    {
        [oneShapeLayer setNeedsDisplay];
    }
    
    [self queueMoveShapesTowardsCenterFromEdge];
    [self queuePulseSequenceDisplayForCurrMatchingSequence];
    [self.layerManager startAnimationQueue];
}

-(void)displaySequenceWithPulses:(NSArray *)sequence
{
    [self queuePulseSequenceDisplayFor:sequence];
    [self.layerManager startAnimationQueue];
}

-(void)queuePulseSequenceDisplayForCurrMatchingSequence
{
    [self queuePulseSequenceDisplayFor:self.currMatchingSequence];
}

-(void)queuePulseSequenceDisplayFor:(NSArray *)sequence
{
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:[sequence count]];
    for (NSNumber *oneShapeID in sequence)
    {
        CAAnimationCluster *newPulseAnimationCluster = [CAAnimationFactory pulseInAndOutCAAnimationClusterForShapeID:[oneShapeID integerValue]];
        [animationClusters addObject:newPulseAnimationCluster];
    }
    [self.layerManager queueAnimationClusters:animationClusters
                                 withSequence:sequence
                                timerInterval:0.25];
}

-(void)pulseAllShapesAndDismiss
{
    [self pulseAllShapes];
    [self.patternMakerDelegate dismissPatternMaker];
}

-(void)pulseAllShapes
{
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:[self.layerManager.baseShapeLayers count]];
    for (BezierShapeLayer *oneShapeLayer in self.layerManager.baseShapeLayers)
    {
        [animationClusters addObject:[CAAnimationFactory pulseInAndOutCAAnimationClusterForShapeID:oneShapeLayer.shapeID]];
    }
    [self.layerManager queueAnimationClusters:animationClusters
                                 withSequence:nil
                                timerInterval:0.0];
    [self.layerManager startAnimationQueue];
}

-(void)pulseOneShapeOnly:(NSUInteger)shapeID
{
    [self queueOneShapePulse:shapeID];
    [self.layerManager startAnimationQueue];
}

-(void)queueOneShapePulse:(NSInteger)shapeID
{
    if (shapeID >= 0)
    {
        BezierShapeLayer *baseLayer = [self.layerManager.baseShapeLayers objectAtIndex:shapeID];
        if (baseLayer)
        {
            CAAnimationCluster *newAnimationCluster = [CAAnimationFactory pulseInAndOutCAAnimationClusterForShapeID:shapeID];
            
            [self.layerManager queueAnimationClusters:@[newAnimationCluster]
                                         withSequence:nil
                                        timerInterval:0.0];
        }
    }
}

-(void)shakeAllShapes
{
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:[self.layerManager.baseShapeLayers count]];
    for (BezierShapeLayer *oneBaseShapeLayer in self.layerManager.baseShapeLayers)
    {
        [animationClusters addObject:[CAAnimationFactory shakeShapeAnimationClusterForShapeID:oneBaseShapeLayer.shapeID
                                                                              withDrawingRect:oneBaseShapeLayer.bezierShape.drawingRect
                                                                                    toApplyTo:LAYER_COPIES_FOR_ANIMATION]];
    }
    
    [self.layerManager queueAnimationClusters:animationClusters
                                 withSequence:nil
                                timerInterval:0.0];
    [self.layerManager startAnimationQueue];
}

-(void)bounceAllShapesTowardsPoint:(CGPoint)point
{
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:LAYER_COPIES_FOR_ANIMATION];
    
    for (BezierShapeLayer *oneBaseLayer in self.layerManager.baseShapeLayers)
    {
        CAAnimationCluster *animCluster = [CAAnimationFactory bounceShapeTowardsPoint:point
                                                                       withShapeFrame:oneBaseLayer.frame
                                                                       andShapeBounds:oneBaseLayer.bounds
                                                                      withLayerCopies:LAYER_COPIES_FOR_ANIMATION
                                                                           andShapeID:oneBaseLayer.shapeID];
        [animationClusters addObject:animCluster];
    }
    
    [self.layerManager queueAnimationClusters:animationClusters
                                 withSequence:nil
                                timerInterval:0.0];
    
    [self.layerManager startAnimationQueue];
}

-(void)queueMoveShapesTowardsCenterFromEdge
{
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:[self.layerManager.baseShapeLayers count]];
    for (BezierShapeLayer *oneBaseLayer in self.shapeLayersForDisplay)
    {
        CAAnimation *moveAwayFromCenterAnimation = [CAAnimationFactory animationToMoveShapeConfinedBy:oneBaseLayer.frame
                                                                            alongLineFromEdgeToCenter:self.frame];
        CAAnimationCluster *newAnimationCluster = [[CAAnimationCluster alloc] initWithOneAnimationForCluster:moveAwayFromCenterAnimation
                                                                                              forLayerCopies:LAYER_COPIES_FOR_ANIMATION
                                                                                                  forShapeID:oneBaseLayer.shapeID];
        [animationClusters addObject:newAnimationCluster];
    }
    [self.layerManager queueAnimationClusters:animationClusters
                                 withSequence:nil
                                timerInterval:0.0];    
}

-(void)dismissShapesOnly
{
    [self moveShapesToEdgeAwayFromCenter];
    self.layerManager.removeDelegateSublayersOnAnimationQueueCompletion = YES;
    [self.layerManager startAnimationQueue];
}

-(void)dismissShapesAndPatternMaker
{
    [self moveShapesToEdgeAwayFromCenter];
    self.layerManager.removeDelegateSublayersAndDismissOnAnimationQueueCompletion = YES;
    [self.layerManager startAnimationQueue];
}

-(void)moveShapesToEdgeAwayFromCenter
{
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:[self.layerManager.baseShapeLayers count]];
    for (BezierShapeLayer *oneBaseLayer in self.shapeLayersForDisplay)
    {
        CAAnimation *moveAwayFromCenterAnimation = [CAAnimationFactory animationToMoveShapeConfinedBy:oneBaseLayer.frame
                                                                          alongLineFromCenterToEdgeOf:self.frame];
        CAAnimationCluster *newAnimationCluster = [[CAAnimationCluster alloc] initWithOneAnimationForCluster:moveAwayFromCenterAnimation
                                                                                              forLayerCopies:LAYER_COPIES_FOR_ANIMATION
                                                                                                  forShapeID:oneBaseLayer.shapeID];
        [animationClusters addObject:newAnimationCluster];
    }
    [self.layerManager queueAnimationClusters:animationClusters
                                 withSequence:nil
                                timerInterval:0.0];
}

#pragma AnimationDidFinishQueueDelegate
-(void)removeSublayersOnAnimationQueueCompletion
{
    self.shapeLayersForDisplay = nil;
    self.layer.sublayers = nil;
}

-(void)removeSublayersOnAnimationQueueCompletionAndDismiss
{
    [self removeSublayersOnAnimationQueueCompletion];
    [self.patternMakerDelegate dismissPatternMaker];
}

@end
