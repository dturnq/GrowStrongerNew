//
//  AddExerciseViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/29/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddExerciseViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *exerciseNameTextField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *exerciseTypeSegmentControl;
- (IBAction)exerciseTypeChanged:(UISegmentedControl *)sender;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) NSString *exerciseType;

@end
