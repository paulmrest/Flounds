//
//  SliderUpdateSuperViewProtocol.h
//  Flounds
//
//  Created by Paul M Rest on 6/27/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

@protocol SliderUpdateSuperViewProtocol <NSObject>

-(void)updateSuperViewWithValue:(CGFloat)sliderValue
                 forSliderKeyID:(NSString *)sliderID;

@end