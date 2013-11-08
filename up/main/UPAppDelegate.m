//
//  UPAppDelegate.m
//  up
//
//  Created by joy.long on 13-10-28.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPAppDelegate.h"
#import "UPSearchViewController.h"
#import "UPIndexScrollViewController.h"
#import "UPCommonHelper.h"
@implementation UPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UPIndexScrollViewController *indexScrollViewController = [[UPIndexScrollViewController alloc] init];
    
    UINavigationController *indexScrollNavigationController = [[UINavigationController alloc] initWithRootViewController:indexScrollViewController];
//    if ([UPCommonHelper isIOS7]) {
//        self.window = [[[UIWindow alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20)] autorelease];
//    } else {
        self.window = [[[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
//    }
    
    self.window.rootViewController = indexScrollNavigationController;
    [indexScrollNavigationController setNavigationBarHidden:YES];
    [indexScrollViewController release];
    [indexScrollNavigationController release];
    [self.window makeKeyAndVisible];

    
//    [self requestChange]; // 是否要拉取
    
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
