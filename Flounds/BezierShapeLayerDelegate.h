//
//  BezierShapeLayerDelegate.h
//  Flounds
//
//  Created by Paul Rest on 5/24/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import "FloundsViewConstants.h"

#import "BezierShapeLayer.h"
#import "BezierShape.h"

@interface BezierShapeLayerDelegate : NSObject

@property (nonatomic, strong) UIColor *strokeColor;

@end
