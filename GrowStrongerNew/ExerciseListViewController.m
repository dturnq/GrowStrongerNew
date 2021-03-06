//
//  ExerciseListViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/29/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "ExerciseListViewController.h"
#import "Exercise.h"
#import "AddExerciseViewController.h"


@interface ExerciseListViewController ()

@end

@implementation ExerciseListViewController

-(IBAction)unwindToExerciseList:(UIStoryboardSegue *)unwindSegue
{
    PFUser *user = [PFUser currentUser];
    
    // If the user clicked "Save", then save
    if ([unwindSegue.identifier  isEqual: @"SaveExercise"]) {
        
        AddExerciseViewController* addExerciseViewController = unwindSegue.sourceViewController;
        
        if (addExerciseViewController.new) {
            Exercise *exercise = [Exercise object];
            exercise.name = addExerciseViewController.nameTextField.text;
            exercise.nameLowercase = [addExerciseViewController.nameTextField.text lowercaseString];
            exercise.user = user;
            exercise.exerciseType = addExerciseViewController.exerciseType;
            [exercise saveEventually:^(BOOL succeeded, NSError *error) {
                [self loadObjects];
            }];
        } else {
            Exercise *exercise = addExerciseViewController.exercise;
            exercise.name = addExerciseViewController.nameTextField.text;
            exercise.nameLowercase = [addExerciseViewController.nameTextField.text lowercaseString];
            exercise.exerciseType = addExerciseViewController.exerciseType;
            [exercise saveEventually:^(BOOL succeeded, NSError *error) {
                [self loadObjects];
            }];
        }
        
        
    }
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"Exercise"];
    self = [super initWithCoder:aDecoder];
    NSLog(@"BLAH BLAH it loaded");
    if (self) {
        // The className to query on
        self.parseClassName = @"Exercise";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 100;
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


#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [PFObject pinAllInBackground:self.objects];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {
     NSLog(@"QueryForTable called");
     
     PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
     // If Pull To Refresh is enabled, query against the network by default.
     //if (self.pullToRefreshEnabled) {
     //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     //}
     
     // If no objects are loaded in memory, we look to the cache first to fill the table
     // and then subsequently do a query against the network.
     //if (self.objects.count == 0) {
     //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
     //}
     
     [query orderByAscending:@"nameLowercase"];
     
     return query;
 }

 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     static NSString *CellIdentifier = @"ExerciseCell";
 
     PFTableViewCell *cell = (PFTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
 
     // Configure the cell
     cell.textLabel.text = [object objectForKey:self.textKey];
     //cell.imageView.file = [object objectForKey:self.imageKey];
 
 return cell;
 }



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
    NSLog(@"Did select row at index path");
    self.selectedExercise = [self.objects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditExerciseSegue" sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqual: @"EditExerciseSegue"]) {
        NSLog(@"Segue!");
        UINavigationController *nav = segue.destinationViewController;
        AddExerciseViewController *destinationViewController = (AddExerciseViewController *)[nav topViewController];
        destinationViewController.new = NO;
        destinationViewController.exercise = self.selectedExercise;
        
    } else if ([segue.identifier isEqual: @"NewExerciseSegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        AddExerciseViewController *destinationViewController = (AddExerciseViewController *)[nav topViewController];
        destinationViewController.new = YES;
    }
    
    
}


@end
