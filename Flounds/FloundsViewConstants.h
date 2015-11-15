//
//  FloundsViewConstants.h
//  Flounds
//
//  Created by Paul M Rest on 9/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloundsViewConstants : NSObject

+(CGFloat)getTableViewCellHeightSizingFactor;


+(CGFloat)getOuterRoundedRectPaddingFactor;

+(CGFloat)getOuterRoundedRectCornerRadiiFactor;


+(CGFloat)getFramePaddingFactor;

+(NSString *)getDefaultFontFamilyName;

+(CGFloat)getFullWidthFloundsButtonWidthSizingFactor;

+(CGFloat)getAllFloundsButtonHeightSizingFactor;

+(CGFloat)getnonFullWidthFloundsButtonAndTVCellFontSizeFactor;

+(CGFloat)getFontFramePaddingFactor;

+(CGFloat)getFloundsButtonFontFramePaddingFactor;


+(UIFont *)getDefaultFont;

+(UIColor *)getDefaultBorderColor;

+(CGFloat)getDefaultBorderThickness;

+(UIColor *)getDefaultBackgroundColor;

+(UIColor *)getDefaultButtonBackgroundColor;

+(UIColor *)getDefaultTextColor;

+(UIColor *)getDefaultShapeStrokeColor;

@end
