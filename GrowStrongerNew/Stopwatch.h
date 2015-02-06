//
//  TimeClass.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/19/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stopwatch : NSObject

-(NSDate *)workoutStartTime;
-(NSDate *)setStartTime;

-(void)setSetStartTime:(NSDate *)time;
-(void)setWorkoutStartTime:(NSDate *)time;


@end
