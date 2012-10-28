//
//  AppDelegate.m
//  doorControl
//
//  Created by user on 9/27/12.
//  Copyright (c) 2012 cse4471. All rights reserved.
//

#import "AppDelegate.h"
#import "UserSettings.h"
#import "NSMutableURLRequest+sendPost.h"
#import "FirstViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[UIApplication sharedApplication]registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
    
    
    return YES;
}


-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"got notification");
    FirstViewController *fc = [((UITabBarController*)self.window.rootViewController).viewControllers objectAtIndex:0];
    
    [fc processesMessage:userInfo];
    
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
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *appid = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *_deviceToken = [deviceToken description];
    _deviceToken =  [_deviceToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    //set in userDefautls?
    
    //can I get the user specified name of the device?
    NSString *deviceName = [[UIDevice currentDevice] name];
    
    
    [[UserSettings userSettings]setDeviceName:deviceName];
    [[UserSettings userSettings]setDeviceToken:_deviceToken];
    
	NSLog(@"%@ token for %@ is: %@", deviceName, appid, _deviceToken);
    //something here to upload the token to our server...
    //check if we sent the token, so we're not sending it ever time...and possilby haning at activate
    //also this kind of post thing, might be best severed as a category
    NSMutableURLRequest *postRequest = [[NSMutableURLRequest alloc]init];
    NSString *postString = [NSString stringWithFormat:@"devid=%@&appid=%@&devname=%@", _deviceToken, appid, deviceName];
    [postRequest sendPost:@"http://doorcontrol.theroyalwe.net/registerDevice.php" :postString delegate:nil];

    
    
    
    
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
@end
