//
//  ProfileEditViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 3/4/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "ProfileEditViewController.h"
#import "User.h"

@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    User *currentUser = [User currentUser];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
    self.profileImageView.clipsToBounds = YES;
    self.profileImageView.layer.borderWidth = 1.0f;
    self.profileImageView.layer.borderColor = [UIColor blackColor].CGColor;
    
    self.firstNameTextField.text = currentUser.firstname;
    self.lastNameTextField.text = currentUser.lastname;
    self.cityTextField.text = currentUser.locationFacebook;
    
    self.emailTextField.text = currentUser.email;
    
    int segmentValue = 0;
    if ([currentUser.gender isEqual: @"female"]) {
        segmentValue = 1;
    }
    self.genderSegmentControl.selectedSegmentIndex = segmentValue;

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

- (IBAction)genderSegmentControlChanged:(id)sender {
    
    
    User *user = [User currentUser];
    
    switch (self.genderSegmentControl.selectedSegmentIndex) {
        case 0:
            user.gender  = @"male";
            break;
            
        case 1:
            user.gender  = @"female";
            break;
            
        default:
            break;
    }
     
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.firstNameTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}


@end
