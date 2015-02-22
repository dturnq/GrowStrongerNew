//
//  CompletedExercise.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/2/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "CompletedExercise.h"
#import <Parse/PFObject+Subclass.h>

@implementation CompletedExercise

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"CompletedExercise";
}

@dynamic user;

@dynamic position;

@dynamic totalSets;
@dynamic totalReps;
@dynamic totalWeight;

@dynamic maxWeight;
@dynamic repsInMaxWeight;

@dynamic active;

@dynamic timestamp;

@dynamic pr;

@dynamic workout;
@dynamic exercise;

@end