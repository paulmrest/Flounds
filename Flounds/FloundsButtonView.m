//
//  FloundsButtonView.m
//  Flounds
//
//  Created by Paul M Rest on 7/11/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "FloundsButtonView.h"

@implementation FloundsButtonView

-(void)drawRect:(CGRect)rect
{
    CGRect testCircleRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.height / 2.0f, rect.size.height / 2.0f);
    UIBezierPath *testCircle = [UIBezierPath bezierPathWithOvalInRect:testCircleRect];
    
    [testCircle fill];
}

@end
