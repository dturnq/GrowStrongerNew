//
//  SelectExerciseViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/7/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Exercise.h"

@interface SelectExerciseViewController : PFQueryTableViewController

@property (weak, nonatomic) Exercise *selectedExercise;
@property (nonatomic, strong) NSDate *lastUpdatedFromServer;

-(void)refreshFromServer;

@end
