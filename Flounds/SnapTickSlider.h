//
//  SnapTickSlider.h
//  Flounds
//
//  Created by Paul Rest on 2/3/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SliderUpdateSuperViewDelegate.h"

@interface SnapTickSlider : UISlider

@property (weak, nonatomic) id<SliderUpdateSuperViewDelegate> updateSuperView;

@end
