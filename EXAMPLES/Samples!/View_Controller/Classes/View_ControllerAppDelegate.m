//
//  View_ControllerAppDelegate.m
//  View_Controller
//
//  Created by Anand Kumar Y N on 11/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "View_ControllerAppDelegate.h"
#import "View_ControllerViewController.h"

@implementation View_ControllerAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize navigationController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch   
	UINavigationController *myNavigationController=[[UINavigationController alloc]initWithRootViewController:viewController];
	self.navigationController=myNavigationController;
	
	[myNavigationController release];
	[[[self navigationController]navigationBar] setTintColor:[UIColor blueColor] ];
	[window addSubview:navigationController.view];
	
	
  //  [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
