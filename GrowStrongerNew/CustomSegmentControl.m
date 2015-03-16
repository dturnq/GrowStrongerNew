//
//  CustomSegmentControl.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 3/3/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "CustomSegmentControl.h"

@implementation CustomSegmentControl
/*
-(instancetype)initWithItems:(NSArray *)items {
    self = [super initWithItems:items];
    UIImage *redPixel = [UIImage imageNamed:@"yellowRectangle.png"];
    [self setBackgroundImage:redPixel forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:redPixel forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    return self;
}
*/

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIImage *redPixel = [UIImage imageNamed:@"whiteBackground30px.png"];
    [self setBackgroundImage:redPixel forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:redPixel forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:redPixel forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:redPixel forState:UIControlStateReserved barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:redPixel forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:redPixel forState:UIControlStateApplication barMetrics:UIBarMetricsDefault];
    
    UIImage *greyDivider = [UIImage imageNamed:@"greyVerticalDivider.png"];
    [self setDividerImage:greyDivider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setDividerImage:greyDivider forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self setDividerImage:greyDivider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}




@end
