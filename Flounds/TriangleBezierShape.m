//
//  TriangleBezierShape.m
//  Flounds
//
//  Created by Paul Rest on 10/13/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "TriangleBezierShape.h"


const NSUInteger TRIANGLE_NUMBER_OF_VERTICES = 3;


@implementation TriangleBezierShape

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    self.path = [self bezierPathForRegularPolygonBoundedBySquareOfSide:squareSide
                                                 withVerticesNumbering:TRIANGLE_NUMBER_OF_VERTICES];
}

@end
