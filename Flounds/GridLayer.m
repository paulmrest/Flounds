//
//  GridLayer.m
//  Flounds
//
//  Created by Paul Rest on 6/2/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "GridLayer.h"

const CGFloat GRID_WIDTH_FACTOR = 0.075;

@interface GridLayer ()

@end


@implementation GridLayer

-(UIBezierPath *)gridPath
{
    if (!_gridPath)
    {
        CGFloat layerWidth = self.frame.size.width;
        CGFloat layerHeight = self.frame.size.height;
        
        //gridWidth will be GRID_WIDTH_FACTOR * whichever is the minor side of the layer
        CGFloat gridWidth = (layerWidth > layerHeight ? layerHeight : layerWidth) * GRID_WIDTH_FACTOR;
        
        _gridPath = [[UIBezierPath alloc] init];
        
        [self drawHorizontalGridLinesForPath:_gridPath
                               withGridWidth:gridWidth
                                inLayerFrame:self.frame];
        
        [self drawVerticalGridLinesForPath:_gridPath
                             withGridWidth:gridWidth
                              inLayerFrame:self.frame];
    }
    return _gridPath;
}

-(void)drawHorizontalGridLinesForPath:(UIBezierPath *)path
                        withGridWidth:(CGFloat)gridWidth
                         inLayerFrame:(CGRect)layerFrame
{
    CGFloat layerWidth = layerFrame.size.width;
    CGFloat layerHeight = layerFrame.size.height;
    NSUInteger numberOfHorzLines = layerHeight / gridWidth;
    //determine how much to offset first line so grid is centered
    CGFloat horzLinesStartingY = gridWidth - ((gridWidth - fmodf(layerHeight, gridWidth)) / 2);
    if (horzLinesStartingY == gridWidth)
    {
        //if layerHeight % gridWith == 0 then last horizontal line will be at the edge of layer; correcting
        numberOfHorzLines--;
    }
    //draw horizontal lines
    CGFloat yCurrDrawingPoint = horzLinesStartingY;
    for (int i = 0; i < numberOfHorzLines; i++)
    {
        [path moveToPoint:CGPointMake(0.0, yCurrDrawingPoint)];
        [path addLineToPoint:CGPointMake(layerWidth, yCurrDrawingPoint)];
        yCurrDrawingPoint += gridWidth;
    }
}

-(void)drawVerticalGridLinesForPath:(UIBezierPath *)path
                      withGridWidth:(CGFloat)gridWidth
                       inLayerFrame:(CGRect)layerFrame
{
    CGFloat layerWidth = layerFrame.size.width;
    CGFloat layerHeight = layerFrame.size.height;
    NSUInteger numberOfVertLines = layerWidth / gridWidth;
    //determine how much to offset first line so grid is centered
    CGFloat vertLinesStartingX = gridWidth - ((gridWidth - fmodf(layerWidth, gridWidth)) / 2);
    if (vertLinesStartingX == gridWidth)
    {
        //if layerWidth % gridWith == 0 then last vertical line will be at the edge of layer; correcting
        numberOfVertLines--;
    }
    //draw vertical lines
    CGFloat xCurrDrawingPoint = vertLinesStartingX;
    for (int i = 0; i < numberOfVertLines; i++)
    {
        [path moveToPoint:CGPointMake(xCurrDrawingPoint, 0.0)];
        [path addLineToPoint:CGPointMake(xCurrDrawingPoint, layerHeight)];
        xCurrDrawingPoint += gridWidth;
    }
}

@end
