//
//  AppDelegate.m
//  WebTest
//
//  Created by Joe Fitzpatrick on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.

    MasterViewController *masterViewController = [[[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:masterViewController] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

    // Make sure that the URL Host is "Application"
    if ([[[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] compare:@"Application"] == NSOrderedSame)
    {
        // Extract the query portion and convert it into a parameter dictionary
        NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:1];
        
        for (NSString *param in [query componentsSeparatedByString:@"&"]) 
        {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if ([elts count] < 2) 
                continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        // For now, look for 'cmd' and 'val'
        NSString *cmd = [params objectForKey:@"cmd"];
        NSString *val = [params objectForKey:@"val"];

        if ([cmd compare:@"title"] == NSOrderedSame)
        {
            _navigationController.visibleViewController.title = val; 
        }
        else if ([cmd compare:@"buy"] == NSOrderedSame)
        {
            UIAlertView *alertView;
            alertView = [[UIAlertView alloc] initWithTitle:@"In-App Purchase"
                                                   message:val 
                                                  delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
            [_navigationController popViewControllerAnimated:YES];
        }
        else if ([cmd compare:@"get"] == NSOrderedSame)
        {
            UIAlertView *alertView;
            alertView = [[UIAlertView alloc] initWithTitle:@"Download Plan"
                                                   message:val 
                                                  delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            
            [_navigationController popViewControllerAnimated:YES];            
        }
        else if ([cmd compare:@"exit"] == NSOrderedSame)
        {
            [_navigationController popViewControllerAnimated:YES];
        }
        else
        {
            UIAlertView *alertView;
            alertView = [[UIAlertView alloc] initWithTitle:cmd
                                                   message:val 
                                                  delegate:nil 
                                         cancelButtonTitle:@"OK" 
                                         otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
    }
    
    return YES;
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
