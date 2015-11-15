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
    BOOL floundsSublayerPresent = NO;
    
    if ([[view class] isSubclassOfClass:[UIView class]])
    {
        for (CALayer *oneLayer in view.layer.sublayers)
        {
            if ([oneLayer isKindOfClass:[FloundsShapeLayer class]])
            {
                floundsSublayerPresent = YES;
                break;
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

+(UIFont *)getFloundsFontForBounds:(CGRect)boundingRect
                   givenSampleText:(NSString *)sampleText
                  forBorderedSpace:(BOOL)bordered
{
    NSString *defaultFontFamilyName = [FloundsViewConstants getDefaultFontFamilyName];
    
    CGFloat fontFramePaddingFactor = 0.0f;
    if (bordered)
    {
        fontFramePaddingFactor = [FloundsViewConstants getFontFramePaddingFactor];
    }
    else
    {
        fontFramePaddingFactor = [FloundsViewConstants getFramePaddingFactor];
    }
    
    CGFloat heightBasedFontPointSize = boundingRect.size.height - (fontFramePaddingFactor * boundingRect.size.height);
    
    UIFont *heightBasedReturnFont = [UIFont fontWithName:defaultFontFamilyName
                                              size:heightBasedFontPointSize];
    
    NSAttributedString *tempAttString = [[NSAttributedString alloc] initWithString:sampleText
                                                                        attributes:@{NSFontAttributeName : heightBasedReturnFont}];
    
    CGFloat paddedBoundingRectWidth = boundingRect.size.width - (fontFramePaddingFactor * boundingRect.size.width);
    if (tempAttString.size.width <= paddedBoundingRectWidth)
    {
        return heightBasedReturnFont;
    }
    else
    {
        CGFloat widthBasedFontPointSize = heightBasedFontPointSize * (paddedBoundingRectWidth / tempAttString.size.width);
        return [UIFont fontWithName:defaultFontFamilyName size:widthBasedFontPointSize];
    }
}

+(BOOL)attStringExceedsAvailableSpaceGiven:(NSAttributedString *)attString
                               displayRect:(CGRect)availableRect
{
    CGFloat fontFramePaddingFactor = [FloundsViewConstants getFontFramePaddingFactor];
    CGFloat availableViewTextSpace = availableRect.size.width - (availableRect.size.width * fontFramePaddingFactor);
    
    if (attString.size.width > availableViewTextSpace)
    {
        return YES;
    }
    return NO;
}

+(BOOL)stringExceedsAvailableSpaceGiven:(NSString *)string
                            displayFont:(UIFont *)displayFont
                            displayRect:(CGRect)availableRect
{
    NSAttributedString *attStringWithFont = [[NSAttributedString alloc] initWithString:string
                                                                            attributes:@{NSFontAttributeName : displayFont}];
    return [FloundsAppearanceUtility attStringExceedsAvailableSpaceGiven:attStringWithFont
                                                             displayRect:availableRect];
}

@end
