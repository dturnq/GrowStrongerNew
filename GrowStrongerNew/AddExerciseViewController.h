//
//  AddExerciseViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/29/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Exercise.h"
#import "CustomSegmentControl.h"

@interface AddExerciseViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet CustomSegmentControl *exerciseTypeSegmentControl;
- (IBAction)exerciseTypeChanged:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) NSString *exerciseType;

@property BOOL new;
@property (strong, nonatomic) Exercise *exercise;

@end
