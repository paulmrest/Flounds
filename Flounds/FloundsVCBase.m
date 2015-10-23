//
//  FloundsVCBase.m
//  Flounds
//
//  Created by Paul M Rest on 8/31/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "FloundsVCBase.h"

@implementation FloundsVCBase

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.defaultBackgroundColor = [FloundsViewConstants getDefaultBackgroundColor];
    self.view.backgroundColor = self.defaultBackgroundColor;
    for (UIView *oneSubview in self.view.subviews)
    {
        oneSubview.backgroundColor = self.defaultBackgroundColor;
    }
    
    self.defaultUIColor = [FloundsViewConstants getdefaultTextColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.presentingVC)
    {
        [self.presentingVC removeAnimationsFromPresentingVC];
    }
}

-(IBAction)unwindToParentVC:(UIStoryboardSegue *)segue
{
//    if ([segue isKindOfClass:[FloundsButtonSegue class]] && [segue.identifier isEqualToString:@"FloundsUnwind"])
//    {
//    
//    }
}


-(UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
                                     fromViewController:(UIViewController *)fromViewController
                                             identifier:(NSString *)identifier
{
    FloundsButtonSegue *floundsUnwindSegue = [[FloundsButtonSegue alloc] initWithIdentifier:identifier
                                                                                     source:fromViewController
                                                                                destination:toViewController];
    if ([[fromViewController class] isSubclassOfClass:[FloundsVCBase class]])
    {
        FloundsVCBase *floundVC = (FloundsVCBase *)fromViewController;
        floundsUnwindSegue.pressedButton = floundVC.unwindActivatingButton;
    }
    return floundsUnwindSegue;
}

-(void)animateNonSelectedTableViewCells:(UITableView *)tableView
{
    NSMutableArray *visibleUnselectedCells = [[NSMutableArray alloc] initWithCapacity:[tableView.visibleCells count]];
    for (UITableViewCell *oneTVCell in tableView.visibleCells)
    {
        if (!oneTVCell.selected && [oneTVCell isKindOfClass:[FloundsTVCell class]])
        {
            FloundsTVCell *oneFloundsTVCell = (FloundsTVCell *)oneTVCell;
            [visibleUnselectedCells addObject:oneFloundsTVCell];
        }
    }
    [visibleUnselectedCells makeObjectsPerformSelector:@selector(animateCellForNonSelection)];
}

@end
