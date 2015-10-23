//
//  SquareBezierShape.m
//  Flounds
//
//  Created by Paul Rest on 10/13/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "SquareBezierShape.h"


const NSUInteger SQUARE_NUMBER_OF_VERTICES = 4;


@implementation SquareBezierShape

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    self.path = [self bezierPathForRegularPolygonBoundedBySquareOfSide:squareSide
                                                 withVerticesNumbering:SQUARE_NUMBER_OF_VERTICES];
    
//    UIBezierPath *squarePath = [[UIBezierPath alloc] init];
//    [squarePath moveToPoint:CGPointMake(0.0, 0.0)];
//    [squarePath addLineToPoint:CGPointMake(squareSide, 0.0)];
//    
//    [squarePath addLineToPoint:CGPointMake(squareSide, squareSide)];
//    
//    [squarePath addLineToPoint:CGPointMake(0.0, squareSide)];
//    
//    [squarePath closePath];
//    self.path = squarePath;
}

@end
