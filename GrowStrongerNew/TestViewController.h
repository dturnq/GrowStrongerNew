//
//  TestViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/11/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface TestViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *numTestObjects;
- (IBAction)addTestObject:(id)sender;
- (IBAction)removeTestObject:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveObjectTest;
- (IBAction)saveObjectTestAction:(id)sender;
- (IBAction)testOrder:(id)sender;
- (IBAction)testSaveEventually:(id)sender;
- (IBAction)addSearchableTitle:(id)sender;

@property (strong, nonatomic) PFObject *testObject;
@end
