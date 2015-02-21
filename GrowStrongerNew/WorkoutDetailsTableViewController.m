//
//  WorkoutDetailsTableViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 2/10/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "WorkoutDetailsTableViewController.h"
#import "WorkoutDetailHeaderTableViewCell.h"
#import "WorkoutDetailCETableViewCell.h"

@interface WorkoutDetailsTableViewController ()

@end

@implementation WorkoutDetailsTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithClassName:@"CompletedExercise"];
    self = [super initWithCoder:aDecoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"CompletedExercise";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"exercise.name";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    NSLog(@"PFQUery objects: %@", self.objects);
    for (PFObject *object in self.objects) {
        NSLog(@"object.exercise: %@", object[@"exercise"][@"name"]);
    }
    
    // This method is called every time objects are loaded from Parse via the PFQuery
}


// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    //[query orderByAscending:@"name"];
    [query whereKey:@"workout" equalTo:self.selectedWorkout];
    [query includeKey:@"exercise"];
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

// Override to  change the numbe of rows in the section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.objects.count + 1);
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150;
    } else {
        return 75;
    }
}

 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     
     
     if (indexPath.row == 0) {
         static NSString *CellIdentifier = @"WorkoutDetailHeaderCell";
         
         WorkoutDetailHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
         
         if (cell == nil) {
             cell = [[WorkoutDetailHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         
         //cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.workoutNameLabel.text = self.selectedWorkout.name;
         //cell.setsLabel.text = [self.selectedWorkout.totalSets stringValue];
         //cell.repsLabel.text = [self.selectedWorkout.totalReps stringValue];
         //cell.totalWeightLabel.text = [self.selectedWorkout.totalWeight stringValue];
         //cell.prCountLabel.text = [self.selectedWorkout.prCount stringValue];
         
         return cell;
         
     } else {
      
         static NSString *CellIdentifier = @"WorkoutDetailCECell";
         
         WorkoutDetailCETableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
         
         if (cell == nil) {
             cell = [[WorkoutDetailCETableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         
         //cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.ceNameLabel.text = [[object objectForKey:@"exercise"] objectForKey:@"name"];
         //cell.setsLabel.text = [[[object objectForKey:@"exercise"] objectForKey:@"totalSets"] stringValue];
         //cell.repsLabel.text = [[[object objectForKey:@"exercise"] objectForKey:@"totalReps"] stringValue];
         //cell.totalWeightLabel.text = [[[object objectForKey:@"exercise"] objectForKey:@"totalWeight"] stringValue];
         //cell.prCountLabel.text = [[object objectForKey:@"exercise"] objectForKey:@"pr"] ? @"YES" : @"NO";
         
         return cell;
     }

     
 }



 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
     
     //if (doneLoading == YES) {
         if (indexPath.row < 1) {
             return nil;
         //} else if (indexPath.row > (self.objects.count + NUMBER_OF_STATIC_CELLS)) {
         //    return nil;
         } else {
             return [super objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]];
         }
     //}
     
     return nil;
     
     //return [self.objects objectAtIndex:indexPath.row];
 }
 


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
 *.

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
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
