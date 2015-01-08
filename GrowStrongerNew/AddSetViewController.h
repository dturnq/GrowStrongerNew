//
//  AddSetViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/7/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *weight;
@property (weak, nonatomic) IBOutlet UIButton *reps;
@property (weak, nonatomic) IBOutlet UITextField *nextWeight;
@property (weak, nonatomic) IBOutlet UITextField *nextReps;
- (IBAction)saveSet:(id)sender;

@end
