//
//  AddExerciseViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/29/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "AddExerciseViewController.h"

@interface AddExerciseViewController ()

@end

@implementation AddExerciseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.exerciseType = @"Weightlifting";
    
    //UIImage *redPixel = [UIImage imageNamed:@"yellowRectangle.png"];
    //[self.exerciseTypeSegmentControl backgroundImageForState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    NSLog(@"View did load - new? %hhd", self.new);
    if (!self.new) {
        NSLog(@"Editing! Exercise: %@", self.exercise);
        self.nameTextField.text = self.exercise.name;
        self.exerciseType = self.exercise.exerciseType;
        int segmentValue = 0;
        if ([self.exercise.exerciseType isEqual: @"Calisthenics"]) {
            segmentValue = 1;
            self.descriptionLabel.text = @"An exercise that uses only your bodyweight as resistance";
        } else {
            self.descriptionLabel.text = @"An exercise that uses weights as resistance";
        }
        self.exerciseTypeSegmentControl.selectedSegmentIndex = segmentValue;
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)exerciseTypeChanged:(UISegmentedControl *)sender
{
    switch (self.exerciseTypeSegmentControl.selectedSegmentIndex) {
        case 0:
            self.exerciseType = @"Weightlifting";
            self.descriptionLabel.text = @"An exercise that uses weights as resistance";
            break;
            
        case 1:
            self.exerciseType = @"Calisthenics";
            self.descriptionLabel.text = @"An exercise that uses only your bodyweight as resistance";
            break;
            
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}


@end
