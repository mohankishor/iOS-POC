//
//  iTouchAppDelegate.m
//  iTouch
//
//  Created by Anand Kumar Y N on 19/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "iTouchAppDelegate.h"
#import "iTouchViewController.h"

@implementation iTouchAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
