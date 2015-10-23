//
//  FloundsButtonDelegate.m
//  Flounds
//
//  Created by Paul M Rest on 7/8/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "FloundsButtonDelegate.h"

@implementation FloundsButtonDelegate

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    NSLog(@"FloundsButtonDelegate - animationDidStop");
}

@end
