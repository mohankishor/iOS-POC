//
//  ScrollViewExampleAppDelegate.m
//  ScrollViewExample
//
//  Created by Chakra on 31/03/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import "ScrollViewExampleAppDelegate.h"
#import "ScrollViewExampleViewController.h"

@implementation ScrollViewExampleAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
