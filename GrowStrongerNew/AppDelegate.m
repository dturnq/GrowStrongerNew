//
//  AppDelegate.m
//  GrowStrongerNew
//
//  Created by David Turnquist on 9/7/14.
//  Copyright (c) 2014 David Turnquist. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ExerciseListViewController.h"
#import "GlobalHeader.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBLoginView class];
    
    [Parse enableLocalDatastore];
    
#if TARGET_OS_EMBEDDED
    [Parse setApplicationId:@"z9I9OwkOY5OWPrmK7hxx3xrP0jyT8L4cEdxaMF9e"
                  clientKey:@"sidQ5E7lcGUIx43dcSj0sswBLVB0xYHbxYifrnSJ"];
#endif
    
#if TARGET_IPHONE_SIMULATOR
    [Parse setApplicationId:@"5OMX6s1s85KZIhIHGyV8YFEf9jLY9WFrKHR07Box"
                  clientKey:@"7mjtRajEjD1K495BweofyBsJNbb7Qle0yBC2TpeL"];
#endif
    
    
    // Parse Analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Parse Facebook Integration
    [PFFacebookUtils initializeFacebook];
    
    // Parse ACL
    //[PFUser enableAutomaticUser];
    PFACL *defaultACL = [PFACL ACL];
    
    // Optionally enable public read access while disabling public write access.
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"FRAG"] = @"bar";
    [testObject saveInBackground];
    
    // Nav Color
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:27/255.0 green:106/255.0 blue:165/255.0 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1.0]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:251/255.0 green:199/255.0 blue:35/255.0 alpha:1.0]];
    
    return YES;
}

// For Facebook single-sign-on
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
