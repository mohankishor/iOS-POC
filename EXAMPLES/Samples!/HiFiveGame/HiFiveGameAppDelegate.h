//
//  HiFiveGameAppDelegate.h
//  HiFiveGame
//
//  Created by Devika on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlayerInformation.h"
@interface HiFiveGameAppDelegate : NSObject <NSApplicationDelegate,NSWindowDelegate> {
    NSWindow *window;
	PlayerInformation *mPlayer;
}

@property (assign) IBOutlet NSWindow *window;

@end
