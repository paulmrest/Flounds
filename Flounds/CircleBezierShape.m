//
//  CircleBezierShape.m
//  Flounds
//
//  Created by Paul Rest on 5/17/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "CircleBezierShape.h"

@interface CircleBezierShape ()

//@property (nonatomic, strong, readwrite) UIBezierPath *path;

@end

@implementation CircleBezierShape

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    self.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.0, 0.0, squareSide, squareSide)];
}

@end
