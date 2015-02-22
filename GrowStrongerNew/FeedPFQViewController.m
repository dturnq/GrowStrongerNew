//
//  FeedPFQViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "FeedPFQViewController.h"
#import "Workout.h"
#import "CompletedExercise.h"
#import "Set.h"
#import "MKInfoPanel.h"
#import "WorkoutDetailsTableViewController.h"

@interface FeedPFQViewController ()

@property BOOL isSaving;
@property BOOL isSavingSets;
@property BOOL isSavingCEs;
@property BOOL isSavingWorkouts;

@end

@implementation FeedPFQViewController

-(IBAction)unwindToFeed:(UIStoryboardSegue *)unwindSegue
{
    
    // If the user clicked "Save", then save
    if ([unwindSegue.identifier  isEqual: @"UnwindToFeed"]) {
        // Save the workout
        
    }
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"Workout"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Workout";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}




#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"View Did Appear was called");
    
    NSLog(@"isSaving: %@", [NSNumber numberWithBool: self.isSaving]);
    
    if (!self.isSaving) {
        [self saveWorkouts2];
    }
    
    
    /*
    [MKInfoPanel showPanelInView:self.view
                            type:MKInfoPanelTypeError
                           title:@"Device offline"
                        subtitle:@"Workouts will be synced as soon as a network connection becomes available."
                       hideAfter:4];
     */
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Save Workouts

-(void)saveWorkout:(Workout *)activeWorkout {
    
    
    
}

-(void)saveWorkouts2 {
    
    /*
     Run this whenever the view is viewed
     1. Lock it so that it cannot be started again
     2. Find the oldest "Raw Complete" workout
     3. Look for sets that are "Active" from that workout [USED TO BE "RAW COMPLETE"]
     - If none, go to PR check step
     - else go to Process Raw step
     
     */
    
    
    NSLog(@"beginning saveworkouts2");
    self.isSaving = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       NSLog(@"Just opened the second thread");
                       PFQuery *queryWorkouts = [Workout query];
                       [queryWorkouts fromLocalDatastore];
                       [queryWorkouts whereKey:@"active" equalTo:@"Raw Complete"];
                       [queryWorkouts orderByAscending:@"completedAt"];
                       queryWorkouts.limit = 1;
                       NSArray *objectsActiveWorkout = [queryWorkouts findObjects];
                       
                       if (objectsActiveWorkout.count > 0) {
                           //NSLog(@"Found workout to save: %@", [objectsActiveWorkout firstObject]);
                           Workout *activeWorkout = [objectsActiveWorkout firstObject];
                           
                           
                           PFQuery *querySetCheck = [Set query];
                           [querySetCheck fromLocalDatastore];
                           [querySetCheck whereKey:@"workout" equalTo:activeWorkout];
                           //[querySetCheck whereKey:@"active" equalTo:@"Active"];
                           querySetCheck.limit = 1;
                           NSArray *objectsSetsCheck = [querySetCheck findObjects];
                           NSLog(@"DAVID CHECKPOINT: Found %lu sets", (unsigned long)objectsSetsCheck.count);
                           if (objectsSetsCheck.count == 0) {
                               NSLog(@"... but there are no sets, so we're giong to prCheck");
                               [self prCheck:activeWorkout];
                           } else {
                               NSLog(@"...And there are sets, so we're going to process the sets");
                               NSLog(@"Set deets: %@", [objectsSetsCheck firstObject]);
                               [self processSetsInWorkout:activeWorkout];
                           }
                           
                       } else {
                           // No workouts to save :)
                           NSLog(@"No workouts to save :)");
                       }

                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          self.isSaving = NO;
                                          [self.tableView reloadData];
                                      });
                   });
    
}

-(void)processSetsInWorkout:(Workout *)workout {
    
    // Tag the best set in each exercise in a workout
    // Change the status of the sets afterward so that we know they're done
    /*
     Processing step: Go through all exercises, for each pick the top set; set it to "Pre-processed Best"; remaining sets set to "Fully pre-processed" [NO SAVE] [NOTE: A premiminary protective measure would reorder to rename the others first]
     - Go to calc PR step
    */
    
    NSLog(@"Started the process Sets method");
    
    PFQuery *queryCEs = [CompletedExercise query];
    [queryCEs fromLocalDatastore];
    [queryCEs whereKey:@"workout" equalTo:workout];
    [queryCEs orderByAscending:@"timestamp"];
    NSArray *objectsCEs2 = [queryCEs findObjects];
    
    //NSLog(@"Found the completed exercises");
    for (CompletedExercise *completedExercise in objectsCEs2) {
        //NSLog(@"in process sets; we're going through the CE: %@", completedExercise);
        // Pull all the sets, sorting so the the first best set is at the top
        PFQuery *querySets = [Set query];
        [querySets fromLocalDatastore];
        [querySets whereKey:@"workout" equalTo:workout];
        [querySets whereKey:@"exercise" equalTo:completedExercise.exercise];
        NSArray *array = [[NSArray alloc] initWithObjects:@"Active", @"Active Temp", nil];
        [querySets whereKey:@"active" containedIn:array];

        [querySets orderByDescending:@"weight"];
        [querySets addDescendingOrder:@"reps"];
        [querySets addAscendingOrder:@"timestamp"];
        
        

        NSArray *objectsSets = [querySets findObjects];
        if (objectsSets.count > 0) {
            NSLog(@"List of sets: %@", objectsSets);
            // First tag the best set
            Set *bestSet = [objectsSets firstObject];
            bestSet.active = @"Active Temp";
            [bestSet pin];
            NSLog(@"Found a best set: %@", bestSet);
            
            // The tag all the rest
            [querySets whereKey:@"active" equalTo:@"Active"];
            NSArray *objectsSets2 = [querySets findObjects];
            for (Set *set in objectsSets2) {
                NSLog(@"Found a set that isn't best - saving: %@", set);
                completedExercise.totalWeight = [NSNumber numberWithInt:(completedExercise.totalWeight.intValue + set.totalWeight.intValue)];
                completedExercise.totalSets = [NSNumber numberWithInt:(completedExercise.totalSets.intValue + 1)];
                completedExercise.totalReps = [NSNumber numberWithInt:(completedExercise.totalReps.intValue + set.reps.intValue)];
                
                workout.totalWeight = [NSNumber numberWithInt:(workout.totalWeight.intValue + set.totalWeight.intValue)];
                workout.totalSets = [NSNumber numberWithInt:(workout.totalSets.intValue + 1)];
                workout.totalReps = workout.totalReps = [NSNumber numberWithInt:(workout.totalReps.intValue + set.reps.intValue)];
                
                [completedExercise pin];
                [workout pin];
                
                set.active = @"Fully Pre-processed";
                [set pin];
            }
            
            completedExercise.totalWeight = [NSNumber numberWithInt:(completedExercise.totalWeight.intValue + bestSet.totalWeight.intValue)];
            completedExercise.totalSets = [NSNumber numberWithInt:(completedExercise.totalSets.intValue + 1)];
            completedExercise.totalReps = [NSNumber numberWithInt:(completedExercise.totalReps.intValue + bestSet.reps.intValue)];
            if (bestSet.weight.intValue > completedExercise.maxWeight.intValue) {
                completedExercise.maxWeight = bestSet.weight;
                completedExercise.repsInMaxWeight = bestSet.reps;
            }
            if ((bestSet.weight.intValue == completedExercise.maxWeight.intValue) & (bestSet.reps.integerValue > completedExercise.repsInMaxWeight.intValue)) {
                completedExercise.repsInMaxWeight = bestSet.reps;
            }
            workout.totalWeight = [NSNumber numberWithInt:(workout.totalWeight.intValue + bestSet.totalWeight.intValue)];
            workout.totalSets = [NSNumber numberWithInt:(workout.totalSets.intValue + 1)];
            workout.totalReps = workout.totalReps = [NSNumber numberWithInt:(workout.totalReps.intValue + bestSet.reps.intValue)];
            
            [completedExercise pin];
            [workout pin];
            bestSet.active = @"Processed Best";
            [bestSet pin];
            
        } else {
            NSLog(@"No sets found");
        }
        
    
        
    }
    
    //NSLog(@"Running PRcheck");
    [self prCheck:workout];
    
}


-(void)prCheck:(Workout *)workout {
    
    /*
     PR check step: Look for sets in the workout that are "Processed best"
     - If None, go to Save all step
     - If some, go to Calc PRs step
     */
    
    PFQuery *querySets = [Set query];
    [querySets fromLocalDatastore];
    [querySets whereKey:@"workout" equalTo:workout];
    [querySets whereKey:@"active" equalTo:@"Processed Best"];
    [querySets orderByAscending:@"timestamp"];
    NSArray *setArray = [querySets findObjects];
    if (setArray.count == 0) {
        NSLog(@"No 'best' sets found; starting final save");
        [self finalSave:workout];
    } else {
        NSLog(@"Found 'best' sets - processing");
        NSString *result = [self calcPRsInWorkout:workout];
        //NSLog(@"Results of bestset processing: %@", result);
        if ([result isEqual:@"Success"]) {
            //NSLog(@"Final save...");
            [self finalSave:workout];
        }
        
    }
    
}

-(NSString *)calcPRsInWorkout:(Workout *)workout {
    // This should either return a success marker, or a fail marker
    // This should find all the best sets that haven't been processed, and determine whether they are PRs
    
    
    /*
     Calc PRs step: for each set that is "Pre-processed best" (there should only be one per exercise), use a QueryInBackground to get the previous PR (you must filter for sets that are not "Pre-processed best" to ensure you don't return yourself). When it returns, go back to the secondary thread using GCD.
     - If fail, then stop and UNLOCK
     - If success, then determine whether you have a PR, increment CE / workout, then change status to "Fully Pre-processed". Go to Final Save [DO NOT SAVE]
     
    */
    
    NSLog(@"Beginning processing of best set to find PR");
    PFQuery *queryCEs = [CompletedExercise query];
    [queryCEs fromLocalDatastore];
    [queryCEs whereKey:@"workout" equalTo:workout];
    [queryCEs orderByAscending:@"timestamp"];
    [queryCEs includeKey:@"exercise"];
    NSArray *objectsCEs2 = [queryCEs findObjects];
    
    for (CompletedExercise *completedExercise in objectsCEs2) {
        //NSLog(@"Looking for a best set in CE: %@", completedExercise);
        
        // Get the best set so far
        PFQuery *queryBestSetInWorkout = [Set query];
        [queryBestSetInWorkout fromLocalDatastore];
        [queryBestSetInWorkout whereKey:@"workout" equalTo:workout];
        [queryBestSetInWorkout whereKey:@"completedExercise" equalTo:completedExercise];
        [queryBestSetInWorkout whereKey:@"active" equalTo:@"Processed Best"];
        queryBestSetInWorkout.limit = 1;
        NSArray *objectsBestSetArray = [queryBestSetInWorkout findObjects];
        if (objectsBestSetArray.count > 0) {
            Set *bestSet = [objectsBestSetArray firstObject];
            
            //NSLog(@"Found the best set: %@", bestSet);
            
            // Get the PR for the exercise
            NSLog(@"Looking for the previous PR");
            PFQuery *querySetPR = [Set query];
            [querySetPR whereKey:@"exercise" equalTo:completedExercise.exercise];
            [querySetPR whereKey:@"pr" equalTo:[NSNumber numberWithBool:YES]];
            [querySetPR whereKey:@"active" equalTo:@"Complete"];
            [querySetPR orderByDescending:@"reps"];
            [querySetPR orderByDescending:@"weight"];
            querySetPR.limit = 1;
            
            NSError *error = nil;
            NSArray *array = [querySetPR findObjects:&error];
            if (!error) {
                NSLog(@"No error: %@", error);
                NSLog(@"Main thread? %@", [NSNumber numberWithBool:[NSThread isMainThread]]);
                NSLog(@"No error when looking for previous PR - see the array: %@", array);
                int bestWeight = 0;
                int bestReps = 0;
                if (array.count > 0) {
                    // This means there was a previous PR
                    Set *setPR = [array firstObject];
                    bestWeight = setPR.weight.intValue;
                    bestReps = setPR.reps.intValue;
                }
                if (bestSet.weight.intValue > bestWeight) { bestSet.pr = YES; }
                if ((bestSet.weight.intValue == bestWeight) & (bestSet.reps.intValue > bestReps)) { bestSet.pr = YES; }
                if (bestSet.pr) {
                    //NSLog(@"We have determined it was a PR");
                    completedExercise.pr = YES;
                    workout.prCount = [NSNumber numberWithInt:(workout.prCount.intValue + 1)];
                    completedExercise.exercise.prWeight = bestSet.weight;
                    completedExercise.exercise.prReps = bestSet.reps;
                    [completedExercise.exercise pin];
                    [completedExercise pin];
                    [workout pin];
                } else {
                    //NSLog(@"it wasn't a PR :(");
                }
                
                bestSet.active = @"Fully Pre-processed";
                NSLog(@"About to pin the Best Set");
                [bestSet pin];
            } else {
                // This means the connection must be bad, and it wasn't able to pull the current PR. Cancel save.
                self.isSaving = NO;
                //NSLog(@"Failed to pull the PR");
                return @"Failed";
            }
            
            
            
        } else {
            // This means that the best set was already processed, or that it resided in another CE - no big deal
            //NSLog(@"No best set found for this workout");
        }
        
    
    }
    
    //NSLog(@"Returning SUCCESS is calculating PRs");
    return @"Success";
}


-(void)finalSave:(Workout *)workout {
    /*
     Final Save: Change status of workout and CEs to "Complete" and save. unlock.
     - If fail, UNLOCK and change back to "Fully Pre-processed"
     */
    
    NSLog(@"Beginning final save");
    PFQuery *querySets = [Set query];
    [querySets fromLocalDatastore];
    [querySets whereKey:@"workout" equalTo:workout];
    [querySets orderByAscending:@"timestamp"];
    [querySets whereKey:@"active" equalTo:@"Fully Pre-processed"];
    NSLog(@"Querying sets...");
    NSArray *setArray = [querySets findObjects];
    NSLog(@"Found %lu sets", (unsigned long)setArray.count);
    for (Set *set in setArray) {
        NSLog(@"Beginning for loop through sets");
        set.active = @"Complete";
        [set pin];
        NSError *error = nil;
        [set save:&error];
        if (!error) {
            
        } else {
            NSLog(@"Error saving sets: %@", error);
            set.active = @"Fully Pre-processed";
            [set pin];
            self.isSaving = NO;
            return;
        }
    }
    
    PFQuery *queryCEs = [CompletedExercise query];
    [queryCEs fromLocalDatastore];
    [queryCEs whereKey:@"workout" equalTo:workout];
    [queryCEs whereKey:@"active" equalTo:@"Active"];
    [queryCEs orderByAscending:@"timestamp"];
    [queryCEs includeKey:@"exercise"];
    NSArray *ceArray = [queryCEs findObjects];
    for (CompletedExercise *ce in ceArray) {
        if (ce.pr) {
            NSError *error = nil;
            [ce.exercise save:&error];
            if (!error) {
                
            } else {
                self.isSaving = NO;
                return;
            }
        }
        ce.active = @"Complete";
        [ce pin];
        NSError *error = nil;
        [ce save:&error];
        if (!error) {
            
        } else {
            ce.active = @"Active";
            [ce pin];
            self.isSaving = NO;
            return;
        }
    }
    workout.active = @"Complete";
    NSError *error = nil;
    [workout save:&error];
    if (!error) {
        // Nothing to do :)
    } else {
        workout.active = @"Raw Complete";
        [workout pin];
    }

    self.isSaving = NO;
    NSLog(@"Final save completed and isSaving var updated to bool: %@", [NSNumber numberWithBool:self.isSaving]);
}

/*
 BEFORE saving the workout, set all workouts, CEs, sets to "Raw Complete"
 
 Run this whenever the view is viewed
 1. Lock it so that it cannot be started again
 2. Find the oldest "Raw Complete" workout
 3. Look for sets that are "Raw Complete" from that workout
     - If none, go to PR check step
     - else go to Process Raw step
 
 
 Processing step: Go through all exercises, for each pick the top set; set it to "Pre-processed Best"; remaining sets set to "Fully pre-processed" AND SAVE these sets
      - Go to calc PR step
 
 PR check step: Look for sets in the workout that are "Pre-processed best"
     - If None, go to Save all step
     - If some, go to Calc PRs step
 
 
 Calc PRs step: for each set that is "Pre-processed best" (there should only be one per exercise), use a QueryInBackground to get the previous PR (you must filter for sets that are not "Pre-processed best" to ensure you don't return yourself). When it returns, go back to the secondary thread using GCD.
     - If fail, then stop and UNLOCK
     - If success, then determine whether you have a PR, increment CE / workout, then change status to "Complete" AND SAVE set. Go to Final Save
 
 Final Save: Change status of workout and CEs to "Complete" and save. unlock.

 ALTERNATIVE:
 View is opened... run SaveWorkouts
 
 Initial set search: Lock, then Find all unsaved sets
    - If none, go to CE search
    - If some, then saveallinbackground
        - Would need clientIDs
        - If it fails, I'm going to need to individually check which items saved properly and which didn't
 
 
 
 
 
 
 
 
 
 
 
 
 VERSION 2!!!!
 
 BEFORE saving the workout, set all workouts, CEs, sets to "Raw Complete"
 
 
 Run this whenever the view is viewed
 1. Lock it so that it cannot be started again
 2. Find the oldest "Raw Complete" workout
 3. Look for sets that are "Active" from that workout [USED TO BE "RAW COMPLETE"]
 - If none, go to PR check step
 - else go to Process Raw step
 
 
 Processing step: Go through all exercises, for each pick the top set; set it to "Pre-processed Best"; remaining sets set to "Fully pre-processed" [NO SAVE] [NOTE: A premiminary protective measure would reorder to rename the others first]
 - Go to calc PR step
 
 PR check step: Look for sets in the workout that are "Pre-processed best"
 - If None, go to Save all step
 - If some, go to Calc PRs step
 
 
 Calc PRs step: for each set that is "Pre-processed best" (there should only be one per exercise), use a QueryInBackground to get the previous PR (you must filter for sets that are not "Pre-processed best" to ensure you don't return yourself). When it returns, go back to the secondary thread using GCD.
 - If fail, then stop and UNLOCK
 - If success, then determine whether you have a PR, increment CE / workout, then change status to "Fully Pre-processed". Go to Final Save [DO NOT SAVE]
 
 Final Save: Change status of workout and CEs to "Complete" and save. unlock.
 - If fail, UNLOCK
 
 ALTERNATIVE:
 View is opened... run SaveWorkouts
 
 Initial set search: Lock, then Find all unsaved sets
 - If none, go to CE search
 - If some, then saveallinbackground
 - Would need clientIDs
 - If it fails, I'm going to need to individually check which items saved properly and which didn't
 
 
 
 
 
 
 
 */

-(void)saveWorkouts {
    self.isSaving = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       PFQuery *queryWorkouts = [Workout query];
                       [queryWorkouts fromLocalDatastore];
                       [queryWorkouts whereKey:@"active" equalTo:@"Processing"];
                       [queryWorkouts orderByDescending:@"completedAt"];
                       NSArray *objectsActiveWorkout = [queryWorkouts findObjects];
                       
                       if (objectsActiveWorkout.count > 0) {
                           NSLog(@"Found workout to save: %@", [objectsActiveWorkout firstObject]);
                           Workout *activeWorkout = [objectsActiveWorkout firstObject];
                           
                           //activeWorkout.active = @"Saving";
                           //[activeWorkout pin];
                           
                           
                           PFQuery *queryCEs2 = [CompletedExercise query];
                           [queryCEs2 fromLocalDatastore];
                           [queryCEs2 whereKey:@"workout" equalTo:activeWorkout];
                           [queryCEs2 orderByAscending:@"timestamp"];
                           NSArray *objectsCEs2 = [queryCEs2 findObjects];
                           
                           for (CompletedExercise *completedExercise in objectsCEs2) {
                               
                               // Get the best set so far
                               PFQuery *querySetPR = [Set query];
                               [querySetPR whereKey:@"exercise" equalTo:completedExercise.exercise];
                               [querySetPR orderByDescending:@"reps"];
                               [querySetPR orderByDescending:@"weight"];
                               querySetPR.limit = 1;
                               
                               // We would need error logic here to unlock and give up in the case of failure
                               NSArray *array = [querySetPR findObjects];
                               
                               int bestWeight = 0;
                               int bestReps = 0;
                               if (array.count > 0) {
                                   Set *setPR = [array firstObject];
                                   bestWeight = setPR.weight.intValue;
                                   bestReps = setPR.reps.intValue;
                               }
                               
                               
                               PFQuery *querySets = [Set query];
                               [querySets fromLocalDatastore];
                               [querySets whereKey:@"workout" equalTo:activeWorkout];
                               [querySets whereKey:@"exercise" equalTo:completedExercise.exercise];
                               [querySets orderByAscending:@"timestamp"];
                               [querySets orderByDescending:@"reps"];
                               [querySets orderByDescending:@"weight"];
                               [querySets includeKey:@"completedExercise"];
                               [querySets includeKey:@"workout"];
                               querySets.limit = 1;
                               NSArray *objectsSets = [querySets findObjects];
                               Set *bestSet = [objectsSets firstObject];
                               if ((bestSet.weight.intValue > bestWeight) | (bestSet.weight.intValue == bestWeight & bestSet.reps.intValue > bestReps)) {
                                   bestSet.pr = YES;
                                   bestSet.completedExercise.pr = YES;
                                   bestSet.workout.prCount = [NSNumber numberWithInt:(bestSet.workout.prCount.intValue + 1)];
                                   [bestSet pin];
                                   [bestSet.completedExercise pin];
                                   [bestSet.workout pin];
                               }
                               
                               
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
                       } else {
                           
                       }
                       
                       
                       
                       
                       dispatch_async(dispatch_get_main_queue(),
                                      ^{
                                          self.isSaving = NO;
                                          [self.tableView reloadData];
                                      });
                   });
    
}


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    //[query orderByAscending:@"name"];
    [query orderByDescending:@"completedAt"];
    // If Pull To Refresh is enabled, query against the network by default.
    //if (self.pullToRefreshEnabled) {
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //}
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    //if (self.objects.count == 0) {
    //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    //}
    
    return query;
}


/*
 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
 static NSString *CellIdentifier = @"Cell";
 
 PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 if (cell == nil) {
 cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 // Configure the cell
 cell.textLabel.text = [object objectForKey:self.textKey];
 cell.imageView.file = [object objectForKey:self.imageKey];
 
 return cell;
 }
 */

/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [self.objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - UITableViewDataSource

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the object from Parse and reload the table view
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, and save it to Parse
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    
    NSLog(@"Clicked a row");
    // Open the completed exercise view
    self.selectedWorkout = [self.objects objectAtIndex:indexPath.row];
    NSLog(@"Picked out the workout");
    [self performSegueWithIdentifier:@"ViewWorkoutDetails" sender:self];
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual: @"ViewWorkoutDetails"]) {
        // Send the CompletedExercise over
        NSLog(@"Performing segue");

        WorkoutDetailsTableViewController *destinationViewController = segue.destinationViewController;
        
        NSLog(@"Found the destination controller");
        
        NSLog(@"The workout we're trying to pass, goddamit: %@", self.selectedWorkout);

        NSLog(@"Destionation view controller: %@",destinationViewController);
        //NSLog(@"Destionation view controller - selected workout: %@",destinationViewController.selectedWorkout);
        destinationViewController.selectedWorkout = self.selectedWorkout;
        
        NSLog(@"Assigned the workout");
        
    }
    
    
}

@end
