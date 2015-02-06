//
//  FeedPFQViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "Workout.h"

@interface FeedPFQViewController : PFQueryTableViewController


-(void)saveWorkouts;

-(void)saveWorkout:(Workout *)activeWorkout;



@end
