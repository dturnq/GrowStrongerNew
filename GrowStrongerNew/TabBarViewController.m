//
//  TabBarViewController.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 9/7/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TabBarViewController.h"


@interface TabBarViewController ()

@end

@implementation TabBarViewController //<PFLogInViewControllerDelegate>

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
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{

    // Check whether logged in; log in if necessary
    PFUser *currentuser = [PFUser currentUser];
    if (currentuser) {
        // Awesome
    } else {
        // Push the next view controller without animation
        PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
        logInController.delegate = self;
        logInController.fields = //PFLogInFieldsUsernameAndPassword | PFLogInFieldsLogInButton
        // PFLogInFieldsSignUpButton |
        //| PFLogInFieldsPasswordForgotten
        //|
        PFLogInFieldsFacebook;
        logInController.facebookPermissions = [NSArray arrayWithObjects:@"email", nil];
        logInController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:logInController animated:YES completion:nil];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login Methods

- (void)logInViewController:(PFLogInViewController *)controller didLogInUser:(PFUser *)user {
    NSLog(@"Did log in");
    
    
    NSLog(@"Attempting to pull email");
    FBRequest *request = [FBRequest requestForMe];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary
            NSDictionary *userData = (NSDictionary *)result;
            
            NSLog(@"User: %@", user);
            NSLog(@"Result Line 77: %@", userData);
            
            [user setObject:userData[@"id"] forKey:@"facebookID"];
            [user setObject:userData[@"email"] forKey:@"email"];
            
            if (userData[@"first_name"]) {
                [user setObject:userData[@"first_name"] forKey:@"firstname"];
            }
            
            if (userData[@"last_name"]) {
                [user setObject:userData[@"last_name"] forKey:@"lastname"];
            }
            
            if (userData[@"gender"]) {
                [user setObject:userData[@"gender"] forKey:@"gender"];
            }
            
            if (userData[@"location"][@"name"]) {
                NSLog(@"not null... yahoo");
                [user setObject:userData[@"location"][@"name"] forKey:@"locationFacebook"];
            }
            
            NSLog(@"Line 93 - attempting to save");
            
            
            
            [user saveEventually:^(BOOL succeeded, NSError *error) {
                if(!error) {
                    // Successful save
                    NSLog(@"user saved");
                } else {
                    // Error
                    NSLog(@"User Save Error: %@", error);
                }
            }];
        }
    }];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Signed up");
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


@end