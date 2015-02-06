//
//  AddSetViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/7/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompletedExercise.h"
@class HorizontalPickerView;

@interface AddSetViewController : UIViewController <UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet HorizontalPickerView *horizontalPickerView;
@property (weak, nonatomic) CompletedExercise *completedExercise;
@property (weak, nonatomic) IBOutlet UIButton *weight;
@property (weak, nonatomic) IBOutlet UIButton *reps;
@property (weak, nonatomic) IBOutlet UITextField *nextWeight;
@property (strong, nonatomic) IBOutlet UILabel *setTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *nextReps;
- (IBAction)saveSet:(id)sender;
- (IBAction)selectWeightButton:(id)sender;
- (IBAction)selectRepsButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
