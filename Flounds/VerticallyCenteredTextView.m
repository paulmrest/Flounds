//
//  VerticallyCenteredTextView.m
//  Flounds
//
//  Created by Paul M Rest on 10/7/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "VerticallyCenteredTextView.h"


@interface VerticallyCenteredTextView ()

@property (nonatomic, strong) NSAttributedString *displayTextAttString;

@property (nonatomic) CGPoint textDrawOriginPoint;

@property (nonatomic) BOOL textDrawPointSet;

@end


@implementation VerticallyCenteredTextView

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.textDrawPointSet = NO;
        
        self.backgroundColor = [FloundsViewConstants getDefaultBackgroundColor];
        
        self.displayFont = [[FloundsViewConstants getDefaultFont] fontWithSize:45.0f];
        self.fontColor = [FloundsViewConstants getdefaultTextColor];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.textDrawPointSet = NO;
        
        self.backgroundColor = [FloundsViewConstants getDefaultBackgroundColor];
        
        self.displayFont = [[FloundsViewConstants getDefaultFont] fontWithSize:45.0f];
        self.fontColor = [FloundsViewConstants getdefaultTextColor];
    }
    return self;
}

-(UIColor *)fontColor
{
    if (!_fontColor)
    {
        _fontColor = [UIColor blackColor];
    }
    return _fontColor;
}

-(void)setDisplayText:(NSString *)displayText
{
    _displayText = displayText;
    self.displayTextAttString = [[NSAttributedString alloc] initWithString:self.displayText
                                                                attributes:@{NSFontAttributeName : self.displayFont,
                                                                             NSForegroundColorAttributeName : self.fontColor}];
    if (self.centerTextOnEachRedrawCycle || !self.textDrawPointSet)
    {
        self.textDrawOriginPoint = CGPointMake((self.frame.size.width - self.displayTextAttString.size.width) / 2.0f,
                                               (self.frame.size.height - self.displayTextAttString.size.height) / 2.0f);
        self.textDrawPointSet = YES;
    }
}

-(void)drawRect:(CGRect)rect
{
    [self.displayTextAttString drawAtPoint:self.textDrawOriginPoint];
}

@end
