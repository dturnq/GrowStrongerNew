//
//  WorkoutDetailHeaderTableViewCell.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 2/10/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WorkoutDetailHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *workoutNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *setsLabel;
@property (weak, nonatomic) IBOutlet UILabel *repsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalWeightLabel;
@property (weak, nonatomic) IBOutlet UILabel *prCountLabel;

@end
