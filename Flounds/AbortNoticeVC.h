//
//  AbortNoticeVC.h
//  Flounds
//
//  Created by Paul M Rest on 10/28/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsVCBase.h"

#import "AbortNoticeLabel.h"

#import "FloundsModel.h"

#import "PatternMakerVC.h"

#import "ModalPatternMakerDelegate.h"

@interface AbortNoticeVC : FloundsVCBase <ModalPatternMakerDelegate>

@property (nonatomic, weak) IBOutlet FloundsButton *okayButton;

@property (nonatomic, weak) IBOutlet AbortNoticeLabel *abortNoticeLabel;

@property (nonatomic, strong) FloundsModel *tryItFloundsModel;

@property (nonatomic, weak) id<ModalPatternMakerDelegate> patternMakerDelegate;

@end
