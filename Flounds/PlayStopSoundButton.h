//
//  PlayStopSoundButton.h
//  Flounds
//
//  Created by Paul M Rest on 10/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloundsViewConstants.h"

#define ARC4RANDOM_MAX 0x100000000

@interface PlayStopSoundButton : UIButton

@property (nonatomic) BOOL currentlyPlayingSound;

@property (nonatomic) CGFloat soundPlayDuration;

-(void)animateButtonTogglePlayStop;

@end
