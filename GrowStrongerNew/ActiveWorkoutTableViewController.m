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


@interface ActiveWorkoutTableViewController ()

-(void)reloadWorkoutData;

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
        
        [completedExercise pinInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self reloadWorkoutData];
        }];
    
    }
    
    PFUser *user = [PFUser currentUser];
    
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
    NSLog(@"Reloading table");
    // Get the CompletedExercises in this workout
    PFQuery *query = [CompletedExercise query];
    [query fromLocalDatastore];
    [query whereKey:@"workout" equalTo:self.activeWorkout];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.completedExerciseArray = objects;
        [self.tableView reloadData];
        NSLog(@"Finished reloading table");
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

    
    
    
    if (indexPath.row + 1 != (self.completedExerciseArray.count + 1))
    {
        // This is where we put any code related to the actual workout cells
        NSLog(@"Running the completed exercise cell code");
        static NSString *reuseIdentifier = @"WorkoutExercise";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        
        // THIS MAY BE THE MISSING PIECE
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
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
        
        // Configure the cell...
        [self configureCell:cell atIndexPath:indexPath];
        return cell;
     
    
    }
    

    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 != (self.completedExerciseArray.count + 1)) {
        return 75;
    } else {
        return 50;
    }
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // We will eventually use this to configure the cell
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row + 1 != (self.completedExerciseArray.count + 1)) {
        // Open the competed exercise view
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

    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
