//
//  SaveWorkoutViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/22/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "SaveWorkoutViewController.h"
#import "Set.h"
#import "CompletedExercise.h"
#import "Workout.h"

@interface SaveWorkoutViewController ()
-(void)saveWorkout;
@end

@implementation SaveWorkoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Save Workout
-(void)saveWorkout {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    if ([segue.identifier isEqual:@"SaveWorkout"]) {
        
        // BEFORE saving the workout, set all workouts, CEs, sets to "Raw Complete"
        NSLog(@"Beginning save segue to feed");
        self.activeWorkout.name = self.NameTextField.text;
        self.activeWorkout.nameLowercase = [self.NameTextField.text lowercaseString];
        NSDate *now = [NSDate date];
        self.activeWorkout.completedAt = now;
        self.activeWorkout.active = @"Raw Complete";
        self.activeWorkout.totalCompletedExercises = [NSNumber numberWithInt:0];
        self.activeWorkout.totalReps = [NSNumber numberWithInt:0];
        self.activeWorkout.totalSets = [NSNumber numberWithInt:0];
        self.activeWorkout.totalWeight = [NSNumber numberWithInt:0];
        self.activeWorkout.prCount = [NSNumber numberWithInt:0];
        [self.activeWorkout pin];
        
        
        NSLog(@"The active workout (from segue code): %@", self.activeWorkout);
        
        
        
    }
}


@end
