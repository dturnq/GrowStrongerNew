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
        NSDate *now = [NSDate date];
        self.activeWorkout.completedAt = now;
        self.activeWorkout.active = @"Raw Complete";
        [self.activeWorkout pin];
        
        /*
        PFQuery *queryCEs = [CompletedExercise query];
        [queryCEs fromLocalDatastore];
        [queryCEs whereKey:@"workout" equalTo:self.activeWorkout];
        [queryCEs orderByAscending:@"timestamp"];
        NSArray *ceArray = [queryCEs findObjects];
        for (CompletedExercise *ce in ceArray) {
            ce.active = @"Raw Complete";
            [ce pin];
        }
        
        
        // Get the best set so far
        PFQuery *queryBestSetInWorkout = [Set query];
        [queryBestSetInWorkout fromLocalDatastore];
        [queryBestSetInWorkout whereKey:@"workout" equalTo:self.activeWorkout];
        NSArray *setsArray = [queryBestSetInWorkout findObjects];
        for (Set *set in setsArray) {
            set.active = @"Raw Complete";
            [set pin];
        }
         */
        NSLog(@"The active workout (from segue code): %@", self.activeWorkout);
        
        
        
        
        /*
        PFQuery *queryWorkouts = [Workout query];
        [queryWorkouts fromLocalDatastore];
        [queryWorkouts whereKey:@"active" equalTo:@"Processing"];
        [queryWorkouts orderByDescending:@"completedAt"];
        [queryWorkouts findObjectsInBackgroundWithBlock:^(NSArray *objectsActiveWorkout, NSError *error) {
            NSLog(@"Found workout to save: %@", [objectsActiveWorkout firstObject]);
            Workout *activeWorkout = [objectsActiveWorkout firstObject];
            PFQuery *queryCEs2 = [CompletedExercise query];
            [queryCEs2 fromLocalDatastore];
            [queryCEs2 whereKey:@"workout" equalTo:activeWorkout];
            [queryCEs2 orderByAscending:@"timestamp"];
            NSArray *objectsCEs2 = [queryCEs2 findObjects];

            for (CompletedExercise *completedExercise in objectsCEs2) {
                
                PFQuery *querySets = [Set query];
                [querySets fromLocalDatastore];
                [querySets whereKey:@"workout" equalTo:activeWorkout];
                [querySets whereKey:@"exercise" equalTo:completedExercise.exercise];
                [querySets orderByDescending:@"weight"];
                [querySets orderByDescending:@"reps"];
                [querySets orderByAscending:@"timestamp"];
                querySets.limit = 1;
                NSArray *objectsSets = [querySets findObjects];
                Set *bestSet = [objectsSets firstObject];
                bestSet.bestSet = YES;
                [bestSet pin];
                
                
            }
            
            activeWorkout.totalSets = [NSNumber numberWithInt:0];
            activeWorkout.totalReps = [NSNumber numberWithInt:0];
            activeWorkout.totalWeight = [NSNumber numberWithInt:0];
            activeWorkout.totalCompletedExercises = [NSNumber numberWithInt:0];
            
            
            PFQuery *queryCEs = [CompletedExercise query];
            [queryCEs fromLocalDatastore];
            [queryCEs whereKey:@"workout" equalTo:activeWorkout];
            [queryCEs orderByAscending:@"timestamp"];
            NSArray *objectsCEs = [queryCEs findObjects];
        
            for (CompletedExercise *completedExercise in objectsCEs) {
                completedExercise.totalReps = [NSNumber numberWithInt:0];
                completedExercise.totalSets = [NSNumber numberWithInt:0];
                completedExercise.totalWeight = [NSNumber numberWithInt:0];
                completedExercise.maxWeight = [NSNumber numberWithInt:0];
                completedExercise.repsInMaxWeight = [NSNumber numberWithInt:0];
                PFQuery *querySets = [Set query];
                [querySets fromLocalDatastore];
                [querySets whereKey:@"workout" equalTo:activeWorkout];
                [querySets whereKey:@"completedExercise" equalTo:completedExercise];
                [querySets orderByAscending:@"timestamp"];
                NSArray *objectsSets = [querySets findObjects];

                for (Set *set in objectsSets) {
                    completedExercise.totalReps = [NSNumber numberWithInt:(completedExercise.totalReps.intValue + set.reps.intValue)];
                    completedExercise.totalWeight = [NSNumber numberWithInt:(completedExercise.totalWeight.intValue + set.weight.intValue)];
                    completedExercise.totalSets = [NSNumber numberWithInt:(completedExercise.totalSets.intValue + 1)];
                    if (set.weight > completedExercise.maxWeight) {completedExercise.maxWeight = set.weight;};
                    if (set.weight == completedExercise.maxWeight & set.reps > completedExercise.repsInMaxWeight) {completedExercise.repsInMaxWeight = set.reps;};
                    [set pin];
                    [set saveEventually];
                }
                activeWorkout.totalCompletedExercises = [NSNumber numberWithInt:(activeWorkout.totalCompletedExercises.intValue + 1)];
                activeWorkout.totalSets = [NSNumber numberWithInt:(activeWorkout.totalSets.intValue + completedExercise.totalSets.intValue)];
                activeWorkout.totalWeight = [NSNumber numberWithInt:(activeWorkout.totalWeight.intValue + completedExercise.totalWeight.intValue)];
                activeWorkout.totalReps = [NSNumber numberWithInt:(activeWorkout.totalReps.intValue + completedExercise.totalReps.intValue)];
                [completedExercise pin];
                [completedExercise saveEventually];
                
            }
            activeWorkout.active = @"Saved";
            [activeWorkout pin];
            [activeWorkout saveEventually];

        }];
        */
    }
}


@end
