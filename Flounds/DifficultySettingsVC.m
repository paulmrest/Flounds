//
//  DifficultySettingsVC.m
//  Flounds
//
//  Created by Paul Rest on 10/27/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "DifficultySettingsVC.h"

static NSString *STARTING_SHAPES_LABEL = @"Starting shapes: ";

static NSString *DIFFICULTY_LEVEL_LABEL = @"Difficulty level: ";

@interface DifficultySettingsVC ()

@property (nonatomic, strong) FloundsModel *tryItFloundsModel;


@property (nonatomic) NSInteger initStartingShapes;

@property (nonatomic) NSInteger currStartingShapes;


@property (nonatomic) NSInteger initDifficultyLevel;

@property (nonatomic) NSInteger currDifficultyLevel;


@end


@implementation DifficultySettingsVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.initStartingShapes = self.floundsModel.numberOfStartingShapes;
    self.currStartingShapes = self.initStartingShapes;
    self.startShapesLabel.text = [STARTING_SHAPES_LABEL stringByAppendingFormat:@"%ld", (long)self.currStartingShapes];
    
    self.initDifficultyLevel = self.floundsModel.difficultyLevel;
    self.currDifficultyLevel = self.initDifficultyLevel;
    self.levelLabel.text = [DIFFICULTY_LEVEL_LABEL stringByAppendingFormat:@"%ld", (long)self.currDifficultyLevel];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.setButton.containingVC = self;
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.setButton];
    
    self.tryAndCancelTrialButton.containingVC = self;
    [FloundsAppearanceUtility addDefaultFloundsSublayerToView:self.tryAndCancelTrialButton];
    
    [self.startingShapesSlider setValue:self.currStartingShapes animated:YES];
    [self.difficultyLevelSlider setValue:self.currDifficultyLevel animated:YES];
    
    self.startingShapesSlider.updateSuperView = self;
    self.difficultyLevelSlider.updateSuperView = self;
    
    [self updateView];
    [self.view layoutIfNeeded];
}

-(IBAction)startingShapesSliderValueChange:(SnapTickSlider *)sender
{
    NSInteger startingShapesSliderValue = roundf(sender.value);
    if (startingShapesSliderValue != self.currStartingShapes)
    {
        self.startShapesLabel.text = [STARTING_SHAPES_LABEL stringByAppendingFormat:@"%ld", (long)startingShapesSliderValue];
        //>>>
//        NSLog(@"DifficultySettingsVC - startingShapesSliderValueChange:");
//        NSLog(@"self.startShapes.text: %@", self.startShapesLabel.text);
        //<<<
        self.currStartingShapes = startingShapesSliderValue;
    }
}

-(IBAction)difficultyLevelSliderValueChange:(SnapTickSlider *)sender
{
    NSInteger difficultySliderValue = roundf(sender.value);
    if (difficultySliderValue != self.currDifficultyLevel)
    {
        self.levelLabel.text = [DIFFICULTY_LEVEL_LABEL stringByAppendingFormat:@"%ld", (long)difficultySliderValue];
        //>>>
//        NSLog(@"DifficultySettingsVC - difficultyLevelSliderValueChange:");
//        NSLog(@"self.levelLabel.text: %@", self.levelLabel.text);
        //<<<
        self.currDifficultyLevel = difficultySliderValue;
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TryFloundsSplash"])
    {
        if ([segue.destinationViewController isKindOfClass:[TryFloundsSplashVC class]])
        {
            TryFloundsSplashVC *tryFloundsVC = (TryFloundsSplashVC *)segue.destinationViewController;
            tryFloundsVC.unwindFromTryItDelegate = self;
            
            self.tryItFloundsModel = [[FloundsModel alloc] init];
            self.tryItFloundsModel.numberOfStartingShapes = self.currStartingShapes;
            self.tryItFloundsModel.difficultyLevel = self.currDifficultyLevel;

            tryFloundsVC.tryItFloundsModel = self.tryItFloundsModel;
        }
    }
}

- (IBAction)setAndUnwind:(id)sender
{
    NSInteger startingShapesValue = roundf(self.startingShapesSlider.value);
    BOOL numOfStartingShapesSaved = YES;
    if (self.initStartingShapes != startingShapesValue)
    {
        numOfStartingShapesSaved = [self.floundsModel setNumberOfStartingShapesFromSettings:startingShapesValue];
    }
    
    NSInteger difficultyValue = roundf(self.difficultyLevelSlider.value);
    BOOL startingDifficultyLevelSaved = YES;
    if (self.initDifficultyLevel != difficultyValue)
    {
        startingDifficultyLevelSaved = [self.floundsModel setDifficultyLevelFromSettings:difficultyValue];
    }
    
    if (numOfStartingShapesSaved && startingDifficultyLevelSaved)
    {
        if ([sender isKindOfClass:[FloundsButton class]])
        {
            FloundsButton *floundsSetButton = (FloundsButton *)sender;
            self.unwindActivatingButton = floundsSetButton;
            [floundsSetButton animateForPushDismissCurrView];
        }
    }
    else
    {
        //>>>
        if (!numOfStartingShapesSaved)
        {
            NSLog(@"FloundsModel was not able to save new startingShapesValue");
        }
        else
        {
            NSLog(@"FloundsModel was not able to save new difficultyValue");
        }
        //<<<
    }
}

-(void)updateView
{
    //>>>
//    NSLog(@"DifficultySettingVC - updateView");
    //<<<
    if (self.currDifficultyLevel != self.floundsModel.difficultyLevel ||
        self.currStartingShapes != self.floundsModel.numberOfStartingShapes)
    {
        self.setButton.alpha = 1.0;
    }
    else
    {
        self.setButton.alpha = 0.5;
    }
}

-(void)dismissTryItFloundsSplashScreen
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
