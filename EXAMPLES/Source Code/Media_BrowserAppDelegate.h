//
//  Media_BrowserAppDelegate.h
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class MBAppController;

@interface Media_BrowserAppDelegate : NSObject <NSApplicationDelegate> {
	IBOutlet NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
