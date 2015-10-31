//
//  DefaultSoundTVCell.m
//  Flounds
//
//  Created by Paul M Rest on 10/29/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "DefaultSoundTVCell.h"

@implementation DefaultSoundTVCell

-(IBAction)infoButtonPushed:(id)sender
{
    
}

-(void)drawRect:(CGRect)rect
{
    [self.infoButton setTintColor:[FloundsViewConstants getDefaultTextColor]];
}

@end
