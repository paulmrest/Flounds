//
//  FloundsViewConstants.m
//  Flounds
//
//  Created by Paul M Rest on 9/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsViewConstants.h"

const CGFloat OUTER_ROUNDED_RECT_PADDING_FACTOR = 0.05f;

const CGFloat OUTER_ROUNDED_RECT_CORNER_RADII_FACTOR = 0.05f;

const CGFloat FRAME_PADDING_FACTOR = 0.2f;


static NSString *DEFAULT_FONT_NAME = @"Kailasa";


const CGFloat FULL_WIDTH_FLOUNDS_BUTTON_WIDTH_SIZING_FACTOR = 0.9f;

const CGFloat ALL_FLOUNDS_BUTTON_HEIGHT_SIZING_FACTOR = 0.1f;

const CGFloat FONT_SIZE_BORDER_PADDING_FACTOR = 0.25f;

const CGFloat FONT_SIZE_FLOUNDS_BUTTON_PADDING_FACTOR = 0.5;

const CGFloat NON_FULL_WIDTH_FLOUNDS_BUTTON_FONT_SIZE_FACTOR = 0.75;

const CGFloat TABLE_VIEW_CELL_HEIGHT_SIZING_FACTOR = 1.5f;


const CGFloat DEFAULT_FONT_SIZE = 18.0F;


const CGFloat DEFAULT_BORDER_THICKNESS = 2.0f;


@interface FloundsViewConstants ()

@end


@implementation FloundsViewConstants

+(CGFloat)getTableViewCellHeightSizingFactor
{
    return TABLE_VIEW_CELL_HEIGHT_SIZING_FACTOR;
}

+(CGFloat)getOuterRoundedRectPaddingFactor
{
    return OUTER_ROUNDED_RECT_PADDING_FACTOR;
}

+(CGFloat)getOuterRoundedRectCornerRadiiFactor
{
    return OUTER_ROUNDED_RECT_CORNER_RADII_FACTOR;
}

+(CGFloat)getFramePaddingFactor
{
    return FRAME_PADDING_FACTOR;
}

+(CGFloat)getFullWidthFloundsButtonWidthSizingFactor
{
    return FULL_WIDTH_FLOUNDS_BUTTON_WIDTH_SIZING_FACTOR;
}

+(CGFloat)getAllFloundsButtonHeightSizingFactor
{
    return ALL_FLOUNDS_BUTTON_HEIGHT_SIZING_FACTOR;
}

+(CGFloat)getnonFullWidthFloundsButtonAndTVCellFontSizeFactor
{
    return NON_FULL_WIDTH_FLOUNDS_BUTTON_FONT_SIZE_FACTOR;
}

+(CGFloat)getFontFramePaddingFactor
{
    return FONT_SIZE_BORDER_PADDING_FACTOR;
}

+(CGFloat)getFloundsButtonFontFramePaddingFactor
{
    return FONT_SIZE_FLOUNDS_BUTTON_PADDING_FACTOR;
}

+(NSString *)getDefaultFontFamilyName
{
    return [NSString stringWithString:DEFAULT_FONT_NAME];
}

+(UIFont *)getDefaultFont
{
    return [UIFont fontWithName:DEFAULT_FONT_NAME size:DEFAULT_FONT_SIZE];
}

+(UIColor *)getDefaultBorderColor
{
    return [UIColor whiteColor];
}

+(CGFloat)getDefaultBorderThickness
{
    return DEFAULT_BORDER_THICKNESS;
}

+(UIColor *)getDefaultBackgroundColor
{
    return [UIColor blackColor];
}

+(UIColor *)getDefaultButtonBackgroundColor
{
    return [UIColor clearColor];
}

+(UIColor *)getDefaultTextColor
{
    return [UIColor whiteColor];
}

+(UIColor *)getDefaultShapeStrokeColor
{
    return [UIColor whiteColor];
}

@end
