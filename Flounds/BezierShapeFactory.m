//
//  BezierShapeFactory.m
//  Flounds
//
//  Created by Paul Rest on 10/13/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "BezierShapeFactory.h"

const NSUInteger totalPossibleShapes = 5;

@interface BezierShapeFactory ()

@property (nonatomic, strong) NSArray *masterArrayOfShapeTypes;

@property (nonatomic) BOOL shapeGenerationSessionOpen;

@property (nonatomic) NSUInteger numberOfShapesOfEachTypeAllowed;

@property (nonatomic, strong) NSMutableDictionary *sessionShapeTypeTracker;

@end

@implementation BezierShapeFactory

-(id)init
{
    self = [super init];
    self.shapeGenerationSessionOpen = NO;
    [self fillMasterArray];
    return self;
}

-(void)fillMasterArray
{
    self.masterArrayOfShapeTypes = @[[CircleBezierShape class],
                                     [EllipseBezierShape class],
                                     [TriangleBezierShape class],
                                     [SquareBezierShape class],
                                     [PentagonBezierShape class],
                                     [HexagonBezierShape class],
                                     [HeptagonBezierShape class],
                                     [OctagonBezierShape class]];
}

-(NSMutableDictionary *)sessionShapeTypeTracker
{
    if (!_sessionShapeTypeTracker)
    {
        _sessionShapeTypeTracker = [[NSMutableDictionary alloc] initWithCapacity:[self.masterArrayOfShapeTypes count]];
    }
    return _sessionShapeTypeTracker;
}

//>>>
-(SquareBezierShape *)getSquareForBoundingRect:(CGRect)rect
{
    return [[SquareBezierShape alloc] initForRect:rect];
}

-(TriangleBezierShape *)getTriangleForBoundingRect:(CGRect)rect
{
    return [[TriangleBezierShape alloc] initForRect:rect];
}

-(EllipseBezierShape *)getEllipseForBoundingRect:(CGRect)rect
{
    return [[EllipseBezierShape alloc] initForRect:rect];
}

-(BezierShape *)getEllipsesAndTrianglesForBoundingRect:(CGRect)rect
{
    NSArray *ellipseAndTriangleArray = @[[EllipseBezierShape class],
                                         [TriangleBezierShape class]];
    NSUInteger randomIndexValue = arc4random_uniform((unsigned int)[ellipseAndTriangleArray count]);
    Class ellipseOrTriangleClass = ellipseAndTriangleArray[randomIndexValue];
    return [[ellipseOrTriangleClass alloc] initForRect:rect];
}
//<<<

-(void)startShapeGenerationSessionFor:(NSUInteger)shapes
{
    if (shapes > 0)
    {
        self.shapeGenerationSessionOpen = YES;
        self.numberOfShapesOfEachTypeAllowed = (shapes / [self.masterArrayOfShapeTypes count]) + 1;
    }
}

-(BezierShape *)getRandomBezierShapeForBoundingRect:(CGRect)rect
{
    if (self.shapeGenerationSessionOpen)
    {
        NSUInteger randomIndexValue = arc4random_uniform((unsigned int)[self.masterArrayOfShapeTypes count]);
        //>>>
    //    NSLog(@"BezierShapeFactory - getRandomBezierShape...");
    //    NSLog(@"randomIndexValue: %d", randomIndexValue);
    //    if (randomIndexValue > ([self.masterArrayOfShapeTypes count] - 1))
    //    {
    //        NSLog(@"randomIndexValue out of range, returning nil");
    //        return nil;
    //    }
        //<<<
        Class randomBezierShapeClass = self.masterArrayOfShapeTypes[randomIndexValue];
        
        NSString *classStringKey = NSStringFromClass(randomBezierShapeClass);
        NSNumber *numberOfShapesOfThisTypeCreatedThisSession = [self.sessionShapeTypeTracker objectForKey:classStringKey];
        if (numberOfShapesOfThisTypeCreatedThisSession)
        {
            NSInteger numOfShapesOfThisTypeCreatedThisSession = [numberOfShapesOfThisTypeCreatedThisSession integerValue];
            if (numOfShapesOfThisTypeCreatedThisSession < self.numberOfShapesOfEachTypeAllowed)
            {
                BezierShape *randomBezierShape = [[randomBezierShapeClass alloc] initForRect:rect];
                [self.sessionShapeTypeTracker setObject:[NSNumber numberWithInt:(int)numOfShapesOfThisTypeCreatedThisSession + 1]
                                                 forKey:classStringKey];
                return randomBezierShape;
            }
            else
            {
                return [self getRandomBezierShapeForBoundingRect:rect];
            }
        }
        else
        {
            BezierShape *randomBezierShape = [[randomBezierShapeClass alloc] initForRect:rect];
            [self.sessionShapeTypeTracker setObject:[NSNumber numberWithInt:1]
                                             forKey:classStringKey];
            return randomBezierShape;
        }
    }
    return nil;
}

-(UIColor *)getRandomStrokeColorFor:(BezierShape *)bezierShape
{
    return nil;
}

-(UIColor *)getRandomFillColorFor:(BezierShape *)bezierShape
{
    return nil;
}

-(void)endShapeGenerationSession
{
    self.shapeGenerationSessionOpen = NO;
    [self.sessionShapeTypeTracker removeAllObjects];
}

@end
