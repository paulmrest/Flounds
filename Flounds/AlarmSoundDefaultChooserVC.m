//
//  AlarmSoundDefaultChooserVC.m
//  Flounds
//
//  Created by Paul M Rest on 10/16/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "AlarmSoundDefaultChooserVC.h"


@interface AlarmSoundDefaultChooserVC ()

@end


@implementation AlarmSoundDefaultChooserVC

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *selectedTVCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedTVCell isKindOfClass:[DefaultSoundTVCell class]])
    {
        DefaultSoundTVCell *selectedDefaultSoundCell = (DefaultSoundTVCell *)selectedTVCell;
        if ([self.soundManager setDefaultAlarmFromDisplayName:selectedDefaultSoundCell.cellText.text])
        {
            [selectedDefaultSoundCell animateCellForSelectionWithoutSegue];
            
            [self animateNonSelectedTableViewCells:tableView];
            
            NSArray *nonSelectedCells = [self getVisibleNonSelectedCellsFor:tableView];
            NSMutableArray *indexPathsForNonSelectedCells = [[NSMutableArray alloc] initWithCapacity:[nonSelectedCells count]];
            for (DefaultSoundTVCell *oneNonSelectedCell in nonSelectedCells)
            {
                [indexPathsForNonSelectedCells addObject:[tableView indexPathForCell:oneNonSelectedCell]];
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [tableView reloadRowsAtIndexPaths:indexPathsForNonSelectedCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

@end
