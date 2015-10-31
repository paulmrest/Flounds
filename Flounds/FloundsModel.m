//
//  FloundsModel.m
//  Flounds
//
//  Created by Paul Rest on 5/21/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "FloundsModel.h"


const double DIFFICUTLY_INCREMENT = 1.25;

const double DIFFICULTY_INCREMENT_INCREASE_FACTOR = 0.15;


const NSUInteger DEFAULT_DIFFICULTY_LEVEL = 1;

const NSUInteger DEFAULT_NUM_STARTING_SHAPES = 3;

const NSUInteger MIN_NUM_STARTING_SHAPES = 2;

const NSUInteger MAX_NUM_STARTING_SHAPES = 8;


@interface FloundsModel ()

@property (nonatomic, strong) NSFileManager *fileManager;

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nonatomic, strong) NSArray *currentSequence;

@property (nonatomic, readwrite) NSUInteger currNumberOfShapes;

@end


@implementation FloundsModel

-(id)initWithUserSettings
{
    self = [self init];
    if (self)
    {
        [self numberOfStartingShapes];
        [self difficultyLevel];
    }
    return self;
}

-(id)initWithSystemDefaults
{
    self = [self init];
    if (self)
    {
        _numberOfStartingShapes = DEFAULT_NUM_STARTING_SHAPES;
        _difficultyLevel = DEFAULT_DIFFICULTY_LEVEL;
    }
    return self;    
}

-(id)init
{
    self = [super init];
    if (self)
    {
        self.currNumberOfShapes = 0;
    }
    return self;
}

-(NSFileManager *)fileManager
{
    if (!_fileManager)
    {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

-(NSUserDefaults *)userDefaults
{
    if (!_userDefaults)
    {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

NSString *kDefaultNumberOfShapesUserDefaultsKey = @"defaultNumberOfStartingShapes";

NSString *kNumberOfStartingShapesKey = @"numberOfStartingShapes";

-(BOOL)setNumberOfStartingShapesFromSettings:(NSUInteger)numberOfShapes
{
    if (numberOfShapes >= MIN_NUM_STARTING_SHAPES && numberOfShapes <= MAX_NUM_STARTING_SHAPES
        && self.numberOfStartingShapes != numberOfShapes)
    {
        self.numberOfStartingShapes = numberOfShapes;
        [self.userDefaults setInteger:numberOfShapes forKey:kNumberOfStartingShapesKey];
        return [self.userDefaults synchronize];
    }
    return NO;
}

-(NSUInteger)numberOfStartingShapes
{
    if (_numberOfStartingShapes < MIN_NUM_STARTING_SHAPES || _numberOfStartingShapes > MAX_NUM_STARTING_SHAPES)
    {
        NSUInteger numberOfStartingShapesFromUserDefaults = [self.userDefaults integerForKey:kNumberOfStartingShapesKey];
        if (numberOfStartingShapesFromUserDefaults != _numberOfStartingShapes &&
            numberOfStartingShapesFromUserDefaults >= MIN_NUM_STARTING_SHAPES &&
            numberOfStartingShapesFromUserDefaults <= MAX_NUM_STARTING_SHAPES)
        {
            _numberOfStartingShapes = numberOfStartingShapesFromUserDefaults;
        }
        else
        {
            _numberOfStartingShapes = DEFAULT_NUM_STARTING_SHAPES;
        }
    }
    return _numberOfStartingShapes;
}


NSString *kDifficultyLevelKey = @"difficultyLevelKey";

-(NSUInteger)difficultyLevel
{
    if (_difficultyLevel == 0)
    {
        NSUInteger startingDifficultyLevelFromUserDefaults = [self.userDefaults integerForKey:kDifficultyLevelKey];
        if (startingDifficultyLevelFromUserDefaults >= DEFAULT_DIFFICULTY_LEVEL)
        {
            _difficultyLevel = startingDifficultyLevelFromUserDefaults;
        }
        else
        {
            _difficultyLevel = DEFAULT_DIFFICULTY_LEVEL;
        }
    }
    return _difficultyLevel;
}

-(BOOL)setDifficultyLevelFromSettings:(NSUInteger)difficultyLevel
{
    if (difficultyLevel != self.difficultyLevel)
    {
        self.difficultyLevel = difficultyLevel;
        [self.userDefaults setInteger:difficultyLevel forKey:kDifficultyLevelKey];
        return [self.userDefaults synchronize];
    }
    return NO;
}

-(BOOL)checkForMatchGiven:(NSArray *)userSequence
{
    if ([userSequence count] == [self.currentSequence count])
    {
        for (NSUInteger index = 0; index < [userSequence count]; index++)
        {
            NSNumber *userSequenceShapeIDAtGivenIndex = [userSequence objectAtIndex:index];
            NSNumber *currSequenceShapeIDAtGivenIndex = [self.currentSequence objectAtIndex:index];
            if (![userSequenceShapeIDAtGivenIndex isEqualToNumber:currSequenceShapeIDAtGivenIndex])
            {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

-(NSArray *)getNewStartingSequence
{
    self.currNumberOfShapes = self.numberOfStartingShapes;
    return [self generateSequence];
}

//-(NSArray *)clearCurrentAndGetNewMatchingSequence
//{
//    self.currentSequence = nil;
//    return [self getNewStartingSequence];
//}

-(NSArray *)getCurrSequence
{
    if ([self.currentSequence count] == self.currNumberOfShapes)
    {
        return [NSArray arrayWithArray:self.currentSequence];
    }
    else
    {
        return [self generateSequence];
    }
}

-(void)incrementDifficultyLevel
{
    double shapeIncreaseFactor = DIFFICUTLY_INCREMENT + ((self.difficultyLevel - 1.0) * DIFFICULTY_INCREMENT_INCREASE_FACTOR);
    double tempDoubleNumberOfShapes = (double)self.currNumberOfShapes * shapeIncreaseFactor;
    if ((int)tempDoubleNumberOfShapes == self.currNumberOfShapes)
    {
        tempDoubleNumberOfShapes = tempDoubleNumberOfShapes + 1.0;
    }
    self.currNumberOfShapes = (int)tempDoubleNumberOfShapes;
}

-(void)setNewSequenceForSnoozeCount:(NSUInteger)snoozeCount
{
    //>>>
//    NSLog(@"FloundsModel - setNewSequenceForSnoozeCount...");
//    NSLog(@"snoozeCount: %lu", snoozeCount);
    //<<<
    self.currNumberOfShapes = self.numberOfStartingShapes;
    for (NSUInteger i = 0; i < snoozeCount; i++)
    {
        //>>>
//        NSLog(@"incrementing difficulty loop: %lu", i);
        //<<<
        [self incrementDifficultyLevel];
    }
    [self generateSequence];
}

-(NSArray *)incrementDifficultyAndGetNewSequence
{
    [self incrementDifficultyLevel];
    return [self generateSequence];
}

-(NSArray *)generateSequence
{
    //>>>
//    NSLog(@"FloundsModel - generateSequence");
//    NSLog(@"self.currNumberOfShapes: %lu", self.currNumberOfShapes);
    //<<<
    NSMutableArray *arrayToPullFrom = [self getMutableArrayOfShapeIDs];
    
    NSMutableArray *tempBuildingArray = [[NSMutableArray alloc] initWithCapacity:self.currNumberOfShapes];
    for (NSUInteger i = 1; i <= self.currNumberOfShapes; i++)
    {
        NSUInteger randomShapeIDIndex = arc4random_uniform((unsigned int)[arrayToPullFrom count]);
        NSNumber *randomShapeID = [arrayToPullFrom objectAtIndex:randomShapeIDIndex];
        [arrayToPullFrom removeObjectAtIndex:randomShapeIDIndex];
        [tempBuildingArray addObject:randomShapeID];
    }
    //>>>
//    NSLog(@"tempBuildingArray: %@", tempBuildingArray);
//    NSLog(@"arrayToPullFrom count: %d", [arrayToPullFrom count]);
    //<<<
    self.currentSequence = tempBuildingArray;
    return [NSArray arrayWithArray:tempBuildingArray];
}

-(NSMutableArray *)getMutableArrayOfShapeIDs
{
    NSMutableArray *arrayOfShapeIDs = [[NSMutableArray alloc] initWithCapacity:self.currNumberOfShapes];
    for (NSUInteger i = 0; i < self.currNumberOfShapes; i++)
    {
        [arrayOfShapeIDs addObject:[NSNumber numberWithUnsignedInteger:i]];
    }
    return arrayOfShapeIDs;
}

@end
