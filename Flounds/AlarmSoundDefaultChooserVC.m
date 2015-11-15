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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        ALARM_SOUND_INFO_SEGUE_ID = @"SetDefaultAlarmSoundInfoSegue";
    }
    return self;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *selectedTVCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedTVCell isKindOfClass:[AlarmSoundTVCell class]])
    {
        AlarmSoundTVCell *selectedAlarmSoundCell = (AlarmSoundTVCell *)selectedTVCell;
        if ([self.soundManager setDefaultAlarmFromDisplayName:selectedAlarmSoundCell.cellText.text])
        {
            [selectedAlarmSoundCell animateCellForSelectionWithoutSegue];
            
            [self animateNonSelectedTableViewCells:tableView];
            
            NSArray *nonSelectedCells = [self getVisibleNonSelectedCellsFor:tableView];
            NSMutableArray *indexPathsForNonSelectedCells = [[NSMutableArray alloc] initWithCapacity:[nonSelectedCells count]];
            for (AlarmSoundTVCell *oneNonSelectedCell in nonSelectedCells)
            {
                [indexPathsForNonSelectedCells addObject:[tableView indexPathForCell:oneNonSelectedCell]];
            }
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
            [tableView reloadRowsAtIndexPaths:indexPathsForNonSelectedCells withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

@end
