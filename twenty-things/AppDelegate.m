//
//  AppDelegate.m
//  twenty-things
//
//  Created by Eric Ito on 3/6/14.
//  Copyright (c) 2014 Eric Ito. All rights reserved.
//

#import "AppDelegate.h"
#import "DSThingsViewController.h"
#import "DSNavController.h"
#import <ArcGIS/ArcGIS.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    DSThingsViewController *thingsVC = [[DSThingsViewController alloc] init];
    DSNavController *navController = [[DSNavController alloc] initWithRootViewController:thingsVC];

    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor]}];
    
    self.window.rootViewController = navController;
    return YES;
}

#pragma mark -
#pragma mark Background Fetch

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // pass the completion handler here so system can be notified that background fetch is done
    [AGSTask checkStatusForAllResumableTaskJobsWithCompletion:completionHandler];
}

#pragma mark -
#pragma mark Background NSURLSession Download

-(void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
    // in case a download finishes in the background we need to pass this to ArcGIS SDK
    [[AGSURLSessionManager sharedManager] setBackgroundURLSessionCompletionHandler:completionHandler forIdentifier:identifier];
}

@end
