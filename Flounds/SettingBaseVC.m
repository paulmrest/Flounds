//
//  SettingBaseVC.m
//  Flounds
//
//  Created by Paul Rest on 10/31/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "SettingBaseVC.h"

@interface SettingBaseVC ()

@end

@implementation SettingBaseVC

-(void)viewDidLoad
{
    [super viewDidLoad];

    CANCEL_BUTTON_TITLE = NSLocalizedString(@"Cancel", nil);
    
    self.cancelButton.titleLabel.font = self.nonFullWidthFloundsButtonAndTVCellFont;
    self.cancelButton.containingVC = self;
}

-(IBAction)cancelButton:(id)sender
{
    if ([sender isKindOfClass:[FloundsButton class]])
    {
        FloundsButton *floundsCancelButton = (FloundsButton *)sender;
        self.unwindActivatingButton = floundsCancelButton;
        [floundsCancelButton animateForPushDismissCurrView];
    }
}

@end
