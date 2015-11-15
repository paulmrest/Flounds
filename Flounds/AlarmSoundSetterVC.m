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

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        ALARM_SOUND_INFO_SEGUE_ID = @"SetOneAlarmSoundInfoSegue";
    }
    return self;
}

-(void)setInitialAlarmSound:(NSString *)alarmSound
{
    self.currSelectedAlarmSound = alarmSound;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TVCell = [tableView dequeueReusableCellWithIdentifier:@"AlarmSoundCell"];
    
    TVCell.backgroundColor = self.defaultBackgroundColor;
    
    if ([TVCell isKindOfClass:[AlarmSoundTVCell class]])
    {
        AlarmSoundTVCell *alarmSoundTVCell = (AlarmSoundTVCell *)TVCell;
        alarmSoundTVCell.cellText.textColor = self.defaultUIColor;
        alarmSoundTVCell.cellText.font = self.nonFullWidthFloundsButtonAndTVCellFont;
        alarmSoundTVCell.cellText.text = [self.alarmSoundNames objectAtIndex:indexPath.row];
        
        BOOL selectedCell = NO;
        if (self.currSelectedAlarmSound)
        {
            if ([alarmSoundTVCell.cellText.text isEqualToString:self.currSelectedAlarmSound])
            {
                selectedCell = YES;
            }
        }
        else
        {
            if ([alarmSoundTVCell.cellText.text isEqualToString:[self.soundManager getDefaultAlarmSoundName]])
            {
                selectedCell = YES;
            }
        }
        
        alarmSoundTVCell.active = selectedCell;
        
//        if (selectedCell)
//        {
//            alarmSoundTVCell.cellText.alpha = 1.0f;
//            alarmSoundTVCell.layer.opacity = 1.0f;
//        }
//        else
//        {
//            alarmSoundTVCell.cellText.alpha = 0.5f;
//            alarmSoundTVCell.layer.opacity = 0.5f;
//        }
//        [alarmSoundTVCell setNeedsDisplay];
        return alarmSoundTVCell;
    }
    return TVCell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *selectedTVCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([selectedTVCell isKindOfClass:[AlarmSoundTVCell class]])
    {
        AlarmSoundTVCell *selectedAlarmSoundCell = (AlarmSoundTVCell *)selectedTVCell;
        
        self.currSelectedAlarmSound = selectedAlarmSoundCell.cellText.text;
        [self.setAlarmSoundDelegate setAlarmSound:self.currSelectedAlarmSound];
        
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

@end
