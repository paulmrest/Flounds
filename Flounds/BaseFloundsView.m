//
//  BaseFloundsView.m
//  Flounds
//
//  Created by Paul M Rest on 9/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "BaseFloundsView.h"

@interface BaseFloundsView ()

@property (strong, nonatomic) UIBezierPath *outerRoundedRect;

@property (nonatomic) CGFloat outerRoundedRectPadding;

@property (nonatomic) CGSize outerRoundedRectCornerRadii;

@end


@implementation BaseFloundsView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSetup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initSetup];
    }
    return self;
}

-(void)initSetup
{
    [self setBackgroundColor:[UIColor clearColor]];
    self.userInteractionEnabled = NO;
    [self setOuterRectValues];
}

-(void)setOuterRectValues
{
    CGFloat smallerAxis = (self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width);
    self.outerRoundedRectPadding = smallerAxis / [FloundsViewConstants getOuterRoundedRectPaddingFactor];
    self.outerRoundedRectCornerRadii = CGSizeMake(smallerAxis / [FloundsViewConstants getOuterRoundedRectCornerRadiiFactor],
                                                  smallerAxis / [FloundsViewConstants getOuterRoundedRectCornerRadiiFactor]);
}

-(void)drawRect:(CGRect)rect
{
    CGRect outerRoundedRectRect = CGRectMake(rect.origin.x + (self.outerRoundedRectPadding / 2.0),
                                             rect.origin.y + (self.outerRoundedRectPadding / 2.0),
                                             rect.size.width - self.outerRoundedRectPadding,
                                             rect.size.height - self.outerRoundedRectPadding);
    self.outerRoundedRect = [UIBezierPath bezierPathWithRoundedRect:outerRoundedRectRect
                                                  byRoundingCorners:UIRectCornerAllCorners
                                                        cornerRadii:self.outerRoundedRectCornerRadii];
    [[UIColor blackColor] setStroke];
    self.outerRoundedRect.lineWidth = 1.0f;
    [self.outerRoundedRect stroke];
}

@end
