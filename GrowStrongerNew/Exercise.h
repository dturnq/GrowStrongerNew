//
//  Exercise.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 12/30/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>

@interface Exercise : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

@property (retain) PFUser *user;
@property (retain) NSString *name;
@property (retain) NSString *exerciseType;

@end
