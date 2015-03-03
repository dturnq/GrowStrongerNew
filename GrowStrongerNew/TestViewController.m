//
//  TestViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/11/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "TestViewController.h"
#import <Parse/Parse.h>
#import "Exercise.h"
#import "Workout.h"


@interface TestViewController ()

//@property (weak, nonatomic) PFObject *myObject;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
    [query fromLocalDatastore];
    [query whereKey:@"active" equalTo:@"Garbage"];
    self.numTestObjects.text = [NSString stringWithFormat:@"%ld", (long)[query countObjects]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)addTestObject:(id)sender {
    
    PFObject *object = [PFObject objectWithClassName:@"Workout"];
    object[@"active"] = @"Garbage";
    [object pin];
    //self.myObject = object;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
    [query fromLocalDatastore];
    [query whereKey:@"active" equalTo:@"Garbage"];
    self.numTestObjects.text = [NSString stringWithFormat:@"%ld", (long)[query countObjects]];
}

- (IBAction)removeTestObject:(id)sender {
    PFQuery *query = [PFQuery queryWithClassName:@"Workout"];
    [query fromLocalDatastore];
    [query whereKey:@"active" equalTo:@"Garbage"];
    PFObject *object = [query getFirstObject];
    
    PFQuery *querySet = [PFQuery queryWithClassName:@"Set"];
    [querySet fromLocalDatastore];
    [querySet whereKey:@"workout" equalTo:object];
    NSArray *sets = [querySet findObjects];
    for (PFObject *set in sets) {
        [set unpin];
    }
    
    PFQuery *queryCE = [PFQuery queryWithClassName:@"CompletedExercise"];
    [queryCE fromLocalDatastore];
    [queryCE whereKey:@"workout" equalTo:object];
    NSArray *cEs = [queryCE findObjects];
    for (PFObject *cE in cEs) {
        [cE unpin];
    }
    
    NSLog(@"Object: %@", object);
    [object unpin];
    
    PFQuery *query2 = [PFQuery queryWithClassName:@"Workout"];
    [query2 fromLocalDatastore];
    [query whereKey:@"active" equalTo:@"Garbage"];
    self.numTestObjects.text = [NSString stringWithFormat:@"%ld", (long)[query2 countObjects]];
}

- (IBAction)saveObjectTestAction:(id)sender {
    
    if (self.testObject == nil) {
        PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
        NSDate *now = [NSDate date];
        testObject[@"timestamp"] = now;
        self.testObject = testObject;
        NSLog(@"Created object: %@", self.testObject);
    }
    
    [self.testObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            NSLog(@"Saved object: %@", self.testObject);
        } else {
            NSLog(@"Error: %@", error);
        }
    }];
    
}

- (IBAction)testOrder:(id)sender {
    
    PFQuery *query = [PFQuery queryWithClassName:@"OrderTest"];
    [query orderByAscending:@"A"];
    [query orderByAscending:@"B"];
    NSArray *array = [query findObjects];
    NSLog(@"query result: %@", array);
}

- (IBAction)testSaveEventually:(id)sender {
    
    PFObject *object = [PFObject objectWithClassName:@"SaveEventuallyTest"];
    object[@"myVar"] = @"Test";
    [object pin];
    [object saveEventually];
    object[@"myVar"] = @"UpdatedValue";
    object[@"newVar"] = @"Test2";
    [object pin];
    [object saveEventually];
}

- (IBAction)addSearchableTitle:(id)sender {
    
    PFQuery *queryExercises = [Exercise query];
    queryExercises.limit = 1000;
    [queryExercises findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (Exercise *exercise in objects) {
            exercise.nameLowercase = [exercise.name lowercaseString];
        }
        [PFObject saveAllInBackground:objects];
    }];
    
    PFQuery *queryWorkouts = [Workout query];
    queryWorkouts.limit = 1000;
    [queryWorkouts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        for (Workout *workout in objects) {
            workout.nameLowercase = [workout.name lowercaseString];
        }
        [PFObject saveAllInBackground:objects];
    }];
    
}
@end
