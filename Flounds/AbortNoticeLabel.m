//
//  AbortNoticeLabel.m
//  Flounds
//
//  Created by Paul M Rest on 10/29/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "AbortNoticeLabel.h"

@implementation AbortNoticeLabel

-(void)drawTextInRect:(CGRect)rect
{
    CGFloat leftAndRightInset = self.frame.size.width * 0.1f;
    UIEdgeInsets insets = {0, leftAndRightInset, 0, leftAndRightInset};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
