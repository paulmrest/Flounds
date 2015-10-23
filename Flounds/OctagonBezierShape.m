//
//  OctagonBezierShape.m
//  Flounds
//
//  Created by Paul M Rest on 6/13/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "OctagonBezierShape.h"

const NSUInteger OCTAGON_NUMBER_OF_VERTICES = 8;

@implementation OctagonBezierShape

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    self.path = [self bezierPathForRegularPolygonBoundedBySquareOfSide:squareSide
                                                 withVerticesNumbering:OCTAGON_NUMBER_OF_VERTICES];
}

@end
