//
//  DifficultySettingsVC.m
//  Flounds
//
//  Created by Paul Rest on 10/27/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "DifficultySettingsVC.h"

const CGFloat LABEL_FONT_TO_NON_FULL_WIDTH_FLOUNDS_BUTTON_AND_TV_CELL_FONT_SCALE_FACTOR = 0.75f;

NSString *STARTING_SHAPES_SLIDER_ID = @"StartingShapes";

NSString *DIFFICULTY_LEVEL_SLIDER_ID = @"DifficultyLevel";

NSString *STARTING_SHAPES_SLIDER_LABEL;

NSString *DIFFICULTY_LEVEL_SLIDER_LABEL;

NSString *CURR_VALUE_STARTING_SHAPES_LABEL;

NSString *CURR_VALUE_DIFFICULTY_LEVEL_LABEL;

@interface DifficultySettingsVC ()

@property (nonatomic, strong) FloundsModel *tryItFloundsModel;


@property (nonatomic) NSInteger initStartingShapes;

@property (nonatomic) NSInteger currStartingShapes;


@property (nonatomic) NSInteger initDifficultyLevel;

@property (nonatomic) NSInteger currDifficultyLevel;

@property (nonatomic, strong) UIFont *labelFont;


@end


@implementation DifficultySettingsVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    CURR_VALUE_STARTING_SHAPES_LABEL = NSLocalizedString(@"Starting shapes: ", nil);
    CURR_VALUE_DIFFICULTY_LEVEL_LABEL = NSLocalizedString(@"Difficulty level: ", nil);
    
    STARTING_SHAPES_SLIDER_LABEL = NSLocalizedString(@"Number of Starting Shapes", nil);
    DIFFICULTY_LEVEL_SLIDER_LABEL = NSLocalizedString(@"Difficulty Level", nil);
    
    [self calculateLabelFontSize];
    
    self.startingShapesSliderLabel.textColor = self.defaultUIColor;
    self.startingShapesSliderLabel.font = self.labelFont;
    self.startingShapesSliderLabel.text = STARTING_SHAPES_SLIDER_LABEL;
    
    self.initStartingShapes = self.floundsModel.numberOfStartingShapes;
    self.currStartingShapes = self.initStartingShapes;
    
    self.startShapesLabel.textColor = self.defaultUIColor;
    self.startShapesLabel.font = self.labelFont;
    self.startShapesLabel.text = [CURR_VALUE_STARTING_SHAPES_LABEL stringByAppendingFormat:@"%ld", (long)self.currStartingShapes];
    
    self.difficultyLevelSliderLabel.textColor = self.defaultUIColor;
    self.difficultyLevelSliderLabel.font = self.labelFont;
    self.difficultyLevelSliderLabel.text = DIFFICULTY_LEVEL_SLIDER_LABEL;
    
    self.initDifficultyLevel = self.floundsModel.difficultyLevel;
    self.currDifficultyLevel = self.initDifficultyLevel;
    
    self.levelLabel.textColor = self.defaultUIColor;
    self.levelLabel.font = self.labelFont;
    self.levelLabel.text = [CURR_VALUE_DIFFICULTY_LEVEL_LABEL stringByAppendingFormat:@"%ld", (long)self.currDifficultyLevel];
    
    self.setButton.titleLabel.font = self.nonFullWidthFloundsButtonAndTVCellFont;
    self.tryItButton.titleLabel.font = self.nonFullWidthFloundsButtonAndTVCellFont;
    
    self.setButton.containingVC = self;
    self.tryItButton.containingVC = self;
}

-(void)calculateLabelFontSize
{
    CGFloat labelFontPontSize = self.nonFullWidthFloundsButtonAndTVCellFont.pointSize * LABEL_FONT_TO_NON_FULL_WIDTH_FLOUNDS_BUTTON_AND_TV_CELL_FONT_SCALE_FACTOR;
    
    self.labelFont = [UIFont fontWithName:[FloundsViewConstants getDefaultFontFamilyName] size:labelFontPontSize];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.startingShapesSlider.sliderKeyID = STARTING_SHAPES_SLIDER_ID;
    self.difficultyLevelSlider.sliderKeyID = DIFFICULTY_LEVEL_SLIDER_ID;
    
    self.startingShapesSlider.updateSuperView = self;
    self.difficultyLevelSlider.updateSuperView = self;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //we animate the setValue selector for our two SnapTickSliders in viewDidLayoutSubviews not for the initial load of the VC,
    //but when the user moves the slider updateSuperWithValue is called, which calls setNeedsLayout
    [self.startingShapesSlider setValue:self.currStartingShapes animated:YES];
    [self.difficultyLevelSlider setValue:self.currDifficultyLevel animated:YES];
    
    [self updateView];
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
    [self.view setNeedsLayout];
}

-(void)startingShapesSliderValueChange:(CGFloat)sliderValue
{
    NSInteger startingShapesSliderValue = roundf(sliderValue);
    if (startingShapesSliderValue != self.currStartingShapes)
    {
        self.startShapesLabel.text = [CURR_VALUE_STARTING_SHAPES_LABEL stringByAppendingFormat:@"%ld", (long)startingShapesSliderValue];
        self.currStartingShapes = startingShapesSliderValue;
    }
}

-(void)difficultyLevelSliderValueChange:(CGFloat)sliderValue
{
    NSInteger difficultySliderValue = roundf(sliderValue);
    if (difficultySliderValue != self.currDifficultyLevel)
    {
        self.levelLabel.text = [CURR_VALUE_DIFFICULTY_LEVEL_LABEL stringByAppendingFormat:@"%ld", (long)difficultySliderValue];
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
            tryFloundsVC.labelFont = self.labelFont;
            
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
}

@end
