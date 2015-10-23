//
//  ModalPatternMakerDelegate.h
//  Flounds
//
//  Created by Paul Rest on 10/10/14.
//  Copyright (c) 2014 Paul Rest. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ModalPatternMakerDelegate <NSObject>

-(void)dismissPatternMaker;

@optional

-(void)dismissPatternMakerFromCompletion;

-(void)dismissPatternMakerFromAbort;

@end
