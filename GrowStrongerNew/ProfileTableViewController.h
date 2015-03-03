//
//  ProfileTableViewController.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 2/28/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *prCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *setCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *repCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *prYearCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *workoutYearCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *exerciseYearCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *setYearCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *repYearCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightYearTotalLabel;

@end
