//
//  TryFloundsSplashVC.h
//  Flounds
//
//  Created by Paul Rest on 2/22/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import <CoreText/CTStringAttributes.h>

#import "FloundsVCBase.h"

#import "FloundsModel.h"
#import "PatternMakerVC.h"
#import "AbortNoticeVC.h"

#import "VerticallyCenteredTextView.h"

#import "UnwindFromTryItFloundsDelegate.h"

@interface TryFloundsSplashVC : FloundsVCBase <ModalPatternMakerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (weak, nonatomic) IBOutlet UILabel *difficultyLabel;

@property (weak, nonatomic) IBOutlet UILabel *startingShapesLabel;

@property (weak, nonatomic) IBOutlet UILabel *launchLabel;

@property (weak, nonatomic) IBOutlet UILabel *countDownLabel;

@property (nonatomic, weak) IBOutlet VerticallyCenteredTextView *countDownTextView;

@property (weak, nonatomic) IBOutlet FloundsButton *cancelButton;

@property (nonatomic, strong) FloundsModel *tryItFloundsModel;

@property (nonatomic, weak) id<UnwindFromTryItFloundsDelegate> unwindFromTryItDelegate;

@end