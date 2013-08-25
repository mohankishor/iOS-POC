//
//  Media_BrowserAppDelegate.m
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "Media_BrowserAppDelegate.h"
#import "MBAppController.h"
#import "NSApplication+Relaunch.h"

@implementation Media_BrowserAppDelegate

@synthesize window;

- (void) awakeFromNib
{
//	NSLog(@"Media Browser Initialized");
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification 
{

}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
//	NSLog(@"App Terminated");
}

@end
