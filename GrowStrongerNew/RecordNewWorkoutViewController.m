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
#import "Stopwatch.h"

@interface RecordNewWorkoutViewController ()

@property (weak, nonatomic) Workout *activeWorkout;

@end

@implementation RecordNewWorkoutViewController

-(IBAction)unwindToRecordStandby:(UIStoryboardSegue *)unwindSegue
{
    
    // If the user clicked "Save", then save
    
    
    // If the user clicked "Cancel", delete workouts labelled "Garbage", plus all related objects
    if ([unwindSegue.identifier  isEqual: @"CancelWorkout"]) {

        // Unpin and delete all incomplete workouts
        PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
        [query fromLocalDatastore];
        [query whereKey:@"active" equalTo:@"Garbage"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {


            for (Workout *workout in objects) {
                
                PFQuery *querySets = [Set query];
                [querySets fromLocalDatastore];
                [querySets whereKey:@"workout" equalTo:workout];
                [querySets findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    for (Set *set in objects) {
                        [set unpin];
                    }
                    
                    PFQuery *queryCEs = [CompletedExercise query];
                    [queryCEs fromLocalDatastore];
                    [queryCEs whereKey:@"workout" equalTo:workout];
                    [queryCEs findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        for (CompletedExercise *cE in objects) {
                            [cE unpin];
                        }
                    }];
                }];
                
                [workout unpin];
            }

        }];
    } else if ([unwindSegue.identifier isEqual:@"SaveWorkout"]) {
        NSLog(@"Perform segue to Save Workout // nameing modal view");
        
        // Jump to the feed view
        self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:2];
        
        // Save all the workout data that is unsaved. Stuff will be double-saved (but probably without duplicates) if the entire process isn't completed. In future, this could potentially be mitigated by doing a single save-all. I don't now if it would then only save all or none.
        PFQuery *query = [Workout query];
        [query fromLocalDatastore];
        [query whereKey:@"active" equalTo:@"Unsaved"];
        [query orderByDescending:@"beganAt"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            /*
            for (Workout *workout in objects) {
                PFQuery *querySets = [Set query];
                [querySets fromLocalDatastore];
                [querySets whereKey:@"workout" equalTo:workout];
                [querySets findObjectsInBackgroundWithBlock:^(NSArray *setArray, NSError *error) {
                    
                    if (!error) {
                        [PFObject saveAllInBackground:setArray block:^(BOOL succeeded, NSError *error) {
                            
                            if (!error) {
                                PFQuery *queryCEs = [CompletedExercise query];
                                [queryCEs fromLocalDatastore];
                                [queryCEs whereKey:@"workout" equalTo:workout];
                                [queryCEs findObjectsInBackgroundWithBlock:^(NSArray *cEArray, NSError *error) {
                                    
                                    if (!error) {
                                        [PFObject saveAllInBackground:cEArray block:^(BOOL succeeded, NSError *error) {
                                            
                                            if (!error) {
                                                [workout saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                                    workout.active = @"Saved";
                                                    [workout pin];
                                                    [workout saveInBackground];
                                                }];
                                            } else {
                                                NSLog(@"Error: %@", error);
                                            }
                                            
                                        }];
                                    } else {
                                        NSLog(@"Error: %@", error);
                                    }
                                    
                                }];
                            } else {
                                NSLog(@"Error: %@", error);
                            }
                            
                        }];
                    } else {
                        NSLog(@"Error: %@", error);
                    }
                    
                }];
                
            }
             */
        }];
        

    }
    
}


#pragma mark - Core methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    PFQuery *query = [Workout query];
    [query fromLocalDatastore];
    [query whereKey:@"active" equalTo:@"Active"];
    [query orderByDescending:@"beganAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (objects.count != 0) {
            self.activeWorkout = [objects firstObject];
            [self performSegueWithIdentifier:@"ContinueWorkout" sender:self];
        }
    }];
    
    
     
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
        activeWorkout.totalCompletedExercises = [NSNumber numberWithInt:0];
        activeWorkout.totalSets = [NSNumber numberWithInt:0];
        activeWorkout.totalReps = [NSNumber numberWithInt:0];
        activeWorkout.totalWeight = [NSNumber numberWithInt:0];

        
        // Pin the workout
        [activeWorkout pinInBackground];
        
        // Prep the stopwatch
        /*
        Stopwatch *stopwatch = [[Stopwatch alloc] init];
        [stopwatch setWorkoutStartTime:now];
        [stopwatch setSetStartTime:now];
         */
        
        
        // Send the workout to the destination view controller
        ActiveWorkoutTableViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.activeWorkout = activeWorkout;
    } else if ([segue.identifier isEqual:@"ContinueWorkout"]) {
        // Send the workout to the destination view controller
        ActiveWorkoutTableViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.activeWorkout = self.activeWorkout;
    }
}


@end
