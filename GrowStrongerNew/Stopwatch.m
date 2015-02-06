//
//  TimeClass.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/19/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "Stopwatch.h"

static NSDate *workoutStartTime;
static NSDate *setStartTime;

@implementation Stopwatch

+(void)initialize {
    //NSLog(@"Initialization beginning to run");
    //NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
    
    if (!workoutStartTime) {
        //NSLog(@"workoutStart");
        workoutStartTime = [[NSDate alloc] init];
    }
    
    //NSLog(@"Initialization half way");
    //NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
    if (!setStartTime) {
        //NSLog(@"setStart");
        setStartTime = [[NSDate alloc] init];
    }
    //NSLog(@"Initialization run");
    //NSLog(@"%d %s", __LINE__, __PRETTY_FUNCTION__);
}

-(NSDate *)workoutStartTime {
    return workoutStartTime;
}

-(NSDate *)setStartTime {
    return setStartTime;
}

-(void)setWorkoutStartTime:(NSDate *)time {
    //NSLog(@"setting workout start time");
    workoutStartTime = time;
}

-(void)setSetStartTime:(NSDate *)time {
    //NSLog(@"Setting set start time");
    setStartTime = time;
    
}

@end
