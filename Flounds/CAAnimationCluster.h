//
//  CAAnimationCluster.h
//  Flounds
//
//  Created by Paul Rest on 1/22/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CAAnimationCluster : NSObject

@property (nonatomic, strong) NSArray *animations;

@property (nonatomic) NSUInteger shapeID;

@property (nonatomic) NSTimeInterval timerInterval;

-(id)initWithAnimationCluster:(NSArray *)animationCluster
                   forShapeID:(NSUInteger)shapeID;

-(id)initWithOneAnimationForCluster:(CAAnimation *)animation
                     forLayerCopies:(NSUInteger)layerCopies
                         forShapeID:(NSUInteger)shapeID;

@end
