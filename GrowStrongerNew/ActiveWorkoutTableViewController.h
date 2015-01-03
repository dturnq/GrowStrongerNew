//
//  ActiveWorkoutTableViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@interface ActiveWorkoutTableViewController : UITableViewController <UIActionSheetDelegate>

@property (strong, nonatomic) Workout *activeWorkout;

@end
