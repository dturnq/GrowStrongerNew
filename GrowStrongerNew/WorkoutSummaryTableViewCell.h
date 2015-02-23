//
//  WorkoutSummaryTableViewCell.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 2/22/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface WorkoutSummaryTableViewCell : PFTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *prLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *exercisesLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lbsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@end
