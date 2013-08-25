//
//  RDAppDelegate.m
//  RedDeluxe
//
//  Created by Test on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDAppDelegate.h"

@interface RDAppDelegate() 
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
@end

@implementation RDAppDelegate
@synthesize locationManager;
@synthesize currentLocation;
@synthesize userCoordinates;

NSString *const FBSessionStateChangedNotification = @"com.example.Login:FBSessionStateChangedNotification";

@synthesize window = _window;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = (id)self;
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    [locationManager startUpdatingLocation];
    return YES;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation 
{
    
    self.currentLocation = newLocation;
    userCoordinates.latitude = newLocation.coordinate.latitude; 
    userCoordinates.longitude = newLocation.coordinate.longitude; 
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
{	// this means the user switched back to this app without completing a login in Safari/Facebook App
 	if (FBSession.activeSession.state == FBSessionStateCreatedOpening) {
		[FBSession.activeSession close];
	}
	// so we close our session and start over
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  	[FBSession.activeSession close];

}

// Open a facebook Session
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
	NSArray *permissions = [[NSArray alloc] initWithObjects:@"publish_actions", nil];
    return [FBSession openActiveSessionWithPermissions:permissions allowLoginUI:allowLoginUI completionHandler:^(FBSession *session, FBSessionState state,NSError *error) {
		[self sessionStateChanged:session state:state error:error];
		NSLog(@"%i", [session state]);
	}];
}

// Pass the url with session description to handleOpenURL of FBSession on return from safari or facebook app
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [FBSession.activeSession handleOpenURL:url];
}

// Callback for facebook Session changes
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
				NSLog(@" A valid User session has been created");
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }    
    [[NSNotificationCenter defaultCenter] postNotificationName:FBSessionStateChangedNotification object:session];
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}


@end
