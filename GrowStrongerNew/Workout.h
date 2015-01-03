//
//  Workout.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>

@interface Workout : PFObject

+ (NSString *)parseClassName;

@property (retain) PFUser *user;
@property (retain) NSString *name;
@property (retain) NSDate *beganAt;
@property (retain) NSDate *completedAt;
@property (retain) NSString *active;
@property (retain) NSNumber *totalSets;
@property (retain) NSNumber *totalReps;
@property (retain) NSNumber *totalWeight;
@property (retain) NSNumber *totalCompletedExercises;
@property (retain) NSNumber *medalCountCore;
@property (retain) NSNumber *medalCountTotal;

@end
