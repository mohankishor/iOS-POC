//
//  DAppDelegate.m
//  DGeofence
//
//  Created by Darshan Sonde on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DAppDelegate.h"
#import "DViewController.h"

/* OVERVIEW
 
 DAppDelegate - shows the local notification posted.
 
 */

/* Local Notifications
 
 entering geo-fence. userInfo has "fence"->"identifier:NSString*", "isEntering"->"BOOL"
 exiting geo-fence. userInfo has "fence"->"identifier:NSString*", "isEntering"->"BOOL"
 failed geo-fence. userInfo nil
 
 
 */

/* NSNotifications
 
 "FenceChanged"
 sender - Fence:NSManagedObject 
 receiver - DViewController 
 userInfo - "fence"->NSManagedObject(sender)
 */

@implementation DAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if([launchOptions objectForKey:@"UIApplicationLaunchOptionsLocationKey"]!=nil) {
        if(application.applicationState == UIApplicationStateActive) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Got Location Event" 
                                                        message:@"Fire it UP!"
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
            [alert show];
        } else {
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            
            localNotification.alertBody = @"Firing Up location manager on app wake up!";
            localNotification.alertAction = @"OK";
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            
            [(DViewController*)self.window.rootViewController locationManager];
            NSAssert([(DViewController*)self.window.rootViewController locationManager],@"location manager could not be re initialized");
            [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
        }
    }
    return YES;
}
		
-(void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSString *alertString,*alertTitle;
    
    if([notification userInfo]==nil || [[notification userInfo] objectForKey:@"isEntering"] == nil) {
        alertTitle = @"Failed";
        alertString = @"Failed to monitor region";
    }
    else { 
        if([[[notification userInfo] objectForKey:@"isEntering"] boolValue]) {
            alertTitle = @"Beware!!";
            alertString = [NSString stringWithFormat:@"You Just Entered %@!!",[[notification userInfo] objectForKey:@"fence"]];
        } else {
            alertTitle = @"Leaving so soon?";
            alertString = [NSString stringWithFormat:@"Stay in %@ for some more time!!",[[notification userInfo] objectForKey:@"fence"]];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle 
                                                    message:alertString
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
