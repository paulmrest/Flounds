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
    self.alarmSoundNames = [self.soundManager getAlarmSoundNames];
}

-(void)viewDidLayoutSubviews
{
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.doneButton];
    self.doneButton.containingVC = self;
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
    
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:TVCell];
    TVCell.backgroundColor = self.defaultBackgroundColor;
    
    if ([TVCell isKindOfClass:[FloundsTVCell class]])
    {
        FloundsTVCell *floundsTVCell = (FloundsTVCell *)TVCell;
        floundsTVCell.cellText.textColor = self.defaultUIColor;
        floundsTVCell.cellText.text = [self.alarmSoundNames objectAtIndex:indexPath.row];
        
        if ([floundsTVCell.cellText.text isEqualToString:[self.soundManager getDefaultAlarmSoundName]])
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

@end
