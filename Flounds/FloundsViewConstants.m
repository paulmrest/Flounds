//
//  FloundsViewConstants.m
//  Flounds
//
//  Created by Paul M Rest on 9/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsViewConstants.h"

const CGFloat OUTER_ROUNDED_RECT_PADDING_FACTOR = 20.0f;

const CGFloat OUTER_ROUNDED_RECT_CORNER_RADII_FACTOR = 4.0f;

const CGFloat FRAME_PADDING_FACTOR = 0.25f;

NSString *DEFAULT_FONT_NAME = @"Kailasa";

const CGFloat DEFAULT_FONT_SIZE = 16.0F;


const CGFloat DEFAULT_BORDER_THICKNESS = 2.0f;


@interface FloundsViewConstants ()

@end


@implementation FloundsViewConstants

+(CGFloat)getOuterRoundedRectPaddingFactor
{
    return OUTER_ROUNDED_RECT_PADDING_FACTOR;
}

+(CGFloat)getOuterRoundedRectCornerRadiiFactor
{
    return OUTER_ROUNDED_RECT_PADDING_FACTOR;
}

+(CGFloat)getFramePaddingFactor
{
    return FRAME_PADDING_FACTOR;
}

+(UIFont *)getDefaultFont
{
    return [UIFont fontWithName:DEFAULT_FONT_NAME size:DEFAULT_FONT_SIZE];
}

+(UIColor *)getDefaultBorderColor
{
    return [UIColor blackColor];
}

+(CGFloat)getDefaultBorderThickness
{
    return DEFAULT_BORDER_THICKNESS;
}

+(UIColor *)getDefaultBackgroundColor
{
    return [UIColor whiteColor];
}

+(UIColor *)getdefaultTextColor
{
    return [UIColor blackColor];
}

@end
