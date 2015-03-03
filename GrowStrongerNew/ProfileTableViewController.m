//
//  ProfileTableViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 2/28/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "ProfileTableViewController.h"
#import <Parse/Parse.h>
#import "Workout.h"
#import "User.h"

@interface ProfileTableViewController ()

-(void)configureView;

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"User data: %@", [PFUser user]);
    NSLog(@"");
    
    [self configureView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(void)configureView {
    
    // Turn of the damn seperators
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    User *currentUser = [User currentUser];
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser.firstname, currentUser.lastname];
    self.subTitleLabel.text = currentUser.locationFacebook;
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 1.0f;
    self.profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    
    
    
    PFQuery *queryWorkouts = [Workout query];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:now];
    [components setDay:1];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    self.monthLabel.text = [NSString stringWithFormat:@"Stats for %@", [dateFormatter stringFromDate:now]];
    [dateFormatter setDateFormat:@"yyyy"];
    self.yearLabel.text = [NSString stringWithFormat:@"Stats for %@", [dateFormatter stringFromDate:now] ];
    
    NSDate *beginningOfMonth = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    NSLog(@"beginningOfMonth: %@", beginningOfMonth);
    
    [queryWorkouts whereKey:@"beganAt" greaterThanOrEqualTo:beginningOfMonth];
    queryWorkouts.limit = 1000;
    
    NSLog(@"beginning query");
    [queryWorkouts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.workoutCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)objects.count];
        
        NSLog(@"Query completed");
        
        int sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.prCount intValue];
        }
        self.prCountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.totalCompletedExercises intValue];
        }
        self.exerciseCountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.totalSets intValue];
        }
        self.setCountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.totalReps intValue];
        }
        self.repCountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.totalWeight intValue];
        }
        self.weightTotalLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        
    }];
    
    
    PFQuery *queryWorkouts2 = [Workout query];
    
    [components setMonth:1];
    
    NSDate *beginningOfYear = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    [queryWorkouts2 whereKey:@"beganAt" greaterThanOrEqualTo:beginningOfMonth];
    queryWorkouts2.limit = 1000;
    [queryWorkouts2 whereKey:@"beganAt" greaterThanOrEqualTo:beginningOfYear];
    [queryWorkouts2 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        // Set the current year labels
        
        self.workoutYearCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)objects.count];
        
        NSLog(@"Query completed");
        
        int sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.prCount intValue];
        }
        self.prYearCountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.totalCompletedExercises intValue];
        }
        self.exerciseYearCountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.totalSets intValue];
        }
        self.setYearCountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.totalReps intValue];
        }
        self.repYearCountLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
        
        sum = 0;
        for (Workout *workout in objects) {
            sum += [workout.totalWeight intValue];
        }
        self.weightYearTotalLabel.text = [numberFormatter stringFromNumber:[NSNumber numberWithInt:sum]];
    }];
    
    
}

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
