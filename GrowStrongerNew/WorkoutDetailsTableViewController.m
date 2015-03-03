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
#import "WorkoutSummaryTableViewCell.h"
#import "CompletedExerciseTableViewCell.h"

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
        return 120;
    } else {
        return 75;
    }
}


 // Override to customize the look of a cell representing an object. The default is to display
 // a UITableViewCellStyleDefault style cell with the label being the textKey in the object,
 // and the imageView being the imageKey in the object.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
     
     
     if (indexPath.row == 0) {
         static NSString *CellIdentifier = @"WorkoutSummaryCell";
         
         WorkoutSummaryTableViewCell *cell = (WorkoutSummaryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
         if (cell == nil) {
             cell = [[WorkoutSummaryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         
         NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
         [dateFormatter setDateFormat:@"EEEE', 'MMM d', 'y' @ 'ha"];
         NSString *formattedDate = [dateFormatter stringFromDate:self.selectedWorkout.beganAt];
         
         NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
         [timeFormatter setDateFormat:@"EEEE', 'MMM d', 'y' @ 'ha"];
         
         NSCalendar *calendar = [NSCalendar currentCalendar];
         unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
         NSDateComponents *timeBreakdown = [calendar components:unitFlags fromDate:self.selectedWorkout.beganAt toDate:self.selectedWorkout.completedAt options:0];
         
         NSString *formattedTime = [NSString stringWithFormat:@"%ld:%02ld", (long)[timeBreakdown hour], (long)[timeBreakdown minute]];
         
         NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
         [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
         
         NSString *prText = [NSString stringWithFormat:@"%@ PRs", [numberFormatter stringFromNumber:self.selectedWorkout.prCount]];
         NSString *exercisesText = [NSString stringWithFormat:@"%@ exercises", [numberFormatter stringFromNumber:self.selectedWorkout.totalCompletedExercises]];
         NSString *setsText = [NSString stringWithFormat:@"%@ sets", [numberFormatter stringFromNumber:self.selectedWorkout.totalSets]];
         NSString *repsText = [NSString stringWithFormat:@"%@ reps", [numberFormatter stringFromNumber:self.selectedWorkout.totalReps]];
         NSString *lbsText = [NSString stringWithFormat:@"%@ lbs", [numberFormatter stringFromNumber:self.selectedWorkout.totalWeight]];
         
         
         // Configure the cell
         cell.backgroundColor = NavColor;
         cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.width / 2;
         cell.profileImage.clipsToBounds = YES;
         cell.nameLabel.text = self.selectedWorkout.name;
         cell.dateLabel.text = formattedDate;
         cell.prLabel.text = prText;
         cell.timeLabel.text = formattedTime;
         cell.exercisesLabel.text = exercisesText;
         cell.setsLabel.text = setsText;
         cell.repsLabel.text = repsText;
         cell.lbsLabel.text = lbsText;
         //cell.imageView.file = [object objectForKey:self.imageKey];
         
         //cell.selectionStyle = UITableViewCellSelectionStyleNone;
         //cell.nameLabel.text = self.selectedWorkout.name;
         //cell.setsLabel.text = [self.selectedWorkout.totalSets stringValue];
         //cell.repsLabel.text = [self.selectedWorkout.totalReps stringValue];
         //cell.totalWeightLabel.text = [self.selectedWorkout.totalWeight stringValue];
         //cell.prCountLabel.text = [self.selectedWorkout.prCount stringValue];
         
         return cell;
         
     } else {
      
         static NSString *CellIdentifier = @"WorkoutExercise";
         
         CompletedExerciseTableViewCell *cell = (CompletedExerciseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
         
         if (cell == nil) {
             cell = [[CompletedExerciseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
         }
         
         //cell.selectionStyle = UITableViewCellSelectionStyleNone;
         //cell.ceNameLabel.text = [[object objectForKey:@"exercise"] objectForKey:@"name"];
         
         
         // Get the specific exercise
         CompletedExercise *completedExercise = object;
         
         // Set the exercise name
         cell.name.text = [[completedExercise exercise] name];
         
         
         PFQuery *query = [Set query];
         [query fromLocalDatastore];
         [query whereKey:@"completedExercise" equalTo:completedExercise];
         [query addAscendingOrder:@"timeStamp"];
         [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
             
             /*
              if (objects.count == 0) {
              
              cell.set1.text = @"Tap to record your first set";
              cell.set2.text = @"";
              cell.set3.text = @"";
              cell.set4.text = @"";
              } else {
              */
             
             NSArray *setLabels = [[NSArray alloc] initWithObjects: cell.set1, cell.set2, cell.set3, cell.set4, nil];
             
             NSUInteger i = 1;
             for (UILabel *setLabel in setLabels) {
                 if ((int*)i <= (int*)objects.count) {
                     NSString *labelText = [[[objects objectAtIndex:(i-1)] weight] stringValue];
                     NSString *labelText2 = [labelText stringByAppendingString:@"/"];
                     NSString *labelText3 = [labelText2 stringByAppendingString:[[[objects objectAtIndex:(i-1)] reps] stringValue]];
                     setLabel.text =  labelText3;
                 } else {
                     setLabel.text =  @"/";
                 }
                 setLabel.layer.borderColor = SetBorderColor.CGColor; // [UIColor darkGrayColor].CGColor;
                 setLabel.layer.borderWidth = 1.0;
                 setLabel.layer.cornerRadius = 4.0;
                 i++;
             }
             
             //}
         }];
         
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
