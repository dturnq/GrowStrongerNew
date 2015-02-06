//
//  Set.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/2/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "Set.h"
#import <Parse/PFObject+Subclass.h>

@implementation Set

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Set";
}

@dynamic user;

@dynamic reps;
@dynamic weight;
@dynamic totalWeight;
@dynamic timeStamp;


@dynamic workout;
@dynamic completedExercise;
@dynamic exercise;
@end
