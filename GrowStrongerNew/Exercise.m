//
//  Exercise.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "Exercise.h"
#import <Parse/PFObject+Subclass.h>

@implementation Exercise

+ (void)load {
    [self registerSubclass];
}

+ (NSString *)parseClassName {
    return @"Exercise";
}

@dynamic user;
@dynamic name;
@dynamic nameLowercase;
@dynamic exerciseType;
@dynamic prWeight;
@dynamic prReps;

@end
