//
//  FloundsTVCell.h
//  Flounds
//
//  Created by Paul M Rest on 9/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsAppearanceUtility.h"

#import "CAAnimationFactory.h"

@interface FloundsTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellText;

@property (nonatomic, strong) UIViewController *containingVC;

@property (nonatomic, strong) UITableView *containingTV;

@property (nonatomic) BOOL active;


-(void)animateCellForSelectionToPerformSegue:(NSString *)identifier;

-(void)animateCellForNonSelection;

-(void)animateCellForSelectionWithoutSegue;

@end
