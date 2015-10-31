//
//  CAAnimationFactory.h
//  Flounds
//
//  Created by Paul Rest on 1/25/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "CAAnimationCluster.h"

@interface CAAnimationFactory : NSObject

+(CAAnimationCluster *)pulseInAndOutCAAnimationClusterForShapeID:(NSUInteger)shapeID;

+(CAAnimationCluster *)shakeShapeAnimationClusterForShapeID:(NSUInteger)shapeID
                                            withDrawingRect:(CGRect)rect
                                                  toApplyTo:(NSUInteger)layerCopies;

+(CABasicAnimation *)slideAnimation;

+(CAAnimation *)shakeAnimationForContainingRect:(CGRect)rect;

+(CAAnimation *)pulseAndFadeInAnimation;

+(CAAnimation *)fastPulseInAndFadeAnimation;

+(CAAnimation *)fastPulseInAnimation;

+(CAAnimation *)fastPulseInThenOutAnimation;

+(CAAnimation *)pulseAndFadeOutAnimation;

+(CAAnimation *)animationToMoveShapeConfinedBy:(CGRect)shapeRect
                   alongLineFromCenterToEdgeOf:(CGRect)outerRect;

+(CAAnimation *)animationToMoveShapeConfinedBy:(CGRect)shapeRect
                     alongLineFromEdgeToCenter:(CGRect)outerRect;

@end
