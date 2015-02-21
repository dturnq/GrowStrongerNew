//
//  WorkoutDetailsTableViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 2/10/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Workout.h"
#import "CompletedExercise.h"
#import "Set.h"

@interface WorkoutDetailsTableViewController : PFQueryTableViewController

@property (strong, nonatomic) Workout *selectedWorkout;
@property (weak, nonatomic) IBOutlet UILabel *workoutNameLabel;

@end
