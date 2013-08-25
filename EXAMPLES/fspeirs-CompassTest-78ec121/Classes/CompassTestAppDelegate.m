//
//  CompassTestAppDelegate.m
//  CompassTest
//
//  Created by Fraser Speirs on 18/06/2009.
//  Copyright Connected Flow 2009. All rights reserved.
//

#import "CompassTestAppDelegate.h"
#import "RootViewController.h"


@implementation CompassTestAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

