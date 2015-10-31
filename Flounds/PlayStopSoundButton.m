//
//  PlayStopSoundButton.m
//  Flounds
//
//  Created by Paul M Rest on 10/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "PlayStopSoundButton.h"

const CGFloat OUTER_CIRCLE_PADDING_FACTOR = 0.2f;

const CGFloat OUTER_CIRCLE_LINE_WIDTH_FACTOR = 0.05f;

@implementation PlayStopSoundButton

-(void)drawRect:(CGRect)rect
{
    CGFloat smallerAxis = (self.frame.size.width > self.frame.size.height) ?
                           self.frame.size.height : self.frame.size.width;
    CGFloat largerAxis = (self.frame.size.width < self.frame.size.height) ?
                           self.frame.size.height : self.frame.size.width;
    
    CGFloat smallerAxisPadding = smallerAxis * OUTER_CIRCLE_PADDING_FACTOR;
    
    CGFloat paddedBoundingRectSide = smallerAxis - (smallerAxisPadding * 2.0f);

    CGFloat largerAxisPadding = (largerAxis - paddedBoundingRectSide) / 2.0f;
    
    CGRect outerCircleBoundingRect;
    if (self.frame.size.width == smallerAxis)
    {
        outerCircleBoundingRect = CGRectMake(smallerAxisPadding, largerAxisPadding,
                                             paddedBoundingRectSide,
                                             paddedBoundingRectSide);
    }
    else
    {
        outerCircleBoundingRect = CGRectMake(largerAxisPadding, smallerAxisPadding,
                                             paddedBoundingRectSide,
                                             paddedBoundingRectSide);
    }
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:outerCircleBoundingRect];
    
    CGFloat lineWidthAndInnerRectPadding = smallerAxis * OUTER_CIRCLE_LINE_WIDTH_FACTOR;
    circlePath.lineWidth = lineWidthAndInnerRectPadding;
    [[FloundsViewConstants getDefaultTextColor] setStroke];
    [circlePath stroke];
    
    CGRect innerShapeBoundingRect = CGRectMake(outerCircleBoundingRect.origin.x + lineWidthAndInnerRectPadding,
                                               outerCircleBoundingRect.origin.y + lineWidthAndInnerRectPadding,
                                               paddedBoundingRectSide - (2.0f * lineWidthAndInnerRectPadding),
                                               paddedBoundingRectSide - (2.0f * lineWidthAndInnerRectPadding));
    
    if (self.currentlyPlayingSound)
    {
        //draw stop button
    }
    else
    {
        UIBezierPath *playTrianglePath = [[UIBezierPath alloc] init];
        
    }
}

-(NSArray *)pointsForTriangleBoundedBySquareOfSide:(CGFloat)squareSide
{
    NSUInteger triangleVertices = 3;
    NSMutableArray *arrayOfPoints = [[NSMutableArray alloc] initWithCapacity:triangleVertices];
    
    CGFloat rotationPerVertex = (2.0 * M_PI) / triangleVertices;
    
    CGFloat firstPointRadians = 0.0f;
    CGFloat currentPointRadians = firstPointRadians;
    
    for (NSInteger i = 0; i < triangleVertices; i++)
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

@end
