//
//  Set.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/2/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>
#import "Workout.h"
#import "CompletedExercise.h"
#import "Exercise.h"
#import "Set.h"

@interface Set : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) PFUser *user;

@property (retain) NSNumber *reps;
@property (retain) NSNumber *weight;
@property (retain) NSNumber *totalWeight;
@property (retain) NSDate *timestamp;

@property (retain) NSString *active;
@property BOOL pr;

@property (retain) Workout *workout;
@property (retain) CompletedExercise *completedExercise;
@property (retain) Exercise *exercise;

@end
