//
//  FloundsVCBase.h
//  Flounds
//
//  Created by Paul M Rest on 8/31/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FloundsAppearanceUtility.h"

#import "FloundsButton.h"
#import "FloundsButtonUnwindProtocol.h"
#import "FloundsUserInteractionSegueProtocol.h"
#import "FloundsButtonSegue.h"

#import "FloundsTVCell.h"

@interface FloundsVCBase : UIViewController <FloundsUserInteractionSegueProtocol, FloundsButtonUnwindProtocol>

//FloundsButtonUnwindProtocol
@property (nonatomic, strong) FloundsButton *unwindActivatingButton;

//FloundsButtonSegueProtocol
@property (nonatomic, strong) UIViewController<FloundsUserInteractionSegueProtocol> *presentingVC;


@property (nonatomic, strong) UIColor *defaultBackgroundColor;

@property (nonatomic, strong) UIColor *defaultUIColor;

@property (nonatomic, strong) UIFont *fullWidthFloundsButtonFont;

@property (nonatomic, strong) UIFont *nonFullWidthFloundsButtonAndTVCellFont;


@property (nonatomic) BOOL showGeneralErrorOnViewWillAppear;


-(void)animateNonSelectedTableViewCells:(UITableView *)tableView;

-(NSArray *)getVisibleNonSelectedCellsFor:(UITableView *)tableView;

-(void)removeAnimationsFromPresentingVC;

-(void)presentGeneralErrorAlert;

@end
