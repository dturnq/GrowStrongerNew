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


@interface ActiveWorkoutTableViewController ()

-(void)reloadWorkoutData;

@end

@implementation ActiveWorkoutTableViewController

-(IBAction)unwindToActiveWorkout:(UIStoryboardSegue *)unwindSegue
{
    
    if ([unwindSegue.identifier isEqual: @"SelectExercise"]) {
        NSLog(@"Unwind SELECT called");
        SelectExerciseViewController* selectExerciseViewController = unwindSegue.sourceViewController;
        PFUser *user = [PFUser currentUser];
        CompletedExercise *completedExercise = [CompletedExercise object];
        completedExercise.user = user;
        completedExercise.workout = self.activeWorkout;
        completedExercise.exercise = selectExerciseViewController.selectedExercise;
        NSLog(@"Compelted exercise PRE-SAVE: %@", completedExercise);
        NSLog(@"Compelted exercise JUST EXERCISE, PRE-SAVE: %@", completedExercise.exercise);
        [completedExercise pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSLog(@"Object pinned");
            [self reloadWorkoutData];
        }];
    
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


#pragma mark - Background Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self reloadWorkoutData];
    
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
    NSLog(@"Running custom ReloadWorkoutData method");
    // Get the CompletedExercises in this workout
    PFQuery *query = [CompletedExercise query];
    [query fromLocalDatastore];
    [query whereKey:@"workout" equalTo:self.activeWorkout];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.completedExerciseArray = objects;
        [self.tableView reloadData];
        NSLog(@"Finished reloading table");
        NSLog(@"Completed exercise array: %@",self.completedExerciseArray);
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSLog(@"Number of rows: %lu", self.completedExerciseArray.count + 1);
    return self.completedExerciseArray.count + 1;
}


#pragma mark - Workout Management





#pragma mark - Table Management

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    
    
    if (indexPath.row + 1 != (self.completedExerciseArray.count + 1)) // Add one to indexPath because it starts at 0; add one to count because we want the "extra" row
    {
        // This is where we put any code related to the actual workout cells
        NSLog(@"Running the completed exercise cell code");
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
        NSLog(@"Running the completed exercise cell code");
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
    NSLog(@"Configure the cell");
    cell.name.text = [[[self.completedExerciseArray objectAtIndex:indexPath.row] exercise] name];
    
    
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

/*
// Override to support rearranging the table view.
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
#warning Incomplete implementation - must pull CExercise and pass it to set view controller
        AddSetViewController *destinationViewController = segue.destinationViewController;
        //destinationViewController.completedExercise =
    }
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
