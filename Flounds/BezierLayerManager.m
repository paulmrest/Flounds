//
//  BezierLayerManager.m
//  Flounds
//
//  Created by Paul Rest on 12/28/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.


#import "BezierLayerManager.h"

NSString *SEGREGATED_LAYER_COPY_ANIMATION = @"SegregatedLayerCopyAnimation";

const NSUInteger ANIMATION_TIMER_SEQUENCE_KEY_LENGTH = 8;

const NSUInteger CALAYER_KEY_LENGTH = 8;

@interface BezierLayerManager ()

@property (nonatomic, strong) NSArray *shapeLayersWithCopies; //array of arrays, where each subarray has
                                                              //BezierShapeLayer.copyID == 0 at index position 0,
                                                              //copyID == 1 at index 1, etc...

//static array that contains all BezierShapeLayer layerAnimationKeys
@property (nonatomic, strong) NSArray *layerAnimationKeyArray;

//tracking array that adds each BezierShapeLayer's layerAnimationKey when that layer is being animated,
//then removes that layerAnimationKey in CAAnimation's delegate method animationDidStop, when
//[self.layerAnimationKeyTracking count] == 0 then the next animation is queued up, assuming
//[self.animationKeysInOrder count] > 0
@property (nonatomic, strong) NSMutableArray *layerAnimationKeyTracker;


@property (nonatomic, strong) NSMutableDictionary *animationClustersAndKeys;

@property (nonatomic, strong) NSMutableDictionary *timerIntervalsAndKeys;

@property (nonatomic, strong) NSMutableDictionary *shapeIDSequencesAndKeys;

@property (nonatomic, strong) NSMutableArray *animationKeysInOrder; //next animation in queue is always at index 0


@property (nonatomic, strong, readwrite) NSArray *shapeLayersAndCopiesForDisplay;

@property (nonatomic, strong, readwrite) NSArray *baseShapeLayers;

@end


@implementation BezierLayerManager

-(id)initWithBezierShapes:(NSArray *)bezierShapes
      withAnimationCopies:(NSUInteger)copiesForAnimation
{
    self = [super init];
    if (self)
    {        
        self.layerCopiesNeeded = copiesForAnimation;
        self.removeDelegateSublayersOnAnimationQueueCompletion = NO;
        
        if (bezierShapes && [bezierShapes count] > 0)
        {
            NSMutableArray *tempBuildingLayerKeys = [[NSMutableArray alloc] initWithCapacity:
                                                     ([bezierShapes count] * copiesForAnimation)];
            
            //building array for array of arrays that will be self.shapeLayersWithCopies
            NSMutableArray *tempBldShapesArray = [[NSMutableArray alloc] initWithCapacity:[bezierShapes count]];
            for (BezierShape *oneShape in bezierShapes)
            {
                //building array for sub array to be added to self.shapeLayersWithCopies
                NSMutableArray *tempBldSubArray = [[NSMutableArray alloc] initWithCapacity:copiesForAnimation];
                
                BezierShapeLayer *newBaseLayer = [BezierShapeLayer layer];
                newBaseLayer.bezierShape = oneShape;
                newBaseLayer.strokeColor = oneShape.strokeColor;
                newBaseLayer.frame = oneShape.confiningRect;
                newBaseLayer.shapeID = oneShape.shapeID;
                newBaseLayer.copyID = 0;
                
                NSString *baseLayerStringKey = [self getLayerKeyOfLength:CALAYER_KEY_LENGTH];
                newBaseLayer.layerAnimationKey = baseLayerStringKey;
                [tempBuildingLayerKeys addObject:baseLayerStringKey];
                
                [tempBldSubArray addObject:newBaseLayer]; //baseLayer will always be at index 0
                
                //build copies of layers for animation
                for (int i = 1; i < copiesForAnimation; i++)
                {
                    BezierShapeLayer *newLayerCopy = [BezierShapeLayer layer];
                    newLayerCopy.bezierShape = oneShape;
                    newLayerCopy.strokeColor = oneShape.strokeColor;
                    newLayerCopy.frame = oneShape.confiningRect;
                    newLayerCopy.shapeID = oneShape.shapeID;
                    newLayerCopy.copyID = i + 1;
                    
                    NSString *newLayerCopyStringKey = [self getLayerKeyOfLength:CALAYER_KEY_LENGTH];
                    newLayerCopy.layerAnimationKey = newLayerCopyStringKey;
                    [tempBuildingLayerKeys addObject:newLayerCopyStringKey];
                    
                    [tempBldSubArray addObject:newLayerCopy];
                }
                
                //add sub array to building array
                [tempBldShapesArray addObject:[NSArray arrayWithArray:tempBldSubArray]];
            }
            self.shapeLayersWithCopies = [NSArray arrayWithArray:tempBldShapesArray];
            self.layerAnimationKeyArray = [NSArray arrayWithArray:tempBuildingLayerKeys];
        }
        [self shapeLayersAndCopiesForDisplay];
        [self baseShapeLayers];
    }
    return self;
}

-(NSMutableArray *)layerAnimationKeyTracker
{
    if (!_layerAnimationKeyTracker)
    {
        _layerAnimationKeyTracker = [[NSMutableArray alloc] initWithCapacity:[self.layerAnimationKeyArray count]];
    }
    return _layerAnimationKeyTracker;
}

-(NSMutableDictionary *)animationClustersAndKeys
{
    if (!_animationClustersAndKeys)
    {
        _animationClustersAndKeys = [[NSMutableDictionary alloc] init];
    }
    return _animationClustersAndKeys;
}

-(NSMutableDictionary *)timerIntervalsAndKeys
{
    if (!_timerIntervalsAndKeys)
    {
        _timerIntervalsAndKeys = [[NSMutableDictionary alloc] init];
    }
    return _timerIntervalsAndKeys;
}

-(NSMutableDictionary *)shapeIDSequencesAndKeys
{
    if (!_shapeIDSequencesAndKeys)
    {
        _shapeIDSequencesAndKeys = [[NSMutableDictionary alloc] init];
    }
    return _shapeIDSequencesAndKeys;
}

-(NSMutableArray *)animationKeysInOrder
{
    if (!_animationKeysInOrder)
    {
        _animationKeysInOrder = [[NSMutableArray alloc] init];
    }
    return _animationKeysInOrder;
}

-(NSArray *)shapeLayersAndCopiesForDisplay
{
    if (!_shapeLayersAndCopiesForDisplay)
    {
        NSMutableArray *tempBldArray = [[NSMutableArray alloc] initWithCapacity:[self.layerAnimationKeyArray count]];
        for (NSArray *oneLayerClusterArray in self.shapeLayersWithCopies)
        {
            //doesn't matter which order self.shapeLayersAndCopiesForDisplay is in
            for (BezierShapeLayer *oneShapeLayer in oneLayerClusterArray)
            {
                [tempBldArray addObject:oneShapeLayer];
            }
        }
        _shapeLayersAndCopiesForDisplay = [NSArray arrayWithArray:tempBldArray];
    }
    return _shapeLayersAndCopiesForDisplay;
}

-(NSArray *)baseShapeLayers
{
    if (!_baseShapeLayers)
    {
        NSMutableArray *tempBuildingArray = [[NSMutableArray alloc] initWithCapacity:[self.shapeLayersWithCopies count]];
        for (NSArray *oneShapeSubArray in self.shapeLayersWithCopies)
        {
            BezierShapeLayer *oneBezierShapeBaseLayer = [oneShapeSubArray objectAtIndex:0];
            [tempBuildingArray addObject:oneBezierShapeBaseLayer];
        }
        _baseShapeLayers = [NSArray arrayWithArray:tempBuildingArray];
    }
    return _baseShapeLayers;
}

-(void)directlyAnimateShape:(NSUInteger)shapeID
              withAnimation:(CAAnimation *)animation
{
    if ([self shapeIDIsValid:shapeID])
    {
        NSArray *oneShapeLayerSubArray = [self.shapeLayersWithCopies objectAtIndex:shapeID];
        for (BezierShapeLayer *oneShapeLayer in oneShapeLayerSubArray)
        {
            [oneShapeLayer addAnimation:animation forKey:nil];
        }
    }
}

-(void)queueOneAnimationForAllShapes:(CAAnimation *)animation
                        withSequence:(NSArray *)shapeIDSequence
                       timerInterval:(NSTimeInterval)timerInterval
{
    NSMutableArray *animationClusters = [[NSMutableArray alloc] initWithCapacity:[self.baseShapeLayers count]];
    for (BezierShapeLayer *oneBaseLayer in self.baseShapeLayers)
    {
        CAAnimationCluster *newAnimationCluster = [[CAAnimationCluster alloc] initWithOneAnimationForCluster:animation
                                                                                              forLayerCopies:self.layerCopiesNeeded
                                                                                                  forShapeID:oneBaseLayer.shapeID];
        newAnimationCluster.timerInterval = 0.0;
        [animationClusters addObject:newAnimationCluster];
    }
    
    [self queueAnimationClusters:animationClusters
                    withSequence:shapeIDSequence
                   timerInterval:timerInterval];
}

-(void)queueAnimation:(CAAnimation *)animation
           forShapeID:(NSUInteger)shapeID
{
    CAAnimationCluster *newAnimationCluster = [[CAAnimationCluster alloc] initWithOneAnimationForCluster:animation
                                                                                          forLayerCopies:self.layerCopiesNeeded
                                                                                              forShapeID:shapeID];
    newAnimationCluster.timerInterval = 0.0;
    [self queueAnimationClusters:@[newAnimationCluster]
                    withSequence:nil
                   timerInterval:0.0];
}

-(void)queueAnimationClusters:(NSArray *)animationClusters
                 withSequence:(NSArray *)shapeIDSequence
                timerInterval:(NSTimeInterval)timerInterval
{
    if ([animationClusters count] > 0)
    {
        [self addSelfAsDelegateForAnimationCluster:animationClusters];
        NSString *animationKey = [self getAnimationKeyOfLength:ANIMATION_TIMER_SEQUENCE_KEY_LENGTH];
        [self.animationKeysInOrder addObject:animationKey];
        [self.animationClustersAndKeys setObject:animationClusters forKey:animationKey];
        if (timerInterval > 0.0)
        {
            [self queueShapeIDSequence:shapeIDSequence
                      andTimerInterval:timerInterval
                                forKey:animationKey];
        }
    }
}

-(void)queueShapeIDSequence:(NSArray *)shapeIDSequence
           andTimerInterval:(NSTimeInterval)timerInterval
                     forKey:(NSString *)layerAnimationKey
{
    [self.timerIntervalsAndKeys setObject:[NSNumber numberWithDouble:timerInterval] forKey:layerAnimationKey];
    
    //We could have two separate if (condition) statements here, one that checks for [shapeIdSequence count] == 0
    //and generates a completely new random sequence, and one that checks for
    //[shapeIDSequence count] != [self.shapeLayersWithCopies count] and either truncates the shapeIDSequence
    //if > [self.shapeLayersWithCopies count] or appends it if < [self.shapeLayersWithCopies count] with a randomly generated
    //sequence from what shapeIDs aren't in shapeIDSequence, HOWEVER: in both of these cases we don't know what the
    //client intended; ie, if [shapeIDSequence count] > [self.shapeLayersWithCopies count] then we have no idea which part
    //the client meant to be the sequence and which part should be truncated.
    //With all of that said, it makes more sense to simply throw out the entire paramter shapeIDSequence and build
    //a new random sequence from scratch in all these cases
    if (!shapeIDSequence ||
        [shapeIDSequence count] != [self.shapeLayersWithCopies count] ||
        ![self sequenceIsValid:shapeIDSequence])
    {
        //generate random sequence to use below
        shapeIDSequence = [self getRandomIDSequence];
    }
    [self.shapeIDSequencesAndKeys setObject:shapeIDSequence forKey:layerAnimationKey];
}

-(void)addSelfAsDelegateForAnimationCluster:(NSArray *)animationClusters
{
    for (CAAnimationCluster *oneAnimationCluster in animationClusters)
    {
        for (CAAnimation *oneAnimation in oneAnimationCluster.animations)
        {
            oneAnimation.delegate = self;
        }
    }
}

-(BOOL)shapeIDIsValid:(NSUInteger)shapeID
{
    for (NSArray *oneSubArray in self.shapeLayersWithCopies)
    {
        BezierShapeLayer *anyBezierLayer = [oneSubArray lastObject];
        if (anyBezierLayer.shapeID == shapeID)
        {
            return YES;
        }
    }
    return NO;
}

-(BOOL)sequenceIsValid:(NSArray *)sequence
{
    //check whether param sequence is valid given shapeIDs in self.shapeLayersWithCopies
    //does this by checking whether each shapeID is used exactly once
    
    //build array to check against
    NSMutableArray *shapeIDsChecker = [NSMutableArray arrayWithCapacity:[self.shapeLayersWithCopies count]];
    for (NSArray *oneShapeSubArray in self.shapeLayersWithCopies)
    {
        BezierShapeLayer *oneShapeLayer = [oneShapeSubArray lastObject];
        NSUInteger shapeID = oneShapeLayer.shapeID;
        [shapeIDsChecker addObject:[NSNumber numberWithInteger:shapeID]];
    }
    
    //use above constructed array to check param sequence
    if ([shapeIDsChecker count] == [sequence count])
    {
        for (NSNumber *shapeIDNumber in sequence)
        {
            NSInteger possibleID = [shapeIDNumber integerValue];
            if (possibleID >= 0 && possibleID <= [self.shapeLayersWithCopies count] + 1)
            {
                if ([self arrayOfNSNumbers:shapeIDsChecker contains:shapeIDNumber])
                {
                    NSUInteger indexToBeRemoved = [self indexValueOfNSNumber:shapeIDNumber inArray:shapeIDsChecker];
                    [shapeIDsChecker removeObjectAtIndex:indexToBeRemoved];
                }
            }
        }
    }
    if ([shapeIDsChecker count] == 0)
    {
        return YES;
    }
    return NO;
}

-(NSString *)getAnimationKeyOfLength:(NSUInteger)length
{
    NSString *potentialKey = [self getRandomStringOfLength:length];
    
    //check whether key already exists
    for (NSString *oneAnimationKey in self.animationKeysInOrder)
    {
        if ([potentialKey isEqualToString:oneAnimationKey])
        {
            //recurses until we find a key that does not already exist
            return [self getAnimationKeyOfLength:length];
        }
    }
    return potentialKey;
}

-(NSString *)getLayerKeyOfLength:(NSUInteger)length
{
    NSString *potentialKey = [self getRandomStringOfLength:length];
    
    //check whether key already exists
    for (NSString *oneLayerKey in self.layerAnimationKeyArray)
    {
        if ([potentialKey isEqualToString:oneLayerKey])
        {
            //recurses until we find a key that does not already exist
            return [self getLayerKeyOfLength:length];
        }
    }
    return potentialKey;
}

-(BOOL)arrayOfNSNumbers:(NSArray *)array
               contains:(NSNumber *)number
{
    for (NSNumber *oneNumber in array)
    {
        if ([oneNumber isEqualToNumber:number])
        {
            return YES;
        }
    }
    return NO;
}

-(NSUInteger)indexValueOfNSNumber:(NSNumber *)number
                          inArray:(NSArray *)array
{
    for (NSNumber *oneNumber in array)
    {
        if ([oneNumber isEqualToNumber:number])
        {
            return [array indexOfObject:oneNumber];
        }
    }
    return -1;
}

-(NSString *)getRandomStringOfLength:(NSUInteger)length
{
    NSString *characterString = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXZY0123456789";
    NSUInteger characterStringLength = [characterString length];
    NSMutableString *tempBuildingString = [NSMutableString stringWithCapacity:length];
    for (NSUInteger index = 0; index <= length; index++)
    {
        u_int32_t randomIndex = arc4random() % characterStringLength;
        unichar randomChar = [characterString characterAtIndex:randomIndex];
        [tempBuildingString appendFormat:@"%C", randomChar];
    }
    return [NSString stringWithString:tempBuildingString];
}

-(NSArray *)getRandomIDSequence
{
    NSMutableArray *tempBuildingArray = [[NSMutableArray alloc] initWithCapacity:[self.shapeLayersWithCopies count]];
    NSMutableArray *tempPullingArray = [NSMutableArray arrayWithArray:self.shapeLayersWithCopies];
    for (NSUInteger i = 0; i < [self.shapeLayersWithCopies count]; i++)
    {
        NSArray *randomSubArray = [tempPullingArray objectAtIndex:arc4random_uniform((int)[tempPullingArray count])];
        BezierShapeLayer *randomBezierShapeFromSubArray = [randomSubArray lastObject];
        NSNumber *randomUniqueID = [NSNumber numberWithInteger:randomBezierShapeFromSubArray.shapeID];
        [tempBuildingArray addObject:randomUniqueID];
        [tempPullingArray removeObject:randomSubArray];
    }
    return [NSArray arrayWithArray:tempBuildingArray];
}

-(void)startAnimationQueue
{
    NSString *nextAnimationKey = [self.animationKeysInOrder objectAtIndex:0];
    if (nextAnimationKey)
    {
        NSArray *animationClusters = [self.animationClustersAndKeys objectForKey:nextAnimationKey];
//        NSDictionary *dictionaryOfAnimationClusters = [self.dictionariesOfAnimationClustersAndKeys objectForKey:nextAnimationKey];
        NSNumber *timerIntervalNumber = [self.timerIntervalsAndKeys objectForKey:nextAnimationKey];
        NSTimeInterval timerInterval = timerIntervalNumber ? [timerIntervalNumber doubleValue] : 0.0;
        NSArray *sequence = [self.shapeIDSequencesAndKeys objectForKey:nextAnimationKey];

        [self.animationKeysInOrder removeObjectAtIndex:0];
        
        if (animationClusters)
        {
            if (sequence && timerInterval > 0.0)
            {
                [self animateShapesFromAnimationClusterOnTimer:animationClusters
                                           withShapeIDSequence:sequence
                                             withTimerInterval:timerInterval];
            }
            else
            {
                for (CAAnimationCluster *oneAnimationCluster in animationClusters)
                {
                    [self animateShapeFromAnimationCluster:oneAnimationCluster];
                }
            }
        }
        [self.animationClustersAndKeys removeObjectForKey:nextAnimationKey];
        [self.timerIntervalsAndKeys removeObjectForKey:nextAnimationKey];
        [self.shapeIDSequencesAndKeys removeObjectForKey:nextAnimationKey];
    }
}

NSString *SHAPE_ID_SEQUENCE_KEY_FOR_TIMER = @"shapeIDKey";

NSString *ANIMATION_CLUSTERS_KEY_FOR_TIMER = @"animationClustersKey";

-(void)animateShapesFromAnimationClusterOnTimer:(NSArray *)animationClusters
                            withShapeIDSequence:(NSArray *)sequence
                              withTimerInterval:(NSTimeInterval)timerInterval
{
    NSMutableArray *shapeIDSequenceForTimer = [NSMutableArray arrayWithArray:sequence];
    NSDictionary *sequenceAndAnimationClustersDictForTimer = @{SHAPE_ID_SEQUENCE_KEY_FOR_TIMER : shapeIDSequenceForTimer,
                                                               ANIMATION_CLUSTERS_KEY_FOR_TIMER : animationClusters};
    NSTimer *animationTimer = [NSTimer timerWithTimeInterval:timerInterval
                                                      target:self
                                                    selector:@selector(animateAllShapesOnTimerFromAnimationClusters:)
                                                    userInfo:sequenceAndAnimationClustersDictForTimer
                                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSDefaultRunLoopMode];
    [animationTimer fire];
}

-(void)animateAllShapesOnTimerFromAnimationClusters:(NSTimer *)timer
{
    if ([timer.userInfo isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *sequenceAndAnimationClusterDict = (NSDictionary *)timer.userInfo;
        NSMutableArray *shapeIDSequence = [sequenceAndAnimationClusterDict objectForKey:SHAPE_ID_SEQUENCE_KEY_FOR_TIMER];
        
        NSArray *animationClusters = [sequenceAndAnimationClusterDict objectForKey:ANIMATION_CLUSTERS_KEY_FOR_TIMER];
        
        NSNumber *nextShapeIDNumber = [shapeIDSequence objectAtIndex:0];
        NSUInteger nextShapeID = [nextShapeIDNumber integerValue];
        [shapeIDSequence removeObjectAtIndex:0];
        
        for (CAAnimationCluster *oneAnimationCluster in animationClusters)
        {
            if (oneAnimationCluster.shapeID == nextShapeID)
            {
                [self animateShapeFromAnimationCluster:oneAnimationCluster];
                break;
            }
        }
        
        if ([shapeIDSequence count] == 0)
        {
            [timer invalidate];
        }
    }
}

-(void)animateShapeFromAnimationCluster:(CAAnimationCluster *)animationCluster
{
    if (animationCluster.timerInterval > 0.0)
    {
        NSTimer *animationTimer = [NSTimer timerWithTimeInterval:animationCluster.timerInterval
                                                          target:self
                                                        selector:@selector(animateOneShapeOnTimerFromAnimationCluster:)
                                                        userInfo:animationCluster
                                                         repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:animationTimer forMode:NSDefaultRunLoopMode];
        [animationTimer fire];
    }
    else
    {
        NSMutableArray *shapeSubArrayToAnimate = [NSMutableArray arrayWithArray:[self.shapeLayersWithCopies objectAtIndex:animationCluster.shapeID]];
        for (CAAnimation *oneAnimation in animationCluster.animations)
        {
            BezierShapeLayer *oneShapeLayerToAnimate = [shapeSubArrayToAnimate lastObject];
            [self.layerAnimationKeyTracker addObject:oneShapeLayerToAnimate.layerAnimationKey];
            [oneShapeLayerToAnimate addAnimation:oneAnimation
                                          forKey:oneShapeLayerToAnimate.layerAnimationKey];
            [shapeSubArrayToAnimate removeLastObject];
        }
    }
}

-(void)animateOneShapeOnTimerFromAnimationCluster:(NSTimer *)timer
{
    if ([timer.userInfo isKindOfClass:[CAAnimationCluster class]])
    {
        CAAnimationCluster *animationCluster = (CAAnimationCluster *)timer.userInfo;
        NSMutableArray *animationsFromCluster = [NSMutableArray arrayWithArray:animationCluster.animations];
        
        NSArray *shapeSubArray = [self.shapeLayersWithCopies objectAtIndex:animationCluster.shapeID];
        
        NSUInteger shapeLayerToAnimateIndex = [shapeSubArray count] - [animationCluster.animations count];
        BezierShapeLayer *shapeLayerToAnimate = [shapeSubArray objectAtIndex:shapeLayerToAnimateIndex];
        
        CAAnimation *animationToApply = [animationsFromCluster lastObject];
        [self.layerAnimationKeyTracker addObject:shapeLayerToAnimate.layerAnimationKey];
        [shapeLayerToAnimate addAnimation:animationToApply
                                   forKey:shapeLayerToAnimate.layerAnimationKey];
        
        [animationsFromCluster removeLastObject];
        animationCluster.animations = [NSArray arrayWithArray:animationsFromCluster];
        
        if ([animationsFromCluster count] == 0)
        {
            [timer invalidate];
        }
    }
}


#pragma CAAnimation Delegate
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag)
    {
        NSString *layerAnimationKey = [anim valueForKey:LAYER_ANIMATION_KEY_KEY];
        [self.layerAnimationKeyTracker removeObject:layerAnimationKey];
        if ([self.layerAnimationKeyTracker count] == 0)
        {
            if ([self.animationKeysInOrder count] > 0)
            {
                [self startAnimationQueue];
            }
            else if (self.removeDelegateSublayersOnAnimationQueueCompletion)
            {
                [self.animationQueueFinishDelegate removeSublayersOnAnimationQueueCompletion];
                self.removeDelegateSublayersOnAnimationQueueCompletion = NO;
            }
            else if (self.removeDelegateSublayersAndDismissOnAnimationQueueCompletion)
            {
                [self.animationQueueFinishDelegate removeSublayersOnAnimationQueueCompletionAndDismiss];
                self.removeDelegateSublayersAndDismissOnAnimationQueueCompletion = NO;
            }
        }
    }
}




//   ____.-.____
//
//  [___________]
// (d|||||||||||b)
//  `|||TRASH|||`
//   |||||||||||
//   |||||||||||
//   |||||||||||
//   |||||||||||
//   `"""""""""`

@end
