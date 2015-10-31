//
//  CAAnimationFactory.m
//  Flounds
//
//  Created by Paul Rest on 1/25/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "CAAnimationFactory.h"

@implementation CAAnimationFactory

+(CABasicAnimation *)slideAnimation
{
    CABasicAnimation *slideAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    slideAnimation.duration = 0.1f;
    slideAnimation.fillMode = kCAFillModeForwards;
    slideAnimation.removedOnCompletion = NO;
    return slideAnimation;
}

CFTimeInterval pulseAndFadeAnimationDuration = 0.5f;

+(CAAnimation *)pulseAndFadeInAnimation
{
    CABasicAnimation *pulseInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseInAnimation.toValue = [NSNumber numberWithFloat:0.01f];
    
    CAAnimationGroup *pulseAndFadeIn = [CAAnimationGroup animation];
    pulseAndFadeIn.animations = @[pulseInAnimation, [CAAnimationFactory fadeAnimation]];
    pulseAndFadeIn.duration = pulseAndFadeAnimationDuration;
    
    return pulseAndFadeIn;
}

CFTimeInterval fastPulseAndFadeAnimationDuration = 0.15f;

+(CAAnimation *)fastPulseInAndFadeAnimation
{
    CABasicAnimation *fastPulseInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    fastPulseInAnimation.toValue = [NSNumber numberWithFloat:0.01f];
    
    CAAnimationGroup *fastPulseAndFadeIn = [CAAnimationGroup animation];
    fastPulseAndFadeIn.animations = @[fastPulseInAnimation, [CAAnimationFactory fadeAnimation]];
    fastPulseAndFadeIn.duration = fastPulseAndFadeAnimationDuration;
    
    return fastPulseAndFadeIn;
}

+(CAAnimation *)fastPulseInAnimation
{
    CABasicAnimation *fastPulseInAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    fastPulseInAnimation.toValue = [NSNumber numberWithFloat:0.01f];
    fastPulseInAnimation.duration = fastPulseAndFadeAnimationDuration;
    
    return fastPulseInAnimation;
}

+(CAAnimation *)fastPulseInThenOutAnimation
{
    CAAnimation *fastPulseInThenOutAnimation = [CAAnimationFactory fastPulseInAnimation];
    fastPulseInThenOutAnimation.autoreverses = YES;
    
    return fastPulseInThenOutAnimation;
}

+(CAAnimation *)pulseAndFadeOutAnimation
{
    CABasicAnimation *pulseOutAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseOutAnimation.toValue = [NSNumber numberWithFloat:1.25f];
    
    CAAnimationGroup *pulseAndFadeOut = [CAAnimationGroup animation];
    pulseAndFadeOut.animations = @[pulseOutAnimation, [CAAnimationFactory fadeAnimation]];
    pulseAndFadeOut.duration = pulseAndFadeAnimationDuration;

    return pulseAndFadeOut;
}

const CGFloat PULSE_ANIMATION_FADE_TO_VALUE = 0.5f;

+(CAAnimation *)fadeAnimation
{
    CABasicAnimation *fadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnimation.toValue = [NSNumber numberWithFloat:PULSE_ANIMATION_FADE_TO_VALUE];
    
    return fadeAnimation;
}

+(CAAnimationCluster *)pulseInAndOutCAAnimationClusterForShapeID:(NSUInteger)shapeID;
{
    NSArray *pulseInAndOutArray = @[[CAAnimationFactory pulseAndFadeInAnimation], [CAAnimationFactory pulseAndFadeOutAnimation]];
    
    return [[CAAnimationCluster alloc] initWithAnimationCluster:pulseInAndOutArray
                                                     forShapeID:shapeID];
}


const CGFloat SHAKE_TRANSLATION_FACTOR = 0.05;

+(CAAnimation *)shakeAnimationForContainingRect:(CGRect)rect
{
    CGFloat minorAxisLength = (rect.size.width > rect.size.height ? rect.size.height : rect.size.width);
    CGFloat shakeTranslationAmount = minorAxisLength * SHAKE_TRANSLATION_FACTOR;
    
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-shakeTranslationAmount, 0.0, 0.0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(shakeTranslationAmount, 0.0, 0.0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0, shakeTranslationAmount, 0.0)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0.0, -shakeTranslationAmount, 0.0)]];
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = 2.0;
    shakeAnimation.duration = 0.1;
    
    return shakeAnimation;
}

+(CAAnimationCluster *)shakeShapeAnimationClusterForShapeID:(NSUInteger)shapeID
                                            withDrawingRect:(CGRect)rect
                                                  toApplyTo:(NSUInteger)layerCopies
{
    CAAnimation *shakeAnimation = [CAAnimationFactory shakeAnimationForContainingRect:rect];
    return [[CAAnimationCluster alloc] initWithOneAnimationForCluster:shakeAnimation
                                                       forLayerCopies:layerCopies
                                                           forShapeID:shapeID];
}

const CFTimeInterval MOVE_TO_OR_AWAY_FROM_EDGES_ANIMATION_DURATION = 0.5f;

const CGFloat MOVE_TO_OR_AWAY_FROM_EDGES_FADE_ANIMATION_EDGE_VALUE = 0.2f;

const CGFloat MOVE_TO_OR_AWAY_FORM_EDGES_SCALE_ANIMATION_EDGE_VALUE = 0.1f;

+(CAAnimation *)animationToMoveShapeConfinedBy:(CGRect)shapeRect
                   alongLineFromCenterToEdgeOf:(CGRect)outerRect
{
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.toValue = [NSNumber numberWithFloat:MOVE_TO_OR_AWAY_FROM_EDGES_FADE_ANIMATION_EDGE_VALUE];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:MOVE_TO_OR_AWAY_FORM_EDGES_SCALE_ANIMATION_EDGE_VALUE];
    
    CGPoint pointOnFrameToTranslateTowards = [CAAnimationFactory
                                              calculatePointOnOuterFrame:outerRect
                                              forALineThatPassesThroughCenterOfOuterFrameAndInnerFrame:shapeRect];
    
    CGMutablePathRef pathForTranslation = CGPathCreateMutable();
    CGPathMoveToPoint(pathForTranslation, NULL, shapeRect.origin.x + (shapeRect.size.width / 2.0),
                      shapeRect.origin.y + (shapeRect.size.height / 2.0));
    CGPathAddLineToPoint(pathForTranslation, NULL,
                         pointOnFrameToTranslateTowards.x,
                         pointOnFrameToTranslateTowards.y);
    CAKeyframeAnimation *translationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    translationAnimation.path = pathForTranslation;
    translationAnimation.autoreverses = YES;
    
    CAAnimationGroup *moveShapesToEdgeAnimationGroup = [CAAnimationGroup animation];
    moveShapesToEdgeAnimationGroup.animations = @[fadeOutAnimation, scaleAnimation, translationAnimation];
    moveShapesToEdgeAnimationGroup.duration = MOVE_TO_OR_AWAY_FROM_EDGES_ANIMATION_DURATION;
    moveShapesToEdgeAnimationGroup.fillMode = kCAFillModeForwards;
    moveShapesToEdgeAnimationGroup.removedOnCompletion = NO;
    
    CFRelease(pathForTranslation);
    
    return moveShapesToEdgeAnimationGroup;
}

+(CAAnimation *)animationToMoveShapeConfinedBy:(CGRect)shapeRect
                     alongLineFromEdgeToCenter:(CGRect)outerRect
{
    NSNumber *fadeAnScaleToValue = [NSNumber numberWithFloat:1.0f];
    
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.fromValue = [NSNumber numberWithFloat:MOVE_TO_OR_AWAY_FROM_EDGES_FADE_ANIMATION_EDGE_VALUE];
    fadeInAnimation.toValue = fadeAnScaleToValue;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:MOVE_TO_OR_AWAY_FORM_EDGES_SCALE_ANIMATION_EDGE_VALUE];
    scaleAnimation.toValue = fadeAnScaleToValue;
    
    CGPoint pointOnFrameToTranslateAwayFrom = [CAAnimationFactory
                                               calculatePointOnOuterFrame:outerRect forALineThatPassesThroughCenterOfOuterFrameAndInnerFrame:shapeRect];
    CGMutablePathRef pathForTranslation = CGPathCreateMutable();
    CGPathMoveToPoint(pathForTranslation, NULL, pointOnFrameToTranslateAwayFrom.x, pointOnFrameToTranslateAwayFrom.y);
    CGPathAddLineToPoint(pathForTranslation, NULL,
                         shapeRect.origin.x + (shapeRect.size.width / 2.0),
                         shapeRect.origin.y + (shapeRect.size.height / 2.0));
    
    CAKeyframeAnimation *translationAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    translationAnimation.path = pathForTranslation;
    translationAnimation.autoreverses = NO;
    
    CAAnimationGroup *moveShapesAwayFromEdgeAnimationGroup = [CAAnimationGroup animation];
    moveShapesAwayFromEdgeAnimationGroup.animations = @[fadeInAnimation, scaleAnimation, translationAnimation];
    moveShapesAwayFromEdgeAnimationGroup.duration = MOVE_TO_OR_AWAY_FROM_EDGES_ANIMATION_DURATION;
    moveShapesAwayFromEdgeAnimationGroup.fillMode = kCAFillModeForwards;
    moveShapesAwayFromEdgeAnimationGroup.removedOnCompletion = YES;
    
    CFRelease(pathForTranslation);
    
    return moveShapesAwayFromEdgeAnimationGroup;
}

                    +(CGPoint)calculatePointOnOuterFrame:(CGRect)outerFrame
forALineThatPassesThroughCenterOfOuterFrameAndInnerFrame:(CGRect)innerFrame
{
    CGPoint centerOfOuterFrame = CGPointMake(outerFrame.origin.x + (outerFrame.size.width / 2),
                                            outerFrame.origin.y + (outerFrame.size.height / 2));
    CGPoint centerOfInnerFrame = CGPointMake(innerFrame.origin.x + (innerFrame.size.width / 2.0),
                                             innerFrame.origin.y + (innerFrame.size.height / 2.0));
    
    CGFloat yDistBetweenCenters = centerOfOuterFrame.y - centerOfInnerFrame.y;
    CGFloat xDistBetweenCenters = centerOfOuterFrame.x - centerOfInnerFrame.x;
    
    
    CGFloat lineSlope = 0.0f;
    if (xDistBetweenCenters == 0.0 && yDistBetweenCenters == 0.0) //if innerFrame is centered exactly on outerFrame, pick a random slope value between -20.0 and 20.0
    {
        CGFloat unSignedSlope = (float)arc4random_uniform(20);
        NSUInteger makeSlopeNegative = arc4random_uniform(2);
        lineSlope = (makeSlopeNegative == 0 ? unSignedSlope : -unSignedSlope);
    }
    else if (xDistBetweenCenters == 0.0)
    {
        lineSlope = CGFLOAT_MAX; //lineSlope is undefined; approximately infinity
    }
    else
    {
        lineSlope = yDistBetweenCenters / xDistBetweenCenters;
    }
    
    if (lineSlope == CGFLOAT_MAX)
    {
        CGFloat xValue = centerOfOuterFrame.x;
        if (yDistBetweenCenters >= 0.0) //center of innerFrame has a lower y value than center of outerFrame
        {
            return CGPointMake(xValue, 0.0);
        }
        else //center of innerFrame has a greater y value than center of outerFrame
        {
            return CGPointMake(xValue, outerFrame.size.height);
        }
    }
    if (fabs(lineSlope) == 1.0)
    {
        CGFloat yValue = centerOfOuterFrame.y;
        if (xDistBetweenCenters >= 0.0)
        {
            return CGPointMake(0.0, yValue);
        }
        else
        {
            return CGPointMake(outerFrame.size.width, 0.0);
        }
    }
    else
    {
        CGFloat xValue = xDistBetweenCenters > 0.0 ? 0.0 : outerFrame.size.width;
        CGFloat yValue;
        
        CGFloat yValueWithExtremeX = lineSlope * (xValue - centerOfInnerFrame.x) + centerOfInnerFrame.y;
        if (yValueWithExtremeX < 0.0)
        {
            yValue = 0.0;
        }
        else if (yValueWithExtremeX > outerFrame.size.height)
        {
            yValue = outerFrame.size.height;
        }
        else
        {
            yValue = yValueWithExtremeX;
        }
        return CGPointMake(xValue, yValue);
    }
    return CGPointZero;
}

@end
