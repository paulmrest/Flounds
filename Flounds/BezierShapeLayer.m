//
//  BezierShapeLayer.m
//  Flounds
//
//  Created by Paul Rest on 5/23/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "BezierShapeLayer.h"

NSString *LAYER_ANIMATION_KEY_KEY = @"layerAnimationKeyKey";

@interface BezierShapeLayer ()

@property (nonatomic, strong) NSArray *layerCopies;

@end


@implementation BezierShapeLayer

-(id)initLayerWithCopyID:(NSUInteger)copyID
{
    return self;
}

+(BezierShapeLayer *)layerWith:(NSUInteger)copies
{
    BezierShapeLayer *baseShapeLayer = [[self class] layer];
    baseShapeLayer.copyID = 0;
    baseShapeLayer.queuedForAnimation = NO;
    baseShapeLayer.layerCopies = [baseShapeLayer generate:copies];
    return baseShapeLayer;
}

-(NSArray *)generate:(NSUInteger)copies
{
    NSMutableArray *buildingCopyArray = [[NSMutableArray alloc] initWithCapacity:copies];
    for (int i = 0; i < copies; i++)
    {
        BezierShapeLayer *oneShapeLayerCopy = [[self class] layer];
        oneShapeLayerCopy.frame = self.frame;
        oneShapeLayerCopy.copyID = i + 1;
        oneShapeLayerCopy.queuedForAnimation = NO;
        [buildingCopyArray addObject:oneShapeLayerCopy];
    }
    return [NSArray arrayWithArray:buildingCopyArray];
}

-(void)setBezierShape:(BezierShape *)bezierShape
{
    if (bezierShape)
    {
        _bezierShape = bezierShape;
        for (BezierShapeLayer *oneShapeLayerCopy in self.layerCopies)
        {
            oneShapeLayerCopy.bezierShape = bezierShape;
        }
    }
}

-(void)setFrame:(CGRect)frame
{
    super.frame = frame;
    for (BezierShapeLayer *oneShapeLayerCopy in self.layerCopies)
    {
        oneShapeLayerCopy.frame = frame;
    }
}

-(void)setUniqueID:(NSUInteger)shapeID
{
    _shapeID = shapeID;
    for (BezierShapeLayer *oneShapeLayerCopy in self.layerCopies)
    {
        oneShapeLayerCopy.shapeID = shapeID;
    }
}

-(void)setDelegate:(id)delegate
{
    super.delegate = delegate;
    for (BezierShapeLayer *oneShapeLayerCopy in self.layerCopies)
    {
        oneShapeLayerCopy.delegate = delegate;
    }
}

-(NSArray *)getAllLayerCopies
{
    return [NSArray arrayWithArray:self.layerCopies];
}

-(NSArray *)getLayerCopiesForAnimation:(NSUInteger)copiesRequested
{
    NSMutableArray *tempBuildArray = [[NSMutableArray alloc] initWithCapacity:copiesRequested];
    for (BezierShapeLayer *oneShapeLayerCopy in self.layerCopies)
    {
        [tempBuildArray addObject:oneShapeLayerCopy];
        if ([tempBuildArray count] == copiesRequested)
        {
            return [NSArray arrayWithArray:tempBuildArray];
        }
    }
    return nil;
}

-(NSArray *)getLayerCopiesForAnimationOLD:(NSUInteger)copiesRequested
{
    NSUInteger availableCopies = 0;
    for (BezierShapeLayer *oneShapeLayerCopy in self.layerCopies)
    {
        if (!oneShapeLayerCopy.queuedForAnimation)
        {
            availableCopies++;
        }
    }
    if (availableCopies >= copiesRequested)
    {
        NSMutableArray *tempBuildArray = [[NSMutableArray alloc] initWithCapacity:copiesRequested];
        for (BezierShapeLayer *oneShapeLayerCopy in self.layerCopies)
        {
            [tempBuildArray addObject:oneShapeLayerCopy];
            if ([tempBuildArray count] == copiesRequested)
            {
                return [NSArray arrayWithArray:tempBuildArray];
            }
        }
    }
    return nil;
}

-(BezierShapeLayer *)getLayerCopyForAnimation
{
    return [[self getLayerCopiesForAnimation:1] lastObject];
}

-(void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
    [anim setValue:self.layerAnimationKey forKey:LAYER_ANIMATION_KEY_KEY];
    [super addAnimation:anim forKey:key];
}

@end
