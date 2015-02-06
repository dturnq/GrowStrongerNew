//
//  ActiveWorkoutTableViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "ActiveWorkoutTableViewController.h"
#import "AddExerciseTableViewCell.h"
#import "SelectExerciseViewController.h"
#import "AddSetViewController.h"
#import "CompletedExerciseTableViewCell.h"
#import <UIKit/UIKit.h>
#import "Stopwatch.h"
#import "SaveWorkoutViewController.h"


@interface ActiveWorkoutTableViewController ()

-(void)reloadWorkoutData;
@property (weak, nonatomic) CompletedExercise *selectedCompletedExercise;
@property (weak, nonatomic) NSIndexPath *selectedIndexPath;


@end

@implementation ActiveWorkoutTableViewController


-(IBAction)unwindToActiveWorkout:(UIStoryboardSegue *)unwindSegue
{
    
    if ([unwindSegue.identifier isEqual: @"SelectExercise"]) {
        SelectExerciseViewController* selectExerciseViewController = unwindSegue.sourceViewController;
        PFUser *user = [PFUser currentUser];
        CompletedExercise *completedExercise = [CompletedExercise object];
        completedExercise.user = user;
        completedExercise.workout = self.activeWorkout;
        completedExercise.exercise = selectExerciseViewController.selectedExercise;
        completedExercise.position = self.activeWorkout.totalCompletedExercises;
        [completedExercise pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self reloadWorkoutData];
        }];
        self.activeWorkout.totalCompletedExercises = [NSNumber numberWithInt:[self.activeWorkout.totalCompletedExercises intValue] + 1];
        [self.activeWorkout pin];
    
    } else if ([unwindSegue.identifier isEqual:@"SaveSet"]) {

        NSArray *rowsToReload = [NSArray arrayWithObject:self.selectedIndexPath];
        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    //PFUser *user = [PFUser currentUser];
    
    // If the user clicked "Save", then save
    // Adjust this code to work save the set in the cache
    /*
    if ([unwindSegue.identifier  isEqual: @"SaveNewExercise"]) {
        AddExerciseViewController* addExerciseViewController = unwindSegue.sourceViewController;
        Exercise *exercise = [Exercise object];
        exercise.name = addExerciseViewController.nameTextField.text;
        exercise.user = user;
        exercise.exerciseType = addExerciseViewController.exerciseType;
        [exercise saveEventually];
    }
     */
    
}


-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Active Workout: %@", self.activeWorkout);
}

#pragma mark - Background Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Prep the stopwatch
    Stopwatch *stopwatch = [[Stopwatch alloc] init];
    [stopwatch setWorkoutStartTime:self.activeWorkout.beganAt];
    
    
    PFQuery *queryForTime = [Set query];
    [queryForTime fromLocalDatastore];
    [queryForTime whereKey:@"workout" equalTo:self.activeWorkout];
    [queryForTime orderByDescending:@"timestamp"];
    
    

    
    [queryForTime getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        //NSLog(@"Last set completed: %@", object);
        //NSLog(@"Timestamp: %@", [object objectForKey:@"timeStamp"]);
        if (object == nil) {
            [stopwatch setSetStartTime:self.activeWorkout.beganAt];
        } else {
            [stopwatch setSetStartTime:[object objectForKey:@"timeStamp"]];
        }
        
    }];
    
    
    //[self reloadWorkoutData];
    
    // TEMP offline hack to allow dev - add a local CE
    
    /*
    PFQuery *query = [CompletedExercise query];
    [query fromLocalDatastore];
    [query whereKey:@"workout" equalTo:self.activeWorkout];
    [query orderByAscending:@"position"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        //if (objects == 0) {
            Exercise *tempExercise = [Exercise object];
            tempExercise.name = @"Temporary exercise";
            tempExercise.exerciseType = @"Weightlifting";
            [tempExercise pin];
            
            CompletedExercise *tempCompletedExercise = [CompletedExercise object];
            tempCompletedExercise.exercise = tempExercise;
            tempCompletedExercise.workout = self.activeWorkout;
            [tempCompletedExercise pin];
            
            
        //}
        
        [self reloadWorkoutData];
        
    }];
    */
    
    
    //[self.tableView reloadData];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// My own reload method

-(void)reloadWorkoutData
{
    // Get the CompletedExercises in this workout
    PFQuery *query = [CompletedExercise query];
    [query fromLocalDatastore];
    [query whereKey:@"workout" equalTo:self.activeWorkout];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.completedExerciseArray = objects;
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.completedExerciseArray.count + 1;
}


#pragma mark - Workout Management



#pragma mark - Table Management

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    
    if (indexPath.row + 1 != (self.completedExerciseArray.count + 1)) // Add one to indexPath because it starts at 0; add one to count because we want the "extra" row
    {
        // This is where we put any code related to the actual workout cells
        static NSString *reuseIdentifier = @"WorkoutExercise";
        CompletedExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        // THIS MAY BE THE MISSING PIECE
        if (cell == nil) {
            cell = [[CompletedExerciseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        // Configure the cell...
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
        
    }
    else
    {
     
        
        // This is where we put any code related to the actual workout cells
        static NSString *reuseIdentifier = @"AddExerciseToWorkout";
        AddExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        // THIS MAY BE THE MISSING PIECE
        if (cell == nil) {
            cell = [[AddExerciseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        }
        
        return cell;
    }
}


- (void)configureCell:(CompletedExerciseTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // We will eventually use this to configure the cell

    
    // Get the specific exercise
    CompletedExercise *completedExercise = [self.completedExerciseArray objectAtIndex:indexPath.row];
    
    // Set the exercise name
    cell.name.text = [[completedExercise exercise] name];
    
    
    PFQuery *query = [Set query];
    [query fromLocalDatastore];
    [query whereKey:@"completedExercise" equalTo:completedExercise];
    [query addAscendingOrder:@"timeStamp"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

        if (objects.count == 0) {

            cell.set1.text = @"Tap to record your first set";
            cell.set2.text = @"";
            cell.set3.text = @"";
            cell.set4.text = @"";
        } else {

            NSArray *setLabels = [[NSArray alloc] initWithObjects: cell.set1, cell.set2, cell.set3, cell.set4, nil];
            
            NSUInteger i = 1;
            for (UILabel *setLabel in setLabels) {
                if ((int*)i <= (int*)objects.count) {
                    NSString *labelText = [[[objects objectAtIndex:(i-1)] weight] stringValue];
                    NSString *labelText2 = [labelText stringByAppendingString:@"/"];
                    NSString *labelText3 = [labelText2 stringByAppendingString:[[[objects objectAtIndex:(i-1)] reps] stringValue]];
                    setLabel.text =  labelText3;
                } else {
                    setLabel.text =  @"";
                }
                i++;
            }
            
        }
    }];
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 != (self.completedExerciseArray.count + 1)) {
        return 75;
    } else {
        return 50;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 != (self.completedExerciseArray.count + 1)) {
        // Open the completed exercise view
        self.selectedCompletedExercise = [self.completedExerciseArray objectAtIndex:indexPath.row];
        self.selectedIndexPath = indexPath;

        [self performSegueWithIdentifier:@"SegueToAddSet" sender:self];
        
    } else {
        // Go to the add exercise view
    }
}

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
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


// Override to support rearranging the table view.
/*
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 // TO DO THIS, I'LL NEED A VARIABLE THAT STORES THE CELL #
    
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Action Sheet
- (IBAction)cancelWorkout:(id)sender {
    
    
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure you with to cancel your workout?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Undo"
                                               destructiveButtonTitle:@"Yes, cancel workout"
                                                    otherButtonTitles: nil];
    
    [actionSheet showInView:self.view];
    
};

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        [self performSegueWithIdentifier:@"CancelWorkout" sender:self];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual: @"SegueToAddSet"]) {
        // Send the CompletedExercise over

        UINavigationController *navController = segue.destinationViewController;
        AddSetViewController *destinationViewController = (AddSetViewController *)navController.topViewController;
        destinationViewController.completedExercise = self.selectedCompletedExercise;

    } else if ([segue.identifier isEqual:@"CancelWorkout"]) {
        self.activeWorkout.active = @"Garbage";
    } else if ([segue.identifier isEqual:@"NameWorkout"]) {
        UINavigationController *navController = segue.destinationViewController;
        SaveWorkoutViewController *destinationViewController = (SaveWorkoutViewController *)navController.topViewController;
        destinationViewController.activeWorkout = self.activeWorkout;
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
