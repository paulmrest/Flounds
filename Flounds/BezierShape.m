//
//  BezierShape.m
//  Flounds
//
//  Created by Paul Rest on 5/17/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "BezierShape.h"

const double IPHONE_SHAPE_SIZE_RATIO = 0.25;

const double IPAD_SHAPE_SIZE_RATIO = 0.1;

const double SIDE_PADDING_FACTOR = 0.02;

const CGFloat DRAWING_PADDING_FACTOR = 0.05;


@interface BezierShape ()

@end


@implementation BezierShape

-(id)initForRect:(CGRect)rect
{
    self = [super init];
    self.confiningRect = rect;
    [self setupDrawingRect];
    [self drawBezierPathWithinSquareOfSide:self.drawingRect.size.height];
    return self;
}

-(void)setupDrawingRect
{
    CGFloat drawingRectPadding = self.confiningRect.size.width * DRAWING_PADDING_FACTOR;
    self.drawingRect = CGRectMake(self.confiningRect.origin.x + (drawingRectPadding / 2),
                                  self.confiningRect.origin.y + (drawingRectPadding / 2),
                                  self.confiningRect.size.width - drawingRectPadding,
                                  self.confiningRect.size.height - drawingRectPadding);
}

-(void)drawBezierPathWithinSquareOfSide:(CGFloat)squareSide
{
    //abstract
}

-(CGFloat)confiningRadius
{
    double xTriangleLeg = self.confiningRect.size.width / 2.0;
    double yTriangleLeg = self.confiningRect.size.height / 2.0;
    return (CGFloat)sqrt(pow(xTriangleLeg, 2.0) + pow(yTriangleLeg, 2.0));
}

+(CGFloat)confiningRadiusForRect:(CGRect)rect
{
    double xTriangleLeg = rect.size.width / 2.0;
    double yTriangleLeg = rect.size.height / 2.0;
    return (CGFloat)sqrt(pow(xTriangleLeg, 2.0) + pow(yTriangleLeg, 2.0));
}

-(UIBezierPath *)bezierPathForRegularPolygonBoundedBySquareOfSide:(CGFloat)squareSide
                                            withVerticesNumbering:(NSUInteger)vertices
{
    UIBezierPath *newBezierPath = [[UIBezierPath alloc] init];
    NSArray *arrayOfPolygonVertexPointsAsNSValues = [self pointsForPolygonBoundedBySquareOfSide:squareSide
                                                                                           With:vertices];
    for (NSValue *onePointAsNSValue in arrayOfPolygonVertexPointsAsNSValues)
    {
        CGPoint nextPolygonVertex = [onePointAsNSValue CGPointValue];
        if ([arrayOfPolygonVertexPointsAsNSValues indexOfObject:onePointAsNSValue] == 0) //if point is the first
        {
            [newBezierPath moveToPoint:nextPolygonVertex];
        }
        else //if point is subsequent to the first point
        {
            [newBezierPath addLineToPoint:nextPolygonVertex];
        }
    }
    [newBezierPath closePath];
    return newBezierPath;
}

-(NSArray *)pointsForPolygonBoundedBySquareOfSide:(CGFloat)squareSide
                                             With:(NSUInteger)vertices
{
    NSMutableArray *arrayOfPoints = [[NSMutableArray alloc] initWithCapacity:vertices];
    
    CGFloat rotationPerVertex = (2.0 * M_PI) / vertices;
    
    CGFloat firstPointRadians = ((CGFloat)arc4random() / ARC4RANDOM_MAX) * (2.0 * M_PI);
    CGFloat currentPointRadians = firstPointRadians;
    
    for (NSInteger i = 0; i < vertices; i++)
    {
        CGPoint nextPoint = [self pointOnCircleWithinSquareOfSide:squareSide atRadian:currentPointRadians];
        [arrayOfPoints addObject:[NSValue valueWithCGPoint:nextPoint]];
        
        currentPointRadians = currentPointRadians + rotationPerVertex;
    }
    
    return [NSArray arrayWithArray:arrayOfPoints];
}

-(CGPoint)pointOnCircleWithinSquareOfSide:(CGFloat)squareSide
                                 atRadian:(CGFloat)radian
{
    CGFloat xCircleCenter = squareSide / 2;
    CGFloat yCircleCenter = squareSide / 2;
    CGFloat circleRadius = squareSide / 2;
    
    CGFloat xPointOnCircleAtRaidan = xCircleCenter + (circleRadius * cosf(radian));
    CGFloat yPointOnCircleAtRadian = yCircleCenter + (circleRadius * sinf(radian));
    
    return CGPointMake(xPointOnCircleAtRaidan, yPointOnCircleAtRadian);
}

//-(CGPoint)pointOnCircleWithin:(CGRect)rect
//                     atRadian:(CGFloat)radian
//{
//    CGFloat xCircleCenter = rect.origin.x + rect.size.width / 2;
//    CGFloat yCircleCenter = rect.origin.y + rect.size.height / 2;
//    
//    CGFloat radius = rect.size.width / 2;
//    
//    CGFloat xPointOnCircleAtRadian = xCircleCenter + (radius * cosf(radian));
//    CGFloat yPointOnCircleAtRadian = yCircleCenter + (radius * sinf(radian));
//    
//    return CGPointMake(xPointOnCircleAtRadian, yPointOnCircleAtRadian);
//}

#pragma NSCopying

-(id)copyWithZone:(NSZone *)zone
{
    id copyOfSelf = [[[self class] alloc] init];
    if (copyOfSelf)
    {
        [copyOfSelf setPath:[self.path copyWithZone:zone]];
        [copyOfSelf setStrokeColor:[self.strokeColor copyWithZone:zone]];
        [copyOfSelf setBackgroundColor:[self.backgroundColor copyWithZone:zone]];
        
        [copyOfSelf setConfiningRect:self.confiningRect];
        [copyOfSelf setShapeID:self.shapeID];
    }
    return copyOfSelf;
}

@end
