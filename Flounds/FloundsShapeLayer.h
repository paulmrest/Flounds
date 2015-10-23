//
//  FloundsShapeLayer.h
//  Flounds
//
//  Created by Paul M Rest on 10/3/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FloundsViewConstants.h"


@interface FloundsShapeLayer : CAShapeLayer

@property (nonatomic, strong) UIColor *buttonBorderColor;

-(id)initWithLayer:(CALayer *)layer; //inits with black color; do we want to leave this as a default implemenation or have all the client
                                     //classes explicitly request a specific color?

-(id)initWithLayer:(CALayer *)layer
       borderColor:(UIColor *)color;

-(id)initWithLayer:(CALayer *)layer
   borderThickness:(CGFloat)thickness;

-(id)initWithLayer:(CALayer *)layer
       borderColor:(UIColor *)color
   borderThickness:(CGFloat)thickness;

@end
