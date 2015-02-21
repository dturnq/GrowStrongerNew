//
//  Workout.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "Workout.h"
#import <Parse/PFObject+Subclass.h>

@implementation Workout

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Workout";
}

@dynamic user;
@dynamic name;
@dynamic beganAt;
@dynamic completedAt;
@dynamic active;
@dynamic totalSets;
@dynamic totalReps;
@dynamic totalWeight;
@dynamic totalCompletedExercises;
@dynamic prCount;

@end
