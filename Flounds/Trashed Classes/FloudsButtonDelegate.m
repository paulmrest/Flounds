//
//  FloudsButtonDelegate.m
//  Flounds
//
//  Created by Paul M Rest on 7/7/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "FloudsButtonDelegate.h"

@implementation FloudsButtonDelegate

-(void)drawLayer:(CALayer *)layer
       inContext:(CGContextRef)ctx
{
    //>>>
    CGFloat offset = layer.frame.size.width / 10.0f;
    CGRect ovalRect = CGRectMake(layer.frame.origin.x - (offset / 2.0), layer.frame.origin.y - (offset / 2.0),
                                 layer.frame.size.width - offset, layer.frame.size.height - offset);
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    CGContextSetLineWidth(ctx, 1.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    CGContextAddPath(ctx, ovalPath.CGPath);
    CGContextStrokePath(ctx);
    //<<<
}

@end
