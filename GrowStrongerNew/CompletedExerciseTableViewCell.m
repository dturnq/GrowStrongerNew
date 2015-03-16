//
//  CompletedExerciseTableViewCell.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/6/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "CompletedExerciseTableViewCell.h"

@implementation CompletedExerciseTableViewCell

/*
-(id)initWithCoder:(NSCoder *)aDecoder {
    NSLog(@"Running initwithcoder");
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        NSLog(@"Should e running the code for the labels...");
        NSArray *setLabels = [[NSArray alloc] initWithObjects: self.set1, self.set2, self.set3, self.set4, nil];
        
        for (UILabel *setLabel in setLabels) {
            
            setLabel.layer.borderColor = SetBorderColor.CGColor; // [UIColor darkGrayColor].CGColor;
            setLabel.layer.borderWidth = 1.0;
            setLabel.layer.cornerRadius = 4.0;
        }
        
    } else {
        NSLog(@"No self, arg");
    }
    
    return self;
}
*/

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
