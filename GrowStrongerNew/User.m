//
//  User.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 3/1/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "User.h"
#import <Parse/PFObject+Subclass.h>

@implementation User

+ (void)load {
    [self registerSubclass];
}

@dynamic firstname;
@dynamic lastname;
@dynamic locationFacebook;
@dynamic gender;


+ (User *)user {
    return (User *)[PFUser user];
}

+ (BOOL)isLoggedIn {
    return [User currentUser] ? YES: NO;
}

@end
