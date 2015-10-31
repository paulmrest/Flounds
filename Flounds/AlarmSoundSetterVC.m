//
//  AlarmSoundSetterVC.m
//  Flounds
//
//  Created by Paul M Rest on 10/26/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "AlarmSoundSetterVC.h"


@interface AlarmSoundSetterVC ()

@property (nonatomic, strong) NSString *currSelectedAlarmSound;

@end


@implementation AlarmSoundSetterVC

-(void)setInitialAlarmSound:(NSString *)alarmSound
{
    self.currSelectedAlarmSound = alarmSound;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TVCell = [tableView dequeueReusableCellWithIdentifier:@"AlarmSoundCell"];
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:TVCell];
    TVCell.backgroundColor = self.defaultBackgroundColor;
    
    if ([TVCell isKindOfClass:[FloundsTVCell class]])
    {
        FloundsTVCell *floundsTVCell = (FloundsTVCell *)TVCell;
        floundsTVCell.cellText.textColor = self.defaultUIColor;
        floundsTVCell.cellText.text = [self.alarmSoundNames objectAtIndex:indexPath.row];
        
        BOOL selectedCell = NO;
        
        if (self.currSelectedAlarmSound)
        {
            if ([floundsTVCell.cellText.text isEqualToString:self.currSelectedAlarmSound])
            {
                selectedCell = YES;
            }
        }
        else
        {
            if ([floundsTVCell.cellText.text isEqualToString:[self.soundManager getDefaultAlarmSoundName]])
            {
                selectedCell = YES;
            }
        }
        
        if (selectedCell)
        {
            floundsTVCell.cellText.alpha = 1.0f;
            for (CALayer *oneSublayer in floundsTVCell.layer.sublayers)
            {
                if ([oneSublayer isKindOfClass:[FloundsShapeLayer class]])
                {
                    oneSublayer.opacity = 1.0f;
                }
            }
        }
        else
        {
            floundsTVCell.cellText.alpha = 0.5f;
            for (CALayer *oneSublayer in floundsTVCell.layer.sublayers)
            {
                if ([oneSublayer isKindOfClass:[FloundsShapeLayer class]])
                {
                    oneSublayer.opacity = 0.5f;
                }
            }
        }
        return floundsTVCell;
    }
    return TVCell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *selectedTVCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedTVCell isKindOfClass:[FloundsTVCell class]])
    {
        FloundsTVCell *selectedFloundsCell = (FloundsTVCell *)selectedTVCell;
        
        self.currSelectedAlarmSound = selectedFloundsCell.cellText.text;
        [self.setAlarmSoundDelegate setAlarmSound:self.currSelectedAlarmSound];
        
        [selectedFloundsCell animateCellForSelectionWithoutSegue];
        
        [self animateNonSelectedTableViewCells:tableView];
        
        NSArray *nonSelectedCells = [self getVisibleNonSelectedCellsFor:tableView];
        NSMutableArray *indexPathsForNonSelectedCells = [[NSMutableArray alloc] initWithCapacity:[nonSelectedCells count]];
        for (FloundsTVCell *oneNonSelectedCell in nonSelectedCells)
        {
            [indexPathsForNonSelectedCells addObject:[tableView indexPathForCell:oneNonSelectedCell]];
        }
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [tableView reloadRowsAtIndexPaths:indexPathsForNonSelectedCells withRowAnimation:UITableViewRowAnimationLeft];
    }
}

@end
