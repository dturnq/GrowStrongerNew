//
//  RecordNewWorkoutViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "RecordNewWorkoutViewController.h"

@interface RecordNewWorkoutViewController ()

@end

@implementation RecordNewWorkoutViewController


-(IBAction)unwindToRecordStandby:(UIStoryboardSegue *)unwindSegue
{
    
    // If the user clicked "Save", then save
    if ([unwindSegue.identifier  isEqual: @"CancelWorkout"]) {
        NSLog(@"Workout Cancelled");
        // We will eventually need to unpin and delete all objects related to the workout
    }
    
}


#pragma mark - Core methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
