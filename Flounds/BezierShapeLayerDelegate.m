//
//  BezierShapeLayerDelegate.m
//  Flounds
//
//  Created by Paul Rest on 5/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

const CGFloat SHAPE_STROKE_LINE_WIDTH_FACTOR = 0.02;

const CGFloat SHAPE_LAYER_EDGE_SPACING_FACTOR = 0.05;

#import "BezierShapeLayerDelegate.h"

@implementation BezierShapeLayerDelegate

//-(void)displayLayer:(CALayer *)layer
//{
//    NSLog(@"displayLayer...");
//}

-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    if ([layer isKindOfClass:[BezierShapeLayer class]])
    {
        BezierShapeLayer *shapeLayer = (BezierShapeLayer *)layer;
        
        CGRect pathDrawingBox = shapeLayer.bezierShape.drawingRect;
        
        CGFloat xTranslation = (shapeLayer.bounds.size.width - pathDrawingBox.size.width) / 2;
        CGFloat yTranslation = (shapeLayer.bounds.size.height - pathDrawingBox.size.width) / 2;
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(xTranslation, yTranslation);
        
        CGPathRef translatedPath = CGPathCreateCopyByTransformingPath(shapeLayer.bezierShape.path.CGPath, &translate);
                
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
        CGContextAddPath(ctx, translatedPath);
        CGContextStrokePath(ctx);
        
        //Draws each shape's shapeID on the shape
        //>>>
//        UIGraphicsPushContext(ctx);
//        NSString *shapeIDString = [NSString stringWithFormat:@"%lu", (unsigned long)shapeLayer.shapeID];
//        
//        NSDictionary *textAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:11.0] forKey:NSFontAttributeName];
//        
//        NSAttributedString *shapeIDAttString = [[NSAttributedString alloc] initWithString:shapeIDString attributes:textAttributes];
//        
//        CGPoint shapeIDDrawPoint = CGPointMake((shapeLayer.bounds.size.width / 2.0f) - (shapeIDAttString.size.width / 2.0f),
//                                               (shapeLayer.bounds.size.height / 2.0f) - (shapeIDAttString.size.height / 2.0f));
//        
//        [shapeIDAttString drawAtPoint:shapeIDDrawPoint];
//        
//        UIGraphicsPopContext();
        
        //<<<
    }
}

-(void)drawLayerTest:(CALayer *)layer inContext:(CGContextRef)ctx
{
    UIBezierPath *finalBezierPath = [[UIBezierPath alloc] init];
    
    UIBezierPath *upperLeftCorner = [[UIBezierPath alloc] init];
    [upperLeftCorner addArcWithCenter:layer.bounds.origin
                               radius:6.0
                           startAngle:0.0
                             endAngle:M_PI / 2
                            clockwise:YES];
    [finalBezierPath appendPath:upperLeftCorner];
    
    UIBezierPath *upperRightCorner = [[UIBezierPath alloc] init];
    [upperRightCorner addArcWithCenter:CGPointMake(layer.bounds.size.width, layer.bounds.origin.y)
                                radius:6.0
                            startAngle:M_PI / 2.0
                              endAngle:M_PI
                             clockwise:YES];
    [finalBezierPath appendPath:upperRightCorner];

    UIBezierPath *lowerRightCorner = [[UIBezierPath alloc] init];
    [lowerRightCorner addArcWithCenter:CGPointMake(layer.bounds.size.width, layer.bounds.size.height)
                                radius:6.0
                            startAngle:M_PI
                              endAngle:3.0/2.0 * M_PI
                             clockwise:YES];
    [finalBezierPath appendPath:lowerRightCorner];
    
    UIBezierPath *lowerLeftCorner = [[UIBezierPath alloc] init];
    [lowerLeftCorner addArcWithCenter:CGPointMake(layer.bounds.origin.x, layer.bounds.size.height)
                               radius:6.0
                           startAngle:3.0/2.0 * M_PI
                             endAngle:2 * M_PI
                            clockwise:YES];
    [finalBezierPath appendPath:lowerLeftCorner];
    
    UIBezierPath *outerRectPath = [UIBezierPath bezierPathWithRect:layer.bounds];
    [finalBezierPath appendPath:outerRectPath];
    
    UIBezierPath *horizontalLine = [[UIBezierPath alloc] init];
    [horizontalLine moveToPoint:CGPointMake(layer.bounds.origin.x, layer.bounds.size.height / 2)];
    [horizontalLine addLineToPoint:CGPointMake(layer.bounds.size.width, layer.bounds.size.height / 2)];
    [finalBezierPath appendPath:horizontalLine];
    
    UIBezierPath *verticalLine = [[UIBezierPath alloc] init];
    [verticalLine moveToPoint:CGPointMake(layer.bounds.size.width / 2, layer.bounds.origin.y)];
    [verticalLine addLineToPoint:CGPointMake(layer.bounds.size.width / 2, layer.bounds.size.height)];
    [finalBezierPath appendPath:verticalLine];

    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextAddPath(ctx, finalBezierPath.CGPath);
    CGContextStrokePath(ctx);

    
    if ([layer isKindOfClass:[BezierShapeLayer class]])
    {
        BezierShapeLayer *shapeLayer = (BezierShapeLayer *)layer;
        
        CGRect pathDrawingBox = shapeLayer.bezierShape.drawingRect;
        
        CGFloat xTranslation = (shapeLayer.bounds.size.width - pathDrawingBox.size.width) / 2;
        CGFloat yTranslation = (shapeLayer.bounds.size.height - pathDrawingBox.size.width) / 2;
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(xTranslation, yTranslation);
        
        CGPathRef translatedPath = CGPathCreateCopyByTransformingPath(shapeLayer.bezierShape.path.CGPath, &translate);
        UIBezierPath *translatedBezierPath = [UIBezierPath bezierPathWithCGPath:translatedPath];
        
        [finalBezierPath appendPath:translatedBezierPath];
        
        CGContextSetLineWidth(ctx, 2.0);
        CGContextSetStrokeColorWithColor(ctx, [UIColor blueColor].CGColor);
        CGContextAddPath(ctx, translatedPath);
        CGContextStrokePath(ctx);
    }
}

@end
