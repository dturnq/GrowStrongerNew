//
//  CompletedExercise.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/2/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>
#import "Workout.h"
#import "Exercise.h"

@interface CompletedExercise : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) PFUser *user;

@property (retain) NSNumber *position;

@property (retain) NSNumber *totalSets;
@property (retain) NSNumber *totalReps;
@property (retain) NSNumber *totalWeight;

@property (retain) NSNumber *maxWeight;
@property (retain) NSNumber *repsInMaxWeight;

@property (retain) NSString *active;


@property (retain) NSDate *timestamp;

@property BOOL pr;

@property (retain) Workout *workout;
@property (retain) Exercise *exercise;

@end
