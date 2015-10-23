//
//  FloundsTVCell.h
//  Flounds
//
//  Created by Paul M Rest on 9/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

@interface FloundsTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cellText;

@property (nonatomic, strong) UIViewController *containingVC;

-(void)animateCellForSelectionToPerformSegue:(NSString *)identifier;

-(void)animateCellForNonSelection;

@end
