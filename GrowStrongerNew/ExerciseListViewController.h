//
//  ExerciseListViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/29/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface ExerciseListViewController : PFQueryTableViewController

-(IBAction)unwindToExerciseList:(UIStoryboardSegue *)unwindSegue;

@end
