//
//  FloundsButtonControlView.m
//  Flounds
//
//  Created by Paul M Rest on 7/11/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "FloundsButtonControlView.h"

@implementation FloundsButtonControlView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGRect testCircleRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, rect.size.height / 2.0f, rect.size.height / 2.0f);
    UIBezierPath *testCircle = [UIBezierPath bezierPathWithOvalInRect:testCircleRect];
    
    [[UIColor blackColor] setFill];
    [testCircle fill];
}

@end
