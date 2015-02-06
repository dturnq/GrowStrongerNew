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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual:@"SaveWorkout"]) {
        self.activeWorkout.name = self.NameTextField.text;
        self.activeWorkout.totalSets = [NSNumber numberWithInt:0];
        self.activeWorkout.totalReps = [NSNumber numberWithInt:0];
        self.activeWorkout.totalWeight = [NSNumber numberWithInt:0];
        self.activeWorkout.totalCompletedExercises = [NSNumber numberWithInt:0];
        
        
        PFQuery *queryCEs = [CompletedExercise query];
        [queryCEs fromLocalDatastore];
        [queryCEs whereKey:@"workout" equalTo:self.activeWorkout];
        [queryCEs orderByAscending:@"beganAt"];
        [queryCEs findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (CompletedExercise *completedExercise in objects) {
                    completedExercise.totalReps = [NSNumber numberWithInt:0];
                    completedExercise.totalSets = [NSNumber numberWithInt:0];
                    completedExercise.totalWeight = [NSNumber numberWithInt:0];
                    completedExercise.maxWeight = [NSNumber numberWithInt:0];
                    completedExercise.repsInMaxWeight = [NSNumber numberWithInt:0];
                    PFQuery *querySets = [Set query];
                    [querySets fromLocalDatastore];
                    [querySets whereKey:@"workout" equalTo:self.activeWorkout];
                    [querySets orderByAscending:@"beganAt"];
                    [querySets findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        for (Set *set in objects) {
                            completedExercise.totalReps = [NSNumber numberWithInt:(completedExercise.totalReps.intValue + set.reps.intValue)];
                            completedExercise.totalWeight = [NSNumber numberWithInt:(completedExercise.totalWeight.intValue + set.weight.intValue)];
                            completedExercise.totalSets = [NSNumber numberWithInt:(completedExercise.totalSets.intValue + 1)];
                            if (set.weight > completedExercise.maxWeight) {completedExercise.maxWeight = set.weight;};
                            if (set.weight == completedExercise.maxWeight & set.reps > completedExercise.repsInMaxWeight) {completedExercise.repsInMaxWeight = set.reps;};
                            [set pin];
                            [set saveEventually];
                        }
                    }];
                    
                    self.activeWorkout.totalCompletedExercises = [NSNumber numberWithInt:(self.activeWorkout.totalCompletedExercises.intValue + 1)];
                    self.activeWorkout.totalSets = [NSNumber numberWithInt:(self.activeWorkout.totalSets.intValue + completedExercise.totalSets.intValue)];
                    self.activeWorkout.totalWeight = [NSNumber numberWithInt:(self.activeWorkout.totalWeight.intValue + completedExercise.totalWeight.intValue)];
                    self.activeWorkout.totalReps = [NSNumber numberWithInt:(self.activeWorkout.totalReps.intValue + completedExercise.totalReps.intValue)];
                    [completedExercise pin];
                    [completedExercise saveEventually];
                }
            }
        }];
        
        
        self.activeWorkout.active = @"Unsaved";
        [self.activeWorkout pin];
        [self.activeWorkout saveEventually];
        
        
        
        
    }
}


@end
