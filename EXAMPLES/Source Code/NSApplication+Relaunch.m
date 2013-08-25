//
//  NSApplication+Relaunch.m
//  Media Browser
//
//  Created by Sandeep GS on 21/06/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "NSApplication+Relaunch.h"

@implementation NSApplication (Relaunch)

- (void)relaunch:(id)sender
{
	NSString *daemonPath = [[NSBundle mainBundle] pathForResource:MBApplicationRelaunchDaemon ofType:nil];
//	NSLog(@"daemon path:%@    bundle:%@  process id:%d",daemonPath,[[NSBundle mainBundle]bundlePath],[NSString stringWithFormat:@"%d",[[NSProcessInfo processInfo]processIdentifier]]);
	[NSTask launchedTaskWithLaunchPath:daemonPath arguments:[NSArray arrayWithObjects:[[NSBundle mainBundle] bundlePath], [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] processIdentifier]], nil]];
	[self terminate:sender];
}

@end