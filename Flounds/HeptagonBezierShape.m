//
//  HeptagonBezierShape.m
//  Flounds
//
//  Created by Paul M Rest on 6/13/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "HeptagonBezierShape.h"

const NSUInteger HEPTAGON_NUMBER_OF_VERTICES = 7;

@implementation HeptagonBezierShape

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    self.path = [self bezierPathForRegularPolygonBoundedBySquareOfSide:squareSide
                                                 withVerticesNumbering:HEPTAGON_NUMBER_OF_VERTICES];
}

@end
