//
//  SnapTickSlider.m
//  Flounds
//
//  Created by Paul Rest on 2/3/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "SnapTickSlider.h"


@implementation SnapTickSlider

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initHelperSnapTickSlider];
    }
    return self;
}

-(void)initHelperSnapTickSlider
{
    [self setThumbImage:[UIImage imageNamed:@"WhiteTickMark"] forState:UIControlStateNormal];
    [self setThumbImage:[UIImage imageNamed:@"WhiteTickMark"] forState:UIControlStateHighlighted];
    
    [self setMinimumTrackTintColor:[FloundsViewConstants getDefaultTextColor]];
    [self setMaximumTrackTintColor:[FloundsViewConstants getDefaultTextColor]];
}

-(void)endTrackingWithTouch:(UITouch *)touch
                  withEvent:(UIEvent *)event
{
    if (self.value > floorf(self.value) ||
        self.value < ceilf(self.value) ||
        self.value == self.minimumValue ||
        self.value == self.maximumValue)
    {
        CGFloat roundedFloat = (float)roundf(self.value);
//        [self setValue:roundedFloat animated:YES];
        
        [self.updateSuperView updateSuperViewWithValue:roundedFloat
                                        forSliderKeyID:self.sliderKeyID];
    }
    [super endTrackingWithTouch:touch withEvent:event];
}

-(void)drawRect:(CGRect)rect
{
    CGFloat thumbOffset = self.currentThumbImage.size.width / 2.0f;
    NSInteger numberOfTicksToDraw = roundf(self.maximumValue - self.minimumValue) + 1;
    CGFloat distMinTickToMax = self.frame.size.width - (2.0f * thumbOffset);
    CGFloat distBetweenTicks = distMinTickToMax / ((float)numberOfTicksToDraw - 1.0f);
    
    CGFloat xTickMarkPosition = thumbOffset; //will change as tick marks are drawn across slider
    CGFloat yTickMarkStartingPosition = self.frame.size.height / 2; //will not change
    CGFloat yTickMarkEndingPosition = self.frame.size.height; //will not change
    UIBezierPath *tickPath = [UIBezierPath bezierPath];
    for (int i = 0; i < numberOfTicksToDraw; i++)
    {
        [tickPath moveToPoint:CGPointMake(xTickMarkPosition, yTickMarkStartingPosition)];
        [tickPath addLineToPoint:CGPointMake(xTickMarkPosition, yTickMarkEndingPosition)];
        xTickMarkPosition += distBetweenTicks;
    }
    [[FloundsViewConstants getDefaultTextColor] setStroke];
    tickPath.lineWidth = [FloundsViewConstants getDefaultBorderThickness];
    [tickPath stroke];
}

@end
