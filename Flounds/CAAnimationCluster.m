//
//  CAAnimationCluster.m
//  Flounds
//
//  Created by Paul Rest on 1/22/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "CAAnimationCluster.h"

@implementation CAAnimationCluster

-(id)initWithAnimationCluster:(NSArray *)animationCluster
                   forShapeID:(NSUInteger)shapeID
{
    self = [super init];
    if (self)
    {
        [self setAnimationCluster:animationCluster];
        self.shapeID = shapeID;
        self.timerInterval = 0.0;
    }
    return self;
}

-(id)initWithOneAnimationForCluster:(CAAnimation *)animation
                     forLayerCopies:(NSUInteger)layerCopies
                         forShapeID:(NSUInteger)shapeID
{
    NSMutableArray *animationClusterWithOneAnimation = [[NSMutableArray alloc] initWithCapacity:layerCopies];
    for (NSUInteger i = 0; i < layerCopies; i++)
    {
        [animationClusterWithOneAnimation addObject:animation];
    }
    return [self initWithAnimationCluster:animationClusterWithOneAnimation
                               forShapeID:shapeID];
}

-(void)setAnimationCluster:(NSArray *)animationCluster
{
    for (id oneObject in animationCluster)
    {
        if (![oneObject isKindOfClass:[CAAnimation class]])
        {
            return;
        }
    }
    _animations = animationCluster;
}

@end
