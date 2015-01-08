//
//  RecordNewWorkoutViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "RecordNewWorkoutViewController.h"
#import "ActiveWorkoutTableViewController.h"
#import "Workout.h"

@interface RecordNewWorkoutViewController ()



@end

@implementation RecordNewWorkoutViewController

-(IBAction)unwindToRecordStandby:(UIStoryboardSegue *)unwindSegue
{
    
    // If the user clicked "Save", then save
    if ([unwindSegue.identifier  isEqual: @"CancelWorkout"]) {
        
        // Unpin and delete all incomplete workouts
        PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
        [query fromLocalDatastore];
        [query whereKey:@"active" equalTo:@"Active"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            for (Workout *workout in objects)
            {
                [workout deleteInBackground];
            }
        }];
    }
    
}


#pragma mark - Core methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier  isEqual: @"StartNewWorkout"]) {
        
        // Prep values
        PFUser *user = [PFUser currentUser];
        NSDate *now = [NSDate date];
        
        // Fill in the values
        Workout *activeWorkout = [Workout object];
        activeWorkout.user = user;
        activeWorkout.beganAt = now;
        activeWorkout.active = @"Active";
        
        // Pin the workout
        [activeWorkout pinInBackground];
        
        // Send the workout to the destination view controller
        ActiveWorkoutTableViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.activeWorkout = activeWorkout;
    }
}


@end
