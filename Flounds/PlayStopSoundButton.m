//
//  PlayStopSoundButton.m
//  Flounds
//
//  Created by Paul M Rest on 10/30/15.
//  Copyright © 2015 Paul Rest. All rights reserved.
//

#import "PlayStopSoundButton.h"

const CGFloat OUTER_CIRCLE_PADDING_FACTOR = 0.2f;

const CGFloat OUTER_CIRCLE_LINE_WIDTH_FACTOR = 0.05f;


@interface PlayStopSoundButton ()

@property (nonatomic, strong) CAShapeLayer *circleLayer;

@property (nonatomic, strong) CAShapeLayer *playLayer;

@property (nonatomic, strong) CAShapeLayer *stopLayer;


@property (nonatomic) CATransform3D counterClockwise90Degrees3D;

@property (nonatomic) CATransform3D clockwise90Degrees3D;

@property (nonatomic) CATransform3D zeroDegrees3D;


@property (nonatomic, strong) CABasicAnimation *rotateAwayFromView3D;

@property (nonatomic, strong) CABasicAnimation *rotateIntoView3D;

@property (nonatomic, strong) CABasicAnimation *strokeCircleAnimation2D;

@end


@implementation PlayStopSoundButton

-(CABasicAnimation *)rotateAwayFromView3D
{
    if (!_rotateAwayFromView3D)
    {
        _rotateAwayFromView3D = [CABasicAnimation animationWithKeyPath:@"transform"];
        _rotateAwayFromView3D.fromValue = [NSValue valueWithCATransform3D:self.zeroDegrees3D];
        _rotateAwayFromView3D.toValue = [NSValue valueWithCATransform3D:self.counterClockwise90Degrees3D];
        _rotateAwayFromView3D.repeatCount = 0;
        _rotateAwayFromView3D.duration = 0.2;
        _rotateAwayFromView3D.removedOnCompletion = NO;
        
        _rotateAwayFromView3D.fillMode = kCAFillModeForwards;
    }
    return _rotateAwayFromView3D;
}

-(CABasicAnimation *)rotateIntoView3D
{
    if (!_rotateIntoView3D)
    {
        _rotateIntoView3D = [CABasicAnimation animationWithKeyPath:@"transform"];
        _rotateIntoView3D.fromValue = [NSValue valueWithCATransform3D:self.clockwise90Degrees3D];
        _rotateIntoView3D.toValue = [NSValue valueWithCATransform3D:self.zeroDegrees3D];
        _rotateIntoView3D.repeatCount = 0;
        _rotateIntoView3D.duration = 0.2;
        _rotateIntoView3D.removedOnCompletion = NO;
        
        _rotateIntoView3D.fillMode = kCAFillModeForwards;
    }
    return _rotateIntoView3D;
}

-(CABasicAnimation *)strokeCircleAnimation2D
{
    if (!_strokeCircleAnimation2D)
    {
        _strokeCircleAnimation2D = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        _strokeCircleAnimation2D.fromValue = [NSNumber numberWithFloat:0.0f];
        _strokeCircleAnimation2D.toValue = [NSNumber numberWithFloat:1.0f];
        _strokeCircleAnimation2D.duration = self.soundPlayDuration;
        _strokeCircleAnimation2D.removedOnCompletion = YES;
        
        _strokeCircleAnimation2D.fillMode = kCAFillModeForwards;
    }
    return _strokeCircleAnimation2D;
}

-(void)animateButtonTogglePlayStop
{
    CFTimeInterval rotateAwayFromView3DDuration = self.rotateAwayFromView3D.duration;
    
    self.rotateIntoView3D.beginTime = CACurrentMediaTime() + rotateAwayFromView3DDuration;
    
    if (!self.currentlyPlayingSound)
    {
        [self restoreInnerShapesToNonPlayingState];
    }
    else
    {
        [self.playLayer addAnimation:self.rotateAwayFromView3D forKey:nil];
        [self.stopLayer addAnimation:self.rotateIntoView3D forKey:nil];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            
            [self restoreInnerShapesToNonPlayingState];
            
        }];
        
        [self.circleLayer addAnimation:self.strokeCircleAnimation2D forKey:nil];
        
        [CATransaction commit];
    }
}

-(void)restoreInnerShapesToNonPlayingState
{
    self.rotateIntoView3D.beginTime = CACurrentMediaTime() + self.rotateAwayFromView3D.duration;
    
    [self.stopLayer addAnimation:self.rotateAwayFromView3D forKey:nil];
    [self.playLayer addAnimation:self.rotateIntoView3D forKey:nil];
    
    [self.circleLayer removeAllAnimations];
}

-(void)drawRect:(CGRect)rect
{
    [self createOuterCirclePlayAndStopLayerInRect:rect];
    [self.layer addSublayer:self.circleLayer];
    
    //apply a counter-clockwise 90 degree rotation so that when we animate self.circleLayer with
    //self.strokeCircleAnimation2D the stroke starts at the top
    self.circleLayer.transform = CATransform3DMakeRotation(-90.0f * M_PI / 180.0f, 0.0f, 0.0f, 1.0f);
    
    self.counterClockwise90Degrees3D = CATransform3DMakeRotation(90.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    self.clockwise90Degrees3D = CATransform3DMakeRotation(-90.0f * M_PI / 180.0f, 0.0f, 1.0f, 0.0f);
    self.zeroDegrees3D = CATransform3DMakeRotation(0.0f, 0.0f, 1.0f, 0.0f);
    
    [self.layer addSublayer:self.stopLayer];
    [self.layer addSublayer:self.playLayer];
    
    if (self.currentlyPlayingSound)
    {
        self.playLayer.transform = self.clockwise90Degrees3D;
    }
    else
    {
        self.stopLayer.transform = self.clockwise90Degrees3D;
    }
}

-(void)createOuterCirclePlayAndStopLayerInRect:(CGRect)rect
{
    CGFloat smallerAxis = (rect.size.width > rect.size.height) ?
    rect.size.height : rect.size.width;
    CGFloat largerAxis = (rect.size.width < rect.size.height) ?
    rect.size.height : rect.size.width;
    
    CGFloat smallerAxisPadding = smallerAxis * OUTER_CIRCLE_PADDING_FACTOR;
    
    CGFloat paddedBoundingRectSide = smallerAxis - (smallerAxisPadding * 2.0f);
    
    CGFloat largerAxisPadding = (largerAxis - paddedBoundingRectSide) / 2.0f;
    
    CGFloat xOuterBoundingRectPadding;
    CGFloat yOuterBoundingRectPadding;
    if (rect.size.width == smallerAxis)
    {
        xOuterBoundingRectPadding = smallerAxisPadding;
        yOuterBoundingRectPadding = largerAxisPadding;
    }
    else
    {
        xOuterBoundingRectPadding = largerAxisPadding;
        yOuterBoundingRectPadding = smallerAxisPadding;
    }
    
    CGRect outerCircleBoundingRect = CGRectMake(xOuterBoundingRectPadding,
                                                yOuterBoundingRectPadding,
                                                paddedBoundingRectSide,
                                                paddedBoundingRectSide);
    
    self.circleLayer = [CAShapeLayer layer];
    self.circleLayer.frame = rect;
    self.circleLayer.zPosition = 0.0f;
    self.circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:outerCircleBoundingRect].CGPath;
    
    CGFloat lineWidthAndInnerRectPadding = smallerAxis * OUTER_CIRCLE_LINE_WIDTH_FACTOR;
    self.circleLayer.lineWidth = lineWidthAndInnerRectPadding;
    self.circleLayer.strokeColor = [FloundsViewConstants getDefaultTextColor].CGColor;
    
    CGFloat innerShapeBoundingSquareSide = paddedBoundingRectSide - (2.0f * lineWidthAndInnerRectPadding);
    
    CGFloat xInnerShapeTranslation = xOuterBoundingRectPadding + lineWidthAndInnerRectPadding;
    CGFloat yInnerShapeTranslation = yOuterBoundingRectPadding + lineWidthAndInnerRectPadding;
    
    CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(xInnerShapeTranslation, yInnerShapeTranslation);
    
    self.playLayer = [CAShapeLayer layer];
    self.playLayer.frame = rect;
    //we set the zPosition high enough that when the sublayer rotates it doesn't partially disappear into its superlayer
    self.playLayer.zPosition = rect.size.width / 2.0f;

    CGPathRef untranslatedPlayTrianglePath = [self bezierPathForRegularPolygonBoundedBySquareOfSide:innerShapeBoundingSquareSide
                                                                              withVerticesNumbering:3].CGPath;
    
    CGPathRef translatedPlayTrianglePath = CGPathCreateCopyByTransformingPath(untranslatedPlayTrianglePath, &translateTransform);
    
    self.playLayer.path = translatedPlayTrianglePath;
    
    CFRelease(translatedPlayTrianglePath);
    
    self.playLayer.fillColor = [FloundsViewConstants getDefaultTextColor].CGColor;
    
    self.stopLayer = [CAShapeLayer layer];
    self.stopLayer.frame = rect;
    //we set the zPosition high enough that when the sublayer rotates it doesn't partially disappear into its superlayer
    self.stopLayer.zPosition = rect.size.width / 2.0f;
    
    CGPathRef untranslatedStopSquarePath = [self bezierPathForRegularPolygonBoundedBySquareOfSide:innerShapeBoundingSquareSide
                                                                            withVerticesNumbering:4].CGPath;

    CGPathRef translatedStopSquarePath = CGPathCreateCopyByTransformingPath(untranslatedStopSquarePath, &translateTransform);
    
    self.stopLayer.path = translatedStopSquarePath;
    
    CFRelease(translatedStopSquarePath);
    
    self.stopLayer.fillColor = [FloundsViewConstants getDefaultTextColor].CGColor;
}

-(UIBezierPath *)bezierPathForRegularPolygonBoundedBySquareOfSide:(CGFloat)squareSide
                                            withVerticesNumbering:(NSUInteger)vertices
{
    UIBezierPath *newBezierPath = [[UIBezierPath alloc] init];
    NSArray *arrayOfPolygonVertexPointsAsNSValues = [self pointsForTriangleOrSquareBoundedBySquareOfSide:squareSide
                                                                                            withVertices:vertices];
    for (NSValue *onePointAsNSValue in arrayOfPolygonVertexPointsAsNSValues)
    {
        CGPoint nextPolygonVertex = [onePointAsNSValue CGPointValue];
        if ([arrayOfPolygonVertexPointsAsNSValues indexOfObject:onePointAsNSValue] == 0) //if point is the first
        {
            [newBezierPath moveToPoint:nextPolygonVertex];
        }
        else //if point is subsequent to the first point
        {
            [newBezierPath addLineToPoint:nextPolygonVertex];
        }
    }
    [newBezierPath closePath];
    return newBezierPath;
}

-(NSArray *)pointsForTriangleOrSquareBoundedBySquareOfSide:(CGFloat)squareSide
                                              withVertices:(NSUInteger)vertices
{
    NSMutableArray *arrayOfPoints = [[NSMutableArray alloc] initWithCapacity:vertices];
    
    CGFloat rotationPerVertex = (2.0 * M_PI) / vertices;
    
    CGFloat firstPointRadians = 0.0f;
    if (vertices == 3)
    {
        firstPointRadians = 0.0f;
    }
    else if (vertices == 4)
    {
        firstPointRadians = (45.0f * M_PI) / 180.f;
    }
    else
    {
        firstPointRadians = ((CGFloat)arc4random() / ARC4RANDOM_MAX) * (2.0 * M_PI);
    }
    
    CGFloat currentPointRadians = firstPointRadians;
    
    for (NSInteger i = 0; i < vertices; i++)
    {
        CGPoint nextPoint = [self pointOnCircleWithinSquareOfSide:squareSide atRadian:currentPointRadians];
        [arrayOfPoints addObject:[NSValue valueWithCGPoint:nextPoint]];
        
        currentPointRadians = currentPointRadians + rotationPerVertex;
    }
    
    return [NSArray arrayWithArray:arrayOfPoints];
}

-(CGPoint)pointOnCircleWithinSquareOfSide:(CGFloat)squareSide
                                 atRadian:(CGFloat)radian
{
    CGFloat xCircleCenter = squareSide / 2;
    CGFloat yCircleCenter = squareSide / 2;
    CGFloat circleRadius = squareSide / 2;
    
    CGFloat xPointOnCircleAtRaidan = xCircleCenter + (circleRadius * cosf(radian));
    CGFloat yPointOnCircleAtRadian = yCircleCenter + (circleRadius * sinf(radian));
    
    return CGPointMake(xPointOnCircleAtRaidan, yPointOnCircleAtRadian);
}

@end
