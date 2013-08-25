//
//  CustomCellTableViewAppDelegate.m
//  CustomCellTableView
//
//  Created by Anand Kumar Y N on 26/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "CustomCellTableViewAppDelegate.h"
#import "CustomCellTableViewViewController.h"

@implementation CustomCellTableViewAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch
    
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	self.navigationController = aNavigationController;
	[aNavigationController release];
	[[self navigationController] setNavigationBarHidden:NO];
	[[[self navigationController] navigationBar] setTintColor:[UIColor orangeColor]];
	[window addSubview:navigationController.view];
    //[window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
