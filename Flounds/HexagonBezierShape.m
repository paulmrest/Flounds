//
//  HexagonBezierShape.m
//  Flounds
//
//  Created by Paul M Rest on 6/13/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "HexagonBezierShape.h"

const NSUInteger HEXAGON_NUMBER_OF_VERTICES = 6;

@implementation HexagonBezierShape

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    self.path = [self bezierPathForRegularPolygonBoundedBySquareOfSide:squareSide
                                                 withVerticesNumbering:HEXAGON_NUMBER_OF_VERTICES];
}

@end
