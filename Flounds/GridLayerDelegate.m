//
//  GridLayerDelegate.m
//  Flounds
//
//  Created by Paul Rest on 6/2/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "GridLayerDelegate.h"

@implementation GridLayerDelegate

//-(void)displayLayer:(CALayer *)layer
//{
//    //>>>
//    NSLog(@"GridLayerDelegate - displayLayer...");
//    //<<<
//    UIBezierPath *slashPath = [[UIBezierPath alloc] init];
//    [slashPath moveToPoint:CGPointMake(0.0, 0.0)];
//    [slashPath addLineToPoint:CGPointMake(layer.frame.size.width, layer.frame.size.height)];
//}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    //>>>
    NSLog(@"GridLayerDelegate - drawLayer...");
    //<<<
    if ([layer isKindOfClass:[GridLayer class]])
    {
        GridLayer *gridLayer = (GridLayer *)layer;
        CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextSetLineWidth(ctx, 1.0);
        CGContextAddPath(ctx, gridLayer.gridPath.CGPath);
        CGContextStrokePath(ctx);
    }
}

@end
