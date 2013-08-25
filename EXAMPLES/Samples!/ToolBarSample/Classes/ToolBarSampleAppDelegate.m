//
//  ToolBarSampleAppDelegate.m
//  ToolBarSample
//
//  Created by Reshma Nayak on 27/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import "ToolBarSampleAppDelegate.h"
#import "ToolBarSampleViewController.h"

@implementation ToolBarSampleAppDelegate

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
