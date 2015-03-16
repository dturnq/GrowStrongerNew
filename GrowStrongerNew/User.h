//
//  User.h
//  GrowStrongerNew
//
//  Created by David Turnquist on 3/1/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFUser<PFSubclassing>

@property (retain) NSString *firstname;
@property (retain) NSString *lastname;
@property (retain) NSString *locationFacebook;
@property (retain) NSString *gender;

+ (User *)user;
+ (BOOL)isLoggedIn;


@end
