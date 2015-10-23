//
//  EllipseBezierShape.m
//  Flounds
//
//  Created by Paul Rest on 11/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "EllipseBezierShape.h"

@implementation EllipseBezierShape

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    CGFloat ovalIndent = (squareSide / 8) + (float)arc4random_uniform(squareSide / 3);
    
    //initial CGRect will draw a portrait orientation oval, but we will be randomly rotating it
    CGRect newRectWithIndent = CGRectMake(ovalIndent / 2.0, 0.0,
                                          squareSide - ovalIndent, squareSide);
    
    UIBezierPath *unrotatedOvalPath = [UIBezierPath bezierPathWithOvalInRect:newRectWithIndent];
    
    CGPoint boundingRectCenter = CGPointMake(CGRectGetMidX(newRectWithIndent), CGRectGetMidY(newRectWithIndent));
    CGAffineTransform translateAndRotate = CGAffineTransformIdentity;
    translateAndRotate = CGAffineTransformTranslate(translateAndRotate, boundingRectCenter.x, boundingRectCenter.y);
    translateAndRotate = CGAffineTransformRotate(translateAndRotate, ((CGFloat)arc4random() / ARC4RANDOM_MAX) * (2.0 * M_PI));
    translateAndRotate = CGAffineTransformTranslate(translateAndRotate, -boundingRectCenter.x, -boundingRectCenter.y);
    
    UIBezierPath *rotatedOvalPath = [UIBezierPath bezierPathWithCGPath:
                                     CGPathCreateCopyByTransformingPath(unrotatedOvalPath.CGPath, &translateAndRotate)];
    
    //>>>
//    [rotatedOvalPath appendPath:[UIBezierPath bezierPathWithRect:newRectWithIndent]];
    //<<<
    
    self.path = rotatedOvalPath;
}

@end
