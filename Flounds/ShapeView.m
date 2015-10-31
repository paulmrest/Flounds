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

@property (nonatomic, strong) NSArray *shapeLayers;

//@property (nonatomic, strong) NSDictionary *shapesAndLayers;

@property (nonatomic, strong) BezierShapeLayerDelegate *shapeLayerDelegate;

@end

@implementation ShapeView

-(void)setShapesToDisplay:(NSArray *)shapesToDisplay
{
    self.layerManager = [[BezierLayerManager alloc] initWithBezierShapes:shapesToDisplay
                                                     withAnimationCopies:LAYER_COPIES_FOR_ANIMATION];
    self.layerManager.animationQueueFinishDelegate = self;
    
    self.shapeLayers = [self.layerManager shapeLayersAndCopiesForDisplay];
//    [self presentShapes];
//    [self setNeedsDisplay];
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

const CGFloat SHIFT_SHAPES_TOWARDS_POINT_TRANSFORM_FACTOR = 0.08;

const CGFloat SHIFT_SHAPES_TOWARDS_POINT_DURATION = 0.10;

-(void)bounceAllShapesTowardsPoint:(CGPoint)point
{    
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:LAYER_COPIES_FOR_ANIMATION];
    
    for (BezierShapeLayer *oneBaseLayer in self.layerManager.baseShapeLayers)
    {
        CGFloat xShapeCenter = oneBaseLayer.frame.origin.x + (oneBaseLayer.bounds.size.width / 2);
        CGFloat yShapeCenter = oneBaseLayer.frame.origin.y + (oneBaseLayer.bounds.size.height / 2);
        CGFloat xDistToPoint = point.x - xShapeCenter;
        CGFloat yDistToPoint = point.y - yShapeCenter;
        
        CGFloat xDistToTransform = xDistToPoint * SHIFT_SHAPES_TOWARDS_POINT_TRANSFORM_FACTOR;
        CGFloat yDistToTransform = yDistToPoint * SHIFT_SHAPES_TOWARDS_POINT_TRANSFORM_FACTOR;
        
        CGMutablePathRef pathForAnimation = CGPathCreateMutable();
        CGPathMoveToPoint(pathForAnimation, NULL, xShapeCenter, yShapeCenter);
        CGPathAddLineToPoint(pathForAnimation, NULL, xShapeCenter + xDistToTransform,
                                                     yShapeCenter + yDistToTransform);
        
        CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        positionAnimation.path = pathForAnimation;
        positionAnimation.autoreverses = YES;
        positionAnimation.duration = SHIFT_SHAPES_TOWARDS_POINT_DURATION;
        
        CAAnimationCluster *animCluster = [[CAAnimationCluster alloc] initWithOneAnimationForCluster:positionAnimation
                                                                                      forLayerCopies:LAYER_COPIES_FOR_ANIMATION
                                                                                          forShapeID:oneBaseLayer.shapeID];
        animCluster.timerInterval = 0.0;
        
        [animationClusters addObject:animCluster];
        
        CFRelease(pathForAnimation);
    }
    
    [self.layerManager queueAnimationClusters:animationClusters
                                 withSequence:nil
                                timerInterval:0.0];
    
    [self.layerManager startAnimationQueue];
}

-(void)queueMoveShapesTowardsCenterFromEdge
{
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:[self.layerManager.baseShapeLayers count]];
    for (BezierShapeLayer *oneBaseLayer in self.shapeLayers)
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
    for (BezierShapeLayer *oneBaseLayer in self.shapeLayers)
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
    self.shapeLayers = nil;
    self.layer.sublayers = nil;
}

-(void)removeSublayersOnAnimationQueueCompletionAndDismiss
{
    [self removeSublayersOnAnimationQueueCompletion];
    [self.patternMakerDelegate dismissPatternMaker];
}


//>>>
-(void)animationTester
{
    CABasicAnimation *shiftLeftAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shiftLeftAnimation.toValue = [NSNumber numberWithFloat:-20.0];
    shiftLeftAnimation.duration = 0.50;
    
    CABasicAnimation *shiftRightAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    shiftRightAnimation.toValue = [NSNumber numberWithFloat:20.0];
    shiftRightAnimation.duration = 0.50;
    
    CABasicAnimation *shiftUpAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shiftUpAnimation.toValue = [NSNumber numberWithFloat:-20.0];
    shiftUpAnimation.duration = 0.50;
    
    CAAnimationCluster *shiftThreeAnimationCluster = [[CAAnimationCluster alloc] initWithAnimationCluster:
                                                      @[shiftRightAnimation, shiftUpAnimation, shiftLeftAnimation]
                                                                                               forShapeID:0];
    shiftThreeAnimationCluster.timerInterval = 0.25;
    
    
    
    [self.layerManager queueAnimationClusters:@[shiftThreeAnimationCluster]
                                 withSequence:nil
                                timerInterval:0.0];
    
    [self.layerManager queueOneAnimationForAllShapes:shiftLeftAnimation
                                        withSequence:nil
                                       timerInterval:0.5];
    
    [self.layerManager queueOneAnimationForAllShapes:shiftRightAnimation
                                        withSequence:nil
                                       timerInterval:0.0];
    
    [self.layerManager startAnimationQueue];
}
//<<<

@end
