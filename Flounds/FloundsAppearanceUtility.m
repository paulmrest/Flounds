//
//  FloundsAppearanceUtility.m
//  Flounds
//
//  Created by Paul M Rest on 10/3/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsAppearanceUtility.h"

@implementation FloundsAppearanceUtility


+(void)addDefaultFloundsSublayerToView:(UIView *)view
{
    [self addFloundsSublayerToView:view
                   withBorderColor:[FloundsViewConstants getDefaultBorderColor]
               withBorderThickness:[FloundsViewConstants getDefaultBorderThickness]];
}


+(void)addFloundsSublayerToView:(UIView *)view
                withBorderColor:(UIColor *)color
{
    [self addFloundsSublayerToView:view
                   withBorderColor:color
               withBorderThickness:[FloundsViewConstants getDefaultBorderThickness]];
}

+(void)addFloundsSublayerToView:(UIView *)view
            withBorderThickness:(CGFloat)thickness
{
    [self addFloundsSublayerToView:view
                   withBorderColor:[FloundsViewConstants getDefaultBorderColor]
               withBorderThickness:thickness];
}

+(void)addFloundsSublayerToView:(UIView *)view
                withBorderColor:(UIColor *)color
            withBorderThickness:(CGFloat)thickness
{
    if ([[view class] isSubclassOfClass:[UIView class]])
    {
        BOOL floundsSublayerPresent = NO;
        for (CALayer *oneLayer in view.layer.sublayers)
        {
            if ([oneLayer isKindOfClass:[FloundsShapeLayer class]])
            {
                floundsSublayerPresent = YES;
            }
        }
        if (!floundsSublayerPresent)
        {
            [view.layer addSublayer:[[FloundsShapeLayer alloc] initWithLayer:view.layer
                                                                 borderColor:color
                                                             borderThickness:thickness]];
        }
    }
}

@end
