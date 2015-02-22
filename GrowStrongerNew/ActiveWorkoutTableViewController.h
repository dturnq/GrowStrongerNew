//
//  ActiveWorkoutTableViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"
#import "CompletedExercise.h"
#import "Set.h"

@interface ActiveWorkoutTableViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) Workout *activeWorkout;
@property (strong, nonatomic) NSArray *completedExerciseArray;
@property (strong, nonatomic) Set *set;
@property (weak, nonatomic) IBOutlet UIView *timerView;
@property (weak, nonatomic) IBOutlet UILabel *setTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutTimerLabel;

@end
