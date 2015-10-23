//
//  BezierShapeLayer.h
//  Flounds
//
//  Created by Paul Rest on 5/23/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "BezierShape.h"

NSString *LAYER_ANIMATION_KEY_KEY;

@interface BezierShapeLayer : CALayer

@property (nonatomic, strong) BezierShape *bezierShape;

@property (nonatomic) NSUInteger copyID;

@property (nonatomic) NSUInteger shapeID;

@property (nonatomic, strong) NSString *layerAnimationKey;

@property (nonatomic) BOOL queuedForAnimation;


-(id)initLayerWithCopyID:(NSUInteger)copyID;

+(BezierShapeLayer *)layerWith:(NSUInteger)copies;

-(NSArray *)getAllLayerCopies;

-(NSArray *)getLayerCopiesForAnimation:(NSUInteger)copies;

-(BezierShapeLayer *)getLayerCopyForAnimation;

@end
