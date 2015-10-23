//
//  VerticallyAlignedTextView.m
//  Flounds
//
//  Created by Paul Rest on 11/5/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "VerticallyAlignedTextView.h"


@implementation VerticallyAlignedTextView

-(id)initWithFrame:(CGRect)frame
     textContainer:(NSTextContainer *)textContainer
{
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self)
    {
        [self setUpVerticallyAlignedTextView];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpVerticallyAlignedTextView];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {        
        [self setUpVerticallyAlignedTextView];
    }
    return self;
}

-(void)setUpVerticallyAlignedTextView
{
    self.textAlignment = NSTextAlignmentCenter;
    self.editable = NO;
    [self verticallyAlignText];
}

-(void)verticallyAlignText
{
    CGPoint verticalOffset = CGPointMake(0.0f, -(self.frame.size.height - self.contentSize.height));
    [self setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
    [self setContentOffset:verticalOffset animated:NO];
}

@end
