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

@property (weak, nonatomic) IBOutlet UIView *navExtensionView;


// History
@property (weak, nonatomic) IBOutlet UILabel *dayC1;
@property (weak, nonatomic) IBOutlet UILabel *dateC1;
@property (weak, nonatomic) IBOutlet UILabel *timeC1;
@property (weak, nonatomic) IBOutlet UILabel *dayC2;
@property (weak, nonatomic) IBOutlet UILabel *dateC2;
@property (weak, nonatomic) IBOutlet UILabel *timeC2;
@property (weak, nonatomic) IBOutlet UILabel *dayC3;
@property (weak, nonatomic) IBOutlet UILabel *dateC3;
@property (weak, nonatomic) IBOutlet UILabel *timeC3;
@property (weak, nonatomic) IBOutlet UILabel *dayC4;
@property (weak, nonatomic) IBOutlet UILabel *dateC4;
@property (weak, nonatomic) IBOutlet UILabel *timeC4;

@property (weak, nonatomic) IBOutlet UILabel *setC1R1;
@property (weak, nonatomic) IBOutlet UILabel *setC1R2;
@property (weak, nonatomic) IBOutlet UILabel *setC1R3;
@property (weak, nonatomic) IBOutlet UILabel *setC1R4;
@property (weak, nonatomic) IBOutlet UILabel *setC1R5;

@property (weak, nonatomic) IBOutlet UILabel *setC2R1;
@property (weak, nonatomic) IBOutlet UILabel *setC2R2;
@property (weak, nonatomic) IBOutlet UILabel *setC2R3;
@property (weak, nonatomic) IBOutlet UILabel *setC2R4;
@property (weak, nonatomic) IBOutlet UILabel *setC2R5;

@property (weak, nonatomic) IBOutlet UILabel *setC3R1;
@property (weak, nonatomic) IBOutlet UILabel *setC3R2;
@property (weak, nonatomic) IBOutlet UILabel *setC3R3;
@property (weak, nonatomic) IBOutlet UILabel *setC3R4;
@property (weak, nonatomic) IBOutlet UILabel *setC3R5;

@property (weak, nonatomic) IBOutlet UILabel *setC4R1;
@property (weak, nonatomic) IBOutlet UILabel *setC4R2;
@property (weak, nonatomic) IBOutlet UILabel *setC4R3;
@property (weak, nonatomic) IBOutlet UILabel *setC4R4;
@property (weak, nonatomic) IBOutlet UILabel *setC4R5;

@end
