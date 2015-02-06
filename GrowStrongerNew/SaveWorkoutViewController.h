//
//  SaveWorkoutViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/22/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Workout.h"

@interface SaveWorkoutViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *NameTextField;

@property (strong, nonatomic) Workout *activeWorkout;

@end
