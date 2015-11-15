//
//  FloundsVCBase.m
//  Flounds
//
//  Created by Paul M Rest on 8/31/15.
//  Copyright (c) 2015 Paul Rest. All rights reserved.
//

#import "FloundsVCBase.h"


@implementation FloundsVCBase

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        self.showGeneralErrorOnViewWillAppear = NO;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.defaultBackgroundColor = [FloundsViewConstants getDefaultBackgroundColor];
    self.view.backgroundColor = self.defaultBackgroundColor;
    for (UIView *oneSubview in self.view.subviews)
    {
        oneSubview.backgroundColor = self.defaultBackgroundColor;
    }
    [self calculateFloundsButtonFont];
    
    self.defaultUIColor = [FloundsViewConstants getDefaultTextColor];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.presentingVC)
    {
        [self.presentingVC removeAnimationsFromPresentingVC];
    }
}

-(void)calculateFloundsButtonFont
{
    CGFloat allFloundsButtonHeight = self.view.frame.size.height * [FloundsViewConstants getAllFloundsButtonHeightSizingFactor];
    
    CGFloat fullWidthHeightBasedFontPointSize = allFloundsButtonHeight -
                                        (allFloundsButtonHeight * [FloundsViewConstants getFloundsButtonFontFramePaddingFactor]);

    self.fullWidthFloundsButtonFont = [UIFont fontWithName:[FloundsViewConstants getDefaultFontFamilyName]
                                                      size:fullWidthHeightBasedFontPointSize];
    
    CGFloat nonFullWidthFontPointSize = fullWidthHeightBasedFontPointSize * [FloundsViewConstants getnonFullWidthFloundsButtonAndTVCellFontSizeFactor];
    
    self.nonFullWidthFloundsButtonAndTVCellFont = [UIFont fontWithName:[FloundsViewConstants getDefaultFontFamilyName]
                                                         size:nonFullWidthFontPointSize];
}

-(IBAction)unwindToParentVC:(UIStoryboardSegue *)segue
{
    //empty implementation
}

-(void)removeAnimationsFromPresentingVC
{
    for (UIView *oneSubview in self.view.subviews)
    {
        [oneSubview.layer removeAllAnimations];
    }
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
    [[self getVisibleNonSelectedCellsFor:tableView] makeObjectsPerformSelector:@selector(animateCellForNonSelection)];
}

-(NSArray *)getVisibleNonSelectedCellsFor:(UITableView *)tableView
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
    return [NSArray arrayWithArray:visibleUnselectedCells];
}

-(void)presentGeneralErrorAlert
{
    NSString *generalAlertTitle = NSLocalizedString(@"An Error Occurred", nil);
    NSString *generalAlertMessage = NSLocalizedString(@"Please restart the app. If the error persists please contact the developer.", nil);
    UIAlertController *generalAlert = [UIAlertController alertControllerWithTitle:generalAlertTitle
                                                                          message:generalAlertMessage
                                                                   preferredStyle:UIAlertControllerStyleAlert];
    
    NSString *okayActionButtonTitle = NSLocalizedString(@"Okay", nil);
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:okayActionButtonTitle style:UIAlertActionStyleDefault handler:NULL];
    
    [generalAlert addAction:okayAction];
    
    [self presentViewController:generalAlert
                       animated:YES
                     completion:NULL];
}

@end
