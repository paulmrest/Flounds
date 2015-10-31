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

//>>>
//@property (nonatomic) CGPoint centerPoint;
//<<<

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
    
    self.backgroundColor = [FloundsViewConstants getDefaultBackgroundColor];
    
    self.displayFont = [[FloundsViewConstants getDefaultFont] fontWithSize:45.0f];
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
    _displayText = displayText;
    self.displayTextAttString = [[NSAttributedString alloc] initWithString:self.displayText
                                                                attributes:@{NSFontAttributeName : self.displayFont,
                                                                             NSForegroundColorAttributeName : self.fontColor}];
    
    if (self.centerTextOnEachRedrawCycle || !self.textDrawPointSet)
    {
        self.textDrawOriginPoint = CGPointMake((self.frame.size.width - self.displayTextAttString.size.width) / 2.0f,
                                               (self.frame.size.height - self.displayTextAttString.size.height) / 2.0f);
        //>>>
//        self.centerPoint = CGPointMake(self.frame.size.width / 2.0f,
//                                       self.frame.size.height / 2.0f);
        //<<<
        
        self.textDrawPointSet = YES;
    }
}

-(void)drawRect:(CGRect)rect
{
    [self.displayTextAttString drawAtPoint:self.textDrawOriginPoint];
    
    //>>>
//    UIBezierPath *centerPoint = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.centerPoint.x - 2.0f,
//                                                                                  self.centerPoint.y - 2.0f,
//                                                                                  4.0f,
//                                                                                  4.0f)];
//    centerPoint.lineWidth = 2.0f;
//    [centerPoint stroke];
    //<<<
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
