//
//  FloundsAppearanceUtility.h
//  Flounds
//
//  Created by Paul M Rest on 10/3/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FloundsViewConstants.h"
#import "FloundsShapeLayer.h"

@interface FloundsAppearanceUtility : NSObject

+(void)addDefaultFloundsSublayerToView:(UIView *)view;

+(void)addFloundsSublayerToView:(UIView *)view
                withBorderColor:(UIColor *)color;

+(void)addFloundsSublayerToView:(UIView *)view
            withBorderThickness:(CGFloat)thickness;

+(void)addFloundsSublayerToView:(UIView *)view
                withBorderColor:(UIColor *)color
            withBorderThickness:(CGFloat)thickness;

@end
