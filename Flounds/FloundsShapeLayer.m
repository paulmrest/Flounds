//
//  FloundsShapeLayer.m
//  Flounds
//
//  Created by Paul M Rest on 10/3/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsShapeLayer.h"


@interface FloundsShapeLayer ()

@end


@implementation FloundsShapeLayer

-(id)initWithLayer:(CALayer *)layer
{
    return [self initWithLayer:layer
                   borderColor:[FloundsViewConstants getDefaultBorderColor]
               borderThickness:[FloundsViewConstants getDefaultBorderThickness]];
}

-(id)initWithLayer:(CALayer *)layer
       borderColor:(UIColor *)color
{
    return [self initWithLayer:layer
                   borderColor:color
               borderThickness:[FloundsViewConstants getDefaultBorderThickness]];
}

-(id)initWithLayer:(CALayer *)layer
   borderThickness:(CGFloat)thickness
{
    return [self initWithLayer:layer
                   borderColor:[FloundsViewConstants getDefaultBorderColor]
               borderThickness:thickness];
}

-(id)initWithLayer:(CALayer *)layer
       borderColor:(UIColor *)color
   borderThickness:(CGFloat)thickness
{
    self = [super initWithLayer:layer];
    if (self)
    {
        if (!color)
        {
            color = [FloundsViewConstants getDefaultBorderColor];
        }
        
        if (thickness <= 0.0f)
        {
            thickness = [FloundsViewConstants getDefaultBorderThickness];
        }
        
        self.backgroundColor = [UIColor clearColor].CGColor;
        self.fillColor = [UIColor clearColor].CGColor;
        
        CGFloat largerAxis = (layer.bounds.size.width < layer.bounds.size.height ? layer.bounds.size.height : layer.bounds.size.width);
        
        CGFloat horizontalAxisOuterRectPadding = layer.bounds.size.width * [FloundsViewConstants getOuterRoundedRectPaddingFactor];
        CGFloat verticalAxisOuterRectPadding = layer.bounds.size.height * [FloundsViewConstants getOuterRoundedRectPaddingFactor];
        
        CGSize outerRoundedRectCornerRadiiSize = CGSizeMake(largerAxis * [FloundsViewConstants getOuterRoundedRectCornerRadiiFactor],
                                                            largerAxis * [FloundsViewConstants getOuterRoundedRectCornerRadiiFactor]);
        
        CGRect outerRoundedRectRect = CGRectMake(layer.bounds.origin.x + (horizontalAxisOuterRectPadding / 2.0),
                                                 layer.bounds.origin.y + (verticalAxisOuterRectPadding / 2.0),
                                                 layer.bounds.size.width - horizontalAxisOuterRectPadding,
                                                 layer.bounds.size.height - verticalAxisOuterRectPadding);
        
        self.path = [UIBezierPath bezierPathWithRoundedRect:outerRoundedRectRect
                                          byRoundingCorners:UIRectCornerAllCorners
                                                cornerRadii:outerRoundedRectCornerRadiiSize].CGPath;
        self.lineWidth = thickness;
        self.strokeColor = color.CGColor;
    }
    return self;
}

@end
