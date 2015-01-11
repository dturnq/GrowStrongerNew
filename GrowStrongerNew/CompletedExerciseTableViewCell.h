//
//  CompletedExerciseTableViewCell.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/6/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompletedExerciseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *set1;
@property (weak, nonatomic) IBOutlet UILabel *set2;
@property (weak, nonatomic) IBOutlet UILabel *set3;
@property (weak, nonatomic) IBOutlet UILabel *set4;

@end
