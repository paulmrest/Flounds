//
//  DifficultySettingsVC.h
//  Flounds
//
//  Created by Paul Rest on 10/27/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingBaseVC.h"
#import "FloundsModel.h"

#import "SnapTickSlider.h"

#import "UnwindFromTryItFloundsDelegate.h"
#import "TryFloundsSplashVC.h"
#import "PatternMakerVC.h"

#import "SliderUpdateSuperViewDelegate.h"


@interface DifficultySettingsVC : SettingBaseVC <UnwindFromTryItFloundsDelegate, SliderUpdateSuperViewDelegate>

@property (nonatomic, strong) FloundsModel *floundsModel;

@property (weak, nonatomic) IBOutlet FloundsButton *setButton;

@property (weak, nonatomic) IBOutlet SnapTickSlider *startingShapesSlider;

@property (weak, nonatomic) IBOutlet UILabel *startShapesLabel;

@property (weak, nonatomic) IBOutlet SnapTickSlider *difficultyLevelSlider;

@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@property (weak, nonatomic) IBOutlet FloundsButton *tryAndCancelTrialButton;

@end
