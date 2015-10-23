//
//  PatternMakerVC.m
//  Flounds
//
//  Created by Paul Rest on 5/16/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import "PatternMakerVC.h"

const NSUInteger MAX_ORIGIN_POINTS_TO_CHECK = 1000;

const NSUInteger MAX_SHAPES_TO_GENERATE = 20;

const NSTimeInterval STARTING_SEQUENCE_SPEED = 0.30;

@interface PatternMakerVC ()

@property (nonatomic, strong) BezierShapeFactory *shapeFactory;

@property (nonatomic, strong) NSMutableArray *shapes;

@property (nonatomic) CGFloat baseShapeSize;

@property (nonatomic, strong) NSMutableArray *inputSequence;

@property (nonatomic, strong) NSArray *sequenceToMatch;

@property (nonatomic) NSTimeInterval sequenceSpeed;

@property (nonatomic) BOOL sequenceToMatchPresent;

@property (nonatomic) NSUInteger difficultyLevel;

@property (nonatomic, strong) NSTimer *snoozeTimer;

@property (nonatomic) BOOL cannotDismissSelf;

//>>>(allShapeSequences)
@property (nonatomic, strong) NSMutableArray *allShapeSequences;
//<<<

@end

@implementation PatternMakerVC

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.cannotDismissSelf = NO;
    self.abortAvailable = NO;
    
    if ([[self.floundsModel getCurrSequence] count] == self.floundsModel.currNumberOfShapes)
    {
        self.sequenceToMatchPresent = YES;
    }
    
    //UISwipeGestureRecognizers for the four directions
    UISwipeGestureRecognizer *swipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(swipeAction:)];
    swipeUpRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUpRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(swipeAction:)];
    swipeRightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightRecognizer];
    
    UISwipeGestureRecognizer *swipeDownRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipeAction:)];
    swipeDownRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDownRecognizer];
    
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(swipeAction:)];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftRecognizer];
    
    //UITapGestureRocognizer for single tap
    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(singleTapAction:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapRecognizer];
}

-(void)setAbortAvailable:(BOOL)abortAvailable
{
    _abortAvailable = abortAvailable;
    if (abortAvailable)
    {
        UITapGestureRecognizer *tripleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                              action:@selector(tripleTapAction:)];
        [tripleTapRecognizer setNumberOfTapsRequired:3];
        [self.view addGestureRecognizer:tripleTapRecognizer];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if ([self.shapes count] == 0)
    {
        //>>>
//        NSLog(@"PatternMakerVC - viewDidLayoutSubviews");
        //<<<
        [self generateShapes];
        self.shapeView.currMatchingSequence = [self.floundsModel getCurrSequence];
        [self.shapeView setShapesToDisplay:[NSArray arrayWithArray:self.shapes]];
        
        self.shapeView.patternMakerDelegate = self.patternMakerDelegate;        
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.shapeView presentShapes];
}

-(BezierShapeFactory *)shapeFactory
{
    if (!_shapeFactory)
    {
        _shapeFactory = [[BezierShapeFactory alloc] init];
    }
    return _shapeFactory;
}

-(FloundsModel *)floundsModel
{
    if (!_floundsModel)
    {
        _floundsModel = [[FloundsModel alloc] initWithSystemDefaults];
        self.cannotDismissSelf = YES;
    }
    return _floundsModel;
}

-(CGFloat)baseShapeSize
{
    if (!_baseShapeSize)
    {
        NSString *currentDevice = [UIDevice currentDevice].model;
        //use the larger dimension for calculating baseShapeSize
        CGFloat sizeForBaseShape = (self.shapeView.frame.size.width >= self.shapeView.frame.size.height ? self.shapeView.frame.size.width : self.shapeView.frame.size.height);
        if ([currentDevice rangeOfString:@"iPad"].location != NSNotFound)
        {
            _baseShapeSize = sizeForBaseShape * IPAD_SHAPE_SIZE_RATIO;
        }
        else if ([currentDevice rangeOfString:@"iPhone"].location != NSNotFound)
        {
            _baseShapeSize = sizeForBaseShape * IPHONE_SHAPE_SIZE_RATIO;
        }
    }
    return _baseShapeSize;
}

-(NSMutableArray *)inputSequence
{
    if (!_inputSequence)
    {
        _inputSequence = [[NSMutableArray alloc] initWithCapacity:[self.shapes count]];
    }
    return _inputSequence;
}

NSUInteger pointsChecked = 0;

//NSUInteger numOfShapesToGenerate = 4;

-(void)setDifficultyLevel:(NSUInteger)difficulty
{
    
}

-(NSMutableArray *)shapes
{
    if (!_shapes)
    {
        _shapes = [[NSMutableArray alloc] initWithCapacity:self.floundsModel.currNumberOfShapes];
    }
    return _shapes;
}

-(NSMutableArray *)allShapeSequences
{
    if (!_allShapeSequences)
    {
        _allShapeSequences = [[NSMutableArray alloc] init];
    }
    return _allShapeSequences;
}

-(void)generateShapes
{
    self.shapes = nil;
    
    NSUInteger shapeUniqueID = 0;
    [self.shapeFactory startShapeGenerationSessionFor:self.floundsModel.currNumberOfShapes];
    for (int i = 1; i <= MAX_ORIGIN_POINTS_TO_CHECK; i++)
    {
        CGPoint possibleOriginPoint = [self randomOriginPoint];
        
        CGRect rectForPossibleShape = CGRectMake(possibleOriginPoint.x, possibleOriginPoint.y, self.baseShapeSize, self.baseShapeSize);
        
        if (![self rectForPossibleShapeInterfersWithPreexistingShape:rectForPossibleShape])
        {
            BezierShape *newShape = [self.shapeFactory getRandomBezierShapeForBoundingRect:rectForPossibleShape];
            
//            BezierShape *newShape = [self.shapeFactory getEllipsesAndTrianglesForBoundingRect:rectForPossibleShape];
            
//            BezierShape *newShape = [self.shapeFactory getTriangleForBoundingRect:rectForPossibleShape];
//            BezierShape *newShape = [self.shapeFactory getSquareForBoundingRect:rectForPossibleShape];
//            BezierShape *newShape = [self.shapeFactory getEllipseForBoundingRect:rectForPossibleShape];
            newShape.shapeID = shapeUniqueID;
            shapeUniqueID++;
            [self.shapes addObject:newShape];
            if ([self.shapes count] >= self.floundsModel.currNumberOfShapes)
            {
                [self.shapeFactory endShapeGenerationSession];
                break;
            }
        }
    }
    //if MAX_ORIGIN_POINTS_TO_CHECK is hit and for loop is exited without generating numOfShapesToGenerate method will reduce
    //baseShapeSize by 0.75, remove all shapes and try again
    if ([self.shapes count] < self.floundsModel.currNumberOfShapes)
    {
        //>>>
        NSLog(@"PatternMakerVC - generateShapes... resetting with baseShapeSize * 0.75");
        //<<<
        [self.shapeFactory endShapeGenerationSession];
        self.baseShapeSize *= 0.75;
        [self.shapes removeAllObjects];
        [self generateShapes];
    }
}

//>>>
-(void)displayPoint:(CGPoint)point
{
    CGRect pointRect = CGRectMake(point.x, point.y, 2.0, 2.0);
    UIView *pointView = [[UIView alloc] initWithFrame:pointRect];
    pointView.backgroundColor = [UIColor redColor];
    [self.shapeView addSubview:pointView];
}
//<<<

-(BOOL)rectForPossibleShapeInterfersWithPreexistingShape:(CGRect)possibleShapeRect
{
    CGFloat xPossibleShapeCenter = CGRectGetMidX(possibleShapeRect);
    CGFloat yPossibleShapeCenter = CGRectGetMidY(possibleShapeRect);

    CGFloat shapeToCheckRadius = [BezierShape confiningRadiusForRect:possibleShapeRect];
    
//    CGFloat shapeToCheckRadius = [self confiningRadiusForRect:possibleShapeRect];
    
    for (BezierShape *oneShape in self.shapes)
    {
        CGFloat xPreexistingShapeCenter = CGRectGetMidX(oneShape.confiningRect);
        CGFloat yPreexistingShapeCenter = CGRectGetMidY(oneShape.confiningRect);
        
        CGFloat dx = xPossibleShapeCenter - xPreexistingShapeCenter;
        CGFloat dy = yPossibleShapeCenter - yPreexistingShapeCenter;
                
        CGFloat distanceBetweenPoints = sqrtf(powf(dx, 2.0) + powf(dy, 2.0));
        
        CGFloat oneShapeRadius = [oneShape confiningRadius];
        
        if (distanceBetweenPoints <= (shapeToCheckRadius + oneShapeRadius))
        {
            return YES;
        }
    }
    return NO;
}

-(CGPoint)randomOriginPoint
{
    CGFloat availableX = self.shapeView.frame.size.width;
    CGFloat availableY = self.shapeView.frame.size.height;
    
    CGFloat xMin = availableX * SIDE_PADDING_FACTOR;
    CGFloat yMin = availableY * SIDE_PADDING_FACTOR;
    
    CGFloat xMax = availableX - xMin - self.baseShapeSize;
    CGFloat yMax = availableY - yMin - self.baseShapeSize;
    
    CGFloat xOrigin = ((CGFloat)arc4random() / ARC4RANDOM_MAX) * (xMax - xMin) + xMin;
    CGFloat yOrigin = ((CGFloat)arc4random() / ARC4RANDOM_MAX) * (yMax - yMin) + yMin;
    
    return CGPointMake(xOrigin, yOrigin);
}

-(IBAction)shapeTapAction:(UITapGestureRecognizer *)sender
{
}

-(void)swipeAction:(UISwipeGestureRecognizer *)swipe
{
    [self.inputSequence removeAllObjects];
    [self displaySequence];
}

-(void)singleTapAction:(UITapGestureRecognizer *)singleTapGR
{
    CGPoint tapPoint = [singleTapGR locationInView:self.shapeView];
    NSInteger tappedShapeID = [self shapeTapOccursIn:tapPoint];
    if (tappedShapeID >= 0)
    {
        [self.shapeView pulseOneShapeOnly:tappedShapeID];
        if (self.sequenceToMatchPresent)
        {
            [self captureInputSequence:tappedShapeID];
        }
    }
    if (tappedShapeID < 0)
    {
        //>>>
//        [self.shapeView animationTester];
        //<<<
        [self.shapeView bounceAllShapesTowardsPoint:tapPoint];
    }
}



-(void)tripleTapAction:(UITapGestureRecognizer *)tripleTapGR
{
    NSString *ALERT_TITLE = NSLocalizedString(@"Abort", nil);
    NSString *ALERT_MESSAGE = NSLocalizedString(@"Too many shapes?", nil);
    NSString *CANCEL_BUTTON_TEXT = NSLocalizedString(@"Never!", nil);
    NSString *CONFIRM_ABORT_TEXT = NSLocalizedString(@"Get me outta here", nil);
    
    UIAlertView *abortAlert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE
                                                        message:ALERT_MESSAGE
                                                        delegate:self
                                                cancelButtonTitle:CANCEL_BUTTON_TEXT
                                                otherButtonTitles:CONFIRM_ABORT_TEXT, nil];
    [abortAlert show];
}

#pragma UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        //unwind back to settings
        [self.patternMakerDelegate dismissPatternMakerFromAbort];
    }
}

-(NSInteger)shapeTapOccursIn:(CGPoint)tapPoint
{
    for (BezierShape *oneShape in self.shapes)
    {
        CGAffineTransform translationToScreenPosition = CGAffineTransformMakeTranslation(oneShape.drawingRect.origin.x,
                                                                                         oneShape.drawingRect.origin.y);
        
        CGPathRef translatedToScreenPositionPath = CGPathCreateCopyByTransformingPath(oneShape.path.CGPath,
                                                                                      &translationToScreenPosition);
        
        if (CGPathContainsPoint(translatedToScreenPositionPath, NULL, tapPoint, FALSE))
        {
            return oneShape.shapeID;
        }
    }
    return -1;
}

-(void)captureInputSequence:(NSInteger)shapeID
{
    if ([self.inputSequence count] <= self.floundsModel.currNumberOfShapes)
    {
        NSNumber *shapeIDObject = [NSNumber numberWithInteger:shapeID];
        [self.inputSequence addObject:shapeIDObject];
        if ([self.inputSequence count] == self.floundsModel.currNumberOfShapes)
        {
            NSTimer *sequenceFeedbackTimer;
            if ([self.floundsModel checkForMatchGiven:self.inputSequence])
            {
                if (self.cannotDismissSelf)
                {
                    [self getNextSequenceWithoutDismiss];
                }
                else
                {
                    [self.shapeView dismissShapesAndPatternMaker];
                }
            }
            else
            {
                [self.shapeView shakeAllShapes];
                [self.inputSequence removeAllObjects];
            }
            if (sequenceFeedbackTimer)
            {
                [[NSRunLoop currentRunLoop] addTimer:sequenceFeedbackTimer forMode:NSDefaultRunLoopMode];
            }
        }
    }
}

-(void)getNextSequenceWithoutDismiss
{
    [self.shapeView dismissShapesOnly];
    self.sequenceToMatch = [self.floundsModel incrementDifficultyAndGetNewSequence];
    [self generateShapes];
    [self.shapeView setShapesToDisplay:[NSArray arrayWithArray:self.shapes]];
    [self.inputSequence removeAllObjects];
    [self displaySequence];
}

-(void)displaySequence
{
    [self.shapeView displaySequenceWithPulses:[self.floundsModel getCurrSequence]];
}

-(void)inputSequenceCompleteAndDismiss
{
    [self.patternMakerDelegate dismissPatternMaker];
}

//>>>(allShapeSequences)
-(void)catalogCurrShapeSequence
{
    NSArray *currShapeSequenceCopy = [NSArray arrayWithArray:self.shapes];
    [self.allShapeSequences addObject:currShapeSequenceCopy];
}

-(void)displayAllShapeSequences
{
    if ([self.allShapeSequences count] > 1)
    {
        for (NSUInteger i = 0; i < [self.allShapeSequences count]; i++)
        {
            NSLog(@" ");
            NSLog(@"Shape sequence: %lu", (unsigned long)i);
            NSArray *oneShapeSequence = [self.allShapeSequences objectAtIndex:i];
            for (NSUInteger j = 0; j < [oneShapeSequence count]; j++)
            {
                BezierShape *oneBezierShape = [oneShapeSequence objectAtIndex:j];
                NSLog(@" ");
                NSLog(@"Looking at shape with shapeID: %lu", (unsigned long)oneBezierShape.shapeID);
                NSLog(@"shape is of class: %@", NSStringFromClass([oneBezierShape class]));
                NSLog(@"confiningRect origin - x: %f, y: %f",
                      oneBezierShape.confiningRect.origin.x,
                      oneBezierShape.confiningRect.origin.y);
                NSLog(@"confiningRect size - width: %f, height: %f",
                      oneBezierShape.confiningRect.size.width,
                      oneBezierShape.confiningRect.size.height);
            }
        }
    }
}
//<<<

@end
