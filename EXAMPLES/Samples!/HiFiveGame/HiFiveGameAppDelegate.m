//
//  HiFiveGameAppDelegate.m
//  HiFiveGame
//
//  Created by Devika on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HiFiveGameAppDelegate.h"
#import "PlayerInformation.h"
@implementation HiFiveGameAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	
	mPlayer=[[PlayerInformation alloc]init];
	
	[NSBundle loadNibNamed:@"PlayerInformation" owner:mPlayer];
	//[mPlayer.mPlayerWindow orderFront:nil];
	//int n=[mPlayer.mPlayerWindow runModal];
	//[NSApp runModalForWindow:mPlayer.mPlayerWindow];
	
}
-(BOOL)windowShouldClose:(id)sender
{
	if ([mPlayer.mPlayerWindow isVisible]) {
		[mPlayer.mPlayerWindow orderOut:self];
	}
	return YES;
}
-(void)dealloc
{
	[mPlayer release];
	[window release];
	[super dealloc];
}
@end
