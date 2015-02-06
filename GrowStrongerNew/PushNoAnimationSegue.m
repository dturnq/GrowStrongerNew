//
//  PushNoAnimationSegue.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 1/10/15.
//  Copyright (c) 2015 David Turnquist. All rights reserved.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue

-(void)perform {
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:NO];
}

@end
