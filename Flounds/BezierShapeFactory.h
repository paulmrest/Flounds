//
//  BezierShapeFactory.h
//  Flounds
//
//  Created by Paul Rest on 10/13/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BezierShape.h"

#import "CircleBezierShape.h"
#import "EllipseBezierShape.h"
#import "TriangleBezierShape.h"
#import "SquareBezierShape.h"
#import "PentagonBezierShape.h"
#import "HexagonBezierShape.h"
#import "HeptagonBezierShape.h"
#import "OctagonBezierShape.h"

@interface BezierShapeFactory : NSObject

@property (nonatomic) NSUInteger numOfPossibleShapes;

-(void)startShapeGenerationSessionFor:(NSUInteger)shapes;

-(BezierShape *)getRandomBezierShapeForBoundingRect:(CGRect)rect;

-(void)endShapeGenerationSession;

@end
