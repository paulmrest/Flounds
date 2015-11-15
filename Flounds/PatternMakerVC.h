//
//  PatternMakerVC.h
//  Flounds
//
//  Created by Paul Rest on 5/16/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloundsUserInteractionSegueProtocol.h"

#import "FloundsModel.h"

#import "ShapeView.h"

#import "BezierShapeFactory.h"
#import "ModalPatternMakerDelegate.h"


#define ARC4RANDOM_MAX 0x100000000

@interface PatternMakerVC : UIViewController

@property (nonatomic, weak) IBOutlet ShapeView *shapeView;

@property (nonatomic, weak) id<ModalPatternMakerDelegate> patternMakerDelegate;

@property (nonatomic, weak) id<FloundsUserInteractionSegueProtocol> presentingVC;

@property (nonatomic, strong) FloundsModel *floundsModel;

@property (nonatomic) BOOL abortAvailable;

@end
