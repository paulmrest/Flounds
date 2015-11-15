//
//  FloundsAlarmSoundChooserVCBase.m
//  Flounds
//
//  Created by Paul M Rest on 10/26/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "FloundsAlarmSoundChooserVCBase.h"


const NSInteger NUMBER_OF_SECTIONS_IN_TABLE_VIEW = 1;


@interface FloundsAlarmSoundChooserVCBase ()

@end


@implementation FloundsAlarmSoundChooserVCBase

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.doneButton.titleLabel.font = self.fullWidthFloundsButtonFont;
    self.alarmSoundNames = [self.soundManager getAlarmSoundNames];
}

-(void)viewDidLayoutSubviews
{
    self.doneButton.containingVC = self;
}

#pragma UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat displayFontPointSize = self.nonFullWidthFloundsButtonAndTVCellFont.pointSize;
    
    CGFloat cellHeightReturnValue = displayFontPointSize + (displayFontPointSize * [FloundsViewConstants getTableViewCellHeightSizingFactor]);
    
    return cellHeightReturnValue;
}

#pragma UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUMBER_OF_SECTIONS_IN_TABLE_VIEW;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.alarmSoundNames count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *TVCell = [tableView dequeueReusableCellWithIdentifier:@"AlarmSoundCell"];
    
//    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:TVCell];
    TVCell.backgroundColor = self.defaultBackgroundColor;
    
    if ([TVCell isKindOfClass:[AlarmSoundTVCell class]])
    {
        AlarmSoundTVCell *alarmSoundTVCell = (AlarmSoundTVCell *)TVCell;
        alarmSoundTVCell.containingTV = self.alarmSoundsTV;
        
        [alarmSoundTVCell.infoButton setTintColor:self.defaultUIColor];
        alarmSoundTVCell.cellText.textColor = self.defaultUIColor;
        alarmSoundTVCell.cellText.font = self.nonFullWidthFloundsButtonAndTVCellFont;
        alarmSoundTVCell.cellText.text = [self.alarmSoundNames objectAtIndex:indexPath.row];
        
        alarmSoundTVCell.active = [alarmSoundTVCell.cellText.text isEqualToString:[self.soundManager getDefaultAlarmSoundName]];
        
//        if ([alarmSoundTVCell.cellText.text isEqualToString:[self.soundManager getDefaultAlarmSoundName]])
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
    //empty implementation, to be implemented in subclasses
}

-(IBAction)doneButton:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsDoneButton = (FloundsButton *)sender;
        self.unwindActivatingButton = floundsDoneButton;
        [floundsDoneButton animateForPushDismissCurrView];
    }
}

- (IBAction)alarmSoundInfoButtonPushed:(id)sender
{
    CGPoint buttonPostion = [sender convertPoint:CGPointZero toView:self.alarmSoundsTV];
    NSIndexPath *indexPathOfContainingTVC = [self.alarmSoundsTV indexPathForRowAtPoint:buttonPostion];
    if (indexPathOfContainingTVC)
    {
        UITableViewCell *TVCell = [self.alarmSoundsTV cellForRowAtIndexPath:indexPathOfContainingTVC];
        if ([TVCell isKindOfClass:[AlarmSoundTVCell class]])
        {
            AlarmSoundTVCell *containingAlarmSoundCell = (AlarmSoundTVCell *)TVCell;
            NSString *alarmDisplayName = containingAlarmSoundCell.cellText.text;
            [self performSegueWithIdentifier:ALARM_SOUND_INFO_SEGUE_ID sender:alarmDisplayName];
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:ALARM_SOUND_INFO_SEGUE_ID])
    {
        if ([sender isKindOfClass:[NSString class]])
        {
            NSString *alarmDisplayName = (NSString *)sender;
            if ([segue.destinationViewController isKindOfClass:[AlarmSoundInfoVC class]])
            {
                AlarmSoundInfoVC *alarmSoundInfoVC = (AlarmSoundInfoVC *)segue.destinationViewController;
                alarmSoundInfoVC.soundManager = self.soundManager;
                alarmSoundInfoVC.alarmSoundDisplayName = alarmDisplayName;
            }
        }
    }
}

@end
