//
//  BezierShape.h
//  Flounds
//
//  Created by Paul Rest on 5/17/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ARC4RANDOM_MAX 0x100000000

const double IPHONE_SHAPE_SIZE_RATIO;

const double IPAD_SHAPE_SIZE_RATIO;

const double SIDE_PADDING_FACTOR;

const CGFloat DRAWING_PADDING_FACTOR;


@interface BezierShape : NSObject <NSCopying>

@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) UIColor *strokeColor;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic) CGRect confiningRect;

@property (nonatomic) CGRect drawingRect;

@property (nonatomic) NSUInteger shapeID;


-(id)initForRect:(CGRect)rect;

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide;

-(CGFloat)confiningRadius;

+(CGFloat)confiningRadiusForRect:(CGRect)rect;

-(UIBezierPath *)bezierPathForRegularPolygonBoundedBySquareOfSide:(CGFloat)squareSide
                                            withVerticesNumbering:(NSUInteger)vertices;


@end
