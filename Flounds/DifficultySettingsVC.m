//
//  DifficultySettingsVC.m
//  Flounds
//
//  Created by Paul Rest on 10/27/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "DifficultySettingsVC.h"

NSString *STARTING_SHAPES_SLIDER_ID = @"StartingShapes";

NSString *DIFFICULTY_LEVEL_SLIDER_ID = @"DifficultyLevel";

static NSString *STARTING_SHAPES_LABEL;

static NSString *DIFFICULTY_LEVEL_LABEL;

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
    
    STARTING_SHAPES_LABEL = NSLocalizedString(@"Starting shapes: ", nil);
    DIFFICULTY_LEVEL_LABEL = NSLocalizedString(@"Difficulty level: ", nil);
    
    self.initStartingShapes = self.floundsModel.numberOfStartingShapes;
    self.currStartingShapes = self.initStartingShapes;
    self.startShapesLabel.textColor = [FloundsViewConstants getDefaultTextColor];
    self.startShapesLabel.text = [STARTING_SHAPES_LABEL stringByAppendingFormat:@"%ld", (long)self.currStartingShapes];
    
    self.initDifficultyLevel = self.floundsModel.difficultyLevel;
    self.currDifficultyLevel = self.initDifficultyLevel;
    self.levelLabel.textColor = [FloundsViewConstants getDefaultTextColor];
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
    self.startingShapesSlider.sliderKeyID = STARTING_SHAPES_SLIDER_ID;
    [self.difficultyLevelSlider setValue:self.currDifficultyLevel animated:YES];
    self.difficultyLevelSlider.sliderKeyID = DIFFICULTY_LEVEL_SLIDER_ID;
    
    self.startingShapesSlider.updateSuperView = self;
    self.difficultyLevelSlider.updateSuperView = self;
    
    [self updateView];
    [self.view layoutIfNeeded];
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
    BOOL numOfStartingShapesSaved = YES;
    if (self.initStartingShapes != self.currStartingShapes)
    {
        numOfStartingShapesSaved = [self.floundsModel setNumberOfStartingShapesFromSettings:self.currStartingShapes];
    }
    
    BOOL startingDifficultyLevelSaved = YES;
    if (self.initDifficultyLevel != self.currDifficultyLevel)
    {
        startingDifficultyLevelSaved = [self.floundsModel setDifficultyLevelFromSettings:self.currDifficultyLevel];
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
        NSLog(@"DifficultySettingsVC - setAndUnwind...");
        NSLog(@"self.floundsModel was unable to save either starting shapes or difficulty level");
    }
}

-(void)updateSuperViewWithValue:(CGFloat)sliderValue
                 forSliderKeyID:(NSString *)sliderID
{
    if ([sliderID isEqualToString:STARTING_SHAPES_SLIDER_ID])
    {
        [self startingShapesSliderValueChange:sliderValue];
    }
    else if ([sliderID isEqualToString:DIFFICULTY_LEVEL_SLIDER_ID])
    {
        [self difficultyLevelSliderValueChange:sliderValue];
    }
    [self updateView];
}

-(void)startingShapesSliderValueChange:(CGFloat)sliderValue
{
    NSInteger startingShapesSliderValue = roundf(sliderValue);
    if (startingShapesSliderValue != self.currStartingShapes)
    {
        self.startShapesLabel.text = [STARTING_SHAPES_LABEL stringByAppendingFormat:@"%ld", (long)startingShapesSliderValue];
        self.currStartingShapes = startingShapesSliderValue;
    }
}

-(void)difficultyLevelSliderValueChange:(CGFloat)sliderValue
{
    NSInteger difficultySliderValue = roundf(sliderValue);
    if (difficultySliderValue != self.currDifficultyLevel)
    {
        self.levelLabel.text = [DIFFICULTY_LEVEL_LABEL stringByAppendingFormat:@"%ld", (long)difficultySliderValue];
        self.currDifficultyLevel = difficultySliderValue;
    }
}

-(void)updateView
{
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
