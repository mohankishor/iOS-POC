//
//  NSApplication+Relaunch.h
//  Media Browser
//
//  Created by Sandeep GS on 21/06/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define MBApplicationRelaunchDaemon @"relaunch"

@interface NSApplication (Relaunch)

- (void)relaunch:(id)sender;

@end
