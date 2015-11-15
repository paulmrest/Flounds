//
//  VerticallyCenteredTextView.m
//  Flounds
//
//  Created by Paul M Rest on 10/7/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "VerticallyCenteredTextView.h"


//const CGFloat BASE_FONT_SIZE = 45.0f;
//
//const CGFloat FONT_SIZE_BORDER_PADDING_FACTOR = 0.2f;


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
        [self initHelperVerticallyCenteredTextView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initHelperVerticallyCenteredTextView];
    }
    return self;
}

-(void)initHelperVerticallyCenteredTextView
{
    self.textDrawPointSet = NO;
    self.centerTextOnEachRedrawCycle = YES;
    self.checkFontSizeOnEachRedrawCycle = YES;
    
    self.backgroundColor = [FloundsViewConstants getDefaultBackgroundColor];
    
    self.displayFont = nil;
    self.fontColor = [FloundsViewConstants getDefaultTextColor];
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
    //if the client class doesn't set self.displayFont, we dynamically set the font based on the first piece of text
    //we ask the view to display
    if (!self.displayFont)
    {
        self.displayFont = [FloundsAppearanceUtility getFloundsFontForBounds:self.frame
                                                             givenSampleText:displayText
                                                            forBorderedSpace:NO];
    }
    
    _displayText = displayText;
    self.displayTextAttString = [[NSAttributedString alloc] initWithString:self.displayText
                                                                attributes:@{NSFontAttributeName : self.displayFont,
                                                                             NSForegroundColorAttributeName : self.fontColor}];
    
    //each time the client class changes self.displayText, we check to make sure that it isn't going to exceed the allowable
    //text space, and if it is, we reset self.displayFont for the new displayText
    if (self.checkFontSizeOnEachRedrawCycle &&
        [FloundsAppearanceUtility attStringExceedsAvailableSpaceGiven:self.displayTextAttString
                                                          displayRect:self.frame])
    {
        self.displayFont = nil;
        [self setDisplayText:displayText];
    }
    
    if (self.centerTextOnEachRedrawCycle || !self.textDrawPointSet)
    {
        self.textDrawOriginPoint = CGPointMake((self.frame.size.width - self.displayTextAttString.size.width) / 2.0f,
                                               (self.frame.size.height - self.displayTextAttString.size.height) / 2.0f);
        self.textDrawPointSet = YES;
    }
}

-(void)drawRect:(CGRect)rect
{
    if (self.drawFloundsBorder)
    {
        [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self];
    }
    [self.displayTextAttString drawAtPoint:self.textDrawOriginPoint];
}

-(void)animateForSegueWithID:(NSString *)segueID
                  fromSender:(UIViewController *)sender
{
    CABasicAnimation *slideRightAnimation = [CAAnimationFactory slideAnimation];
    slideRightAnimation.toValue = [NSNumber numberWithInteger:self.frame.size.width];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [sender performSegueWithIdentifier:segueID sender:sender];
    }];
    [self.layer addAnimation:slideRightAnimation forKey:nil];
    [CATransaction commit];
}

@end
