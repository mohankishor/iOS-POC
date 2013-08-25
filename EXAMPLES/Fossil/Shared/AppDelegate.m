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
#import "FLMovieViewController.h"
#import "FLCatalogWebViewController.h"
@implementation AppDelegate

@synthesize window = mWindow;
@synthesize navigationController = mNavigationController;
@synthesize alertDisplay = mAlertDisplay;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{    
	// Override point for customization after application launch.
	mPool = [[NSAutoreleasePool alloc] init];
	
	UINavigationController *navController = [[FLRootNavigationController alloc] init];
	self.navigationController = navController;
	
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* facebookCookies = [cookies cookiesForURL:
								[NSURL URLWithString:@"http://login.facebook.com"]];
	
	for (NSHTTPCookie* cookie in facebookCookies) {
		[cookies deleteCookie:cookie];
	}
	
	
	[navController release];
	
	if(FL_IS_IPAD) 
	{
		FLCatalogMenuViewController *viewController = [[FLCatalogMenuViewController alloc] initWithNibName:@"FLCatalogMenuViewController_iPad" bundle:nil];
			[self.navigationController pushViewController:viewController animated:NO];
		self.navigationController.delegate = viewController;
		[viewController release];
	} 
	else
	{
		FLCatalogMenuViewController *viewController = [[FLCatalogMenuViewController alloc] initWithNibName:@"FLCatalogMenuViewController_iPhone" bundle:nil];
		[self.navigationController pushViewController:viewController animated:NO];
		[viewController release];
	}
	
	FLMovieViewController *movie = [[FLMovieViewController alloc] initWithNibName:@"FLMovieViewController" bundle:nil];
	[self.navigationController pushViewController:movie animated:NO];
	[movie release];
	
	
	
	
	[mWindow addSubview:self.navigationController.view];
	[mWindow makeKeyAndVisible];
	//[self.navigationController.view release];
	return YES;
}

- (void) applicationWillResignActive:(UIApplication *) application
{
	NSNotification *appSentToBackGroundNotification = [NSNotification notificationWithName:@"appSentToBackGroundNotification" object:nil];
	[[NSNotificationCenter defaultCenter] postNotification:appSentToBackGroundNotification];
	/*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}
//4.2 version
- (void) applicationDidBecomeActive:(UIApplication *) application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* facebookCookies = [cookies cookiesForURL:
								[NSURL URLWithString:@"http://login.facebook.com"]];
	
	for (NSHTTPCookie* cookie in facebookCookies) {
		[cookies deleteCookie:cookie];
	}
	
}
//3.2 version
- (void) applicationWillTerminate:(UIApplication *) application
{
    /*
     Called when the application is about to terminate.
     */
	NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	NSArray* facebookCookies = [cookies cookiesForURL:
								[NSURL URLWithString:@"http://login.facebook.com"]];
	
	for (NSHTTPCookie* cookie in facebookCookies) {
		 [cookies deleteCookie:cookie];
	}
	
}

#pragma mark -
#pragma mark Memory management

- (void) applicationDidReceiveMemoryWarning:(UIApplication *) application
{
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	[mPool release];
	mPool = [[NSAutoreleasePool alloc] init];
}

- (void) dealloc
{
	self.navigationController = nil;
	self.window = nil;
	[mPool release];
    [super dealloc];
}


@end
