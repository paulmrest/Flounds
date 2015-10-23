//
//  PentagonBezierShape.m
//  Flounds
//
//  Created by Paul Rest on 10/13/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "PentagonBezierShape.h"

const NSUInteger PENTAGON_NUMBER_OF_VERTICES = 5;

@implementation PentagonBezierShape

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    self.path = [self bezierPathForRegularPolygonBoundedBySquareOfSide:squareSide
                                                 withVerticesNumbering:PENTAGON_NUMBER_OF_VERTICES];
}

@end
