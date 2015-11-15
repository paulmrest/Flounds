//
//  FloundsModel.h
//  Flounds
//
//  Created by Paul Rest on 5/21/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloundsModel : NSObject

@property (nonatomic, readonly) NSUInteger currNumberOfShapes;

@property (nonatomic) NSUInteger numberOfStartingShapes;

@property (nonatomic) NSUInteger difficultyLevel;


-(id)initWithUserSettings;

-(id)initWithSystemDefaults;


-(NSArray *)incrementDifficultyAndGetNewSequence;

-(void)setNewSequenceForSnoozeCount:(NSUInteger)snoozeCount;


-(BOOL)setNumberOfStartingShapesFromSettings:(NSUInteger)numberOfShapes;

-(BOOL)setDifficultyLevelFromSettings:(NSUInteger)difficultyLevel;


-(NSArray *)getNewStartingSequence;

-(NSArray *)getCurrSequence;


-(BOOL)checkForMatchGiven:(NSArray *)userSequence;

@end
