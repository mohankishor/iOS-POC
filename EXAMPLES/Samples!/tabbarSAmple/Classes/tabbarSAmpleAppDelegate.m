//
//  tabbarSAmpleAppDelegate.m
//  tabbarSAmple
//
//  Created by Reshma Nayak on 08/10/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "tabbarSAmpleAppDelegate.h"
#import "tabbarSAmpleViewController.h"

@implementation tabbarSAmpleAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize rootController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
	
    // Override point for customization after app launch  
	[window addSubview:rootController.view];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[rootController release];
    [viewController release];
    [window release];
    [super dealloc];
}


@end
