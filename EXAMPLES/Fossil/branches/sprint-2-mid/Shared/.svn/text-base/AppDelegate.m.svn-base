//
//  AppDelegate.m
//  Fossil
//
//  Created by Ganesh Nayak on 07/09/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "AppDelegate.h"
#import "FLRootNavigationController.h"
#import "FLCatalogMenuViewController.h"

@implementation AppDelegate

@synthesize window = mWindow;
@synthesize navigationController = mNavigationController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{    
    // Override point for customization after application launch.
	if(FL_IS_IPAD) 
	{
		FLCatalogMenuViewController *viewController = [[FLCatalogMenuViewController alloc] initWithNibName:@"FLCatalogMenuViewController_iPad" bundle:nil];
		[mNavigationController pushViewController:viewController animated:NO];
		[viewController release];
	} 
	else
	{
		FLCatalogMenuViewController *viewController = [[FLCatalogMenuViewController alloc] initWithNibName:@"FLCatalogMenuViewController_iPhone" bundle:nil];
		[mNavigationController pushViewController:viewController animated:NO];
		[viewController release];
	}
	[mWindow addSubview:mNavigationController.view];
    [mWindow makeKeyAndVisible];
	
	return YES;
}

- (void) applicationWillResignActive:(UIApplication *) application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void) applicationDidBecomeActive:(UIApplication *) application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}

- (void) applicationWillTerminate:(UIApplication *) application
{
    /*
     Called when the application is about to terminate.
     */
}

#pragma mark -
#pragma mark Memory management

- (void) applicationDidReceiveMemoryWarning:(UIApplication *) application
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (void) dealloc
{
	self.navigationController = nil;
	self.window = nil;
    [super dealloc];
}

@end
