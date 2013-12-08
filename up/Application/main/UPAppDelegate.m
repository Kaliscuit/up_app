//
//  UPAppDelegate.m
//  up
//
//  Created by joy.long on 13-10-28.
//  Copyright (c) 2013年 me.v2up. All rights reserved.
//

#import "UPAppDelegate.h"
#import "UPHomeViewController.h"
#import "UPCommonHelper.h"
#import "MobClick.h"
#import "Flurry.h"
#import <AdSupport/AdSupport.h>

@interface UPAppDelegate()<UPNetworkHelperDelegate> {
    UPNetworkHelper *_networkHelper;
}

@end
@implementation UPAppDelegate
@synthesize homeViewController = _homeViewController;
@synthesize homeNavigationController = _homeNavigationController;

- (void)dealloc {
    _homeNavigationController = nil;
   
    _homeViewController = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _networkHelper = [[UPNetworkHelper alloc] init];
    _networkHelper.delegate = self;
    
    [MobClick startWithAppkey:UMongAppKey];
//    [MobClick setLogEnabled:YES];
    
    [Flurry startSession:FlurryAppkey];
//    [Flurry setDebugLogEnabled:YES];
    
    _homeViewController = [[UPHomeViewController alloc] init];
    
    _homeNavigationController = [[UINavigationController alloc] initWithRootViewController:_homeViewController];
    [_homeNavigationController setNavigationBarHidden:YES];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = _homeNavigationController;
    [self.window makeKeyAndVisible];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert| UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
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

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //注册成功，上报token到服务器
    char token[66] = {0};
    int off = 0;
    const unsigned char *t = (const unsigned char *) [deviceToken bytes];
    for (int i = 0; i < deviceToken.length; i++) {
        sprintf(token + off, "%02x", t[i] );
        off += 2;
    }
    NSString *tokenString = [NSString stringWithCString:token encoding:NSUTF8StringEncoding];
    
    [[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:@"DeviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDictionary *dict = @{@"deviceToken": tokenString,
                           @"adfa":[self advertisingIdentifier],
                           };
    
    [_networkHelper postAPNSWithDictionar:dict];
    NSLog(@"deviceToken -------OOOOOO---- : %@", tokenString);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}
- (void)requestSuccess:(NSDictionary *)responseObject withTag:(NSNumber *)tag {
    if ([tag integerValue] == Tag_Ios_Apns) {
        
    }
}

- (void)requestFail:(NSError *)error withTag:(NSNumber *)tag {
    
}

- (void)requestSuccessWithFailMessage:(NSString *)message withTag:(NSNumber *)tag {
    
}

- (NSString *)advertisingIdentifier {
    NSString *idfa = @"";
    
    NSUUID *tempUuid = [[ASIdentifierManager sharedManager] advertisingIdentifier];
    if (nil == tempUuid) {
        NSAssert(FALSE, @"did not get advertising identifier");
    } else {
        idfa = [tempUuid UUIDString];
        idfa = [idfa stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }

    
    return idfa;
}
@end
