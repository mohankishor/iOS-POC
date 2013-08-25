//
//  PhotoAppAppDelegate.m
//  PhotoApp
//
//  Created by Brandon Trebitowski on 7/28/09.
//  Copyright RightSprite 2009. All rights reserved.
//

#import "PhotoAppAppDelegate.h"
#import "PhotoAppViewController.h"

@implementation PhotoAppAppDelegate

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
