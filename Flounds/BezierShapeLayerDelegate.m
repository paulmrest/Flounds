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

-(UIColor *)strokeColor
{
    if (!_strokeColor)
    {
        _strokeColor = [FloundsViewConstants getDefaultShapeStrokeColor];
    }
    return _strokeColor;
}

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
        CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
        CGContextAddPath(ctx, translatedPath);
        CGContextStrokePath(ctx);
        
        CFRelease(translatedPath);
    }
}

@end
