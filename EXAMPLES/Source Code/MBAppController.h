//
//  MBAppController.h
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RBSplitView.h"

@class RBSplitSubview;
@interface MBAppController :  NSObject <NSMenuDelegate> 
{	
	IBOutlet RBSplitView		*mPhotoSplitView;
	IBOutlet RBSplitView		*mLinkSplitView;
	
	IBOutlet NSSlider			*mPhotoSlider;					// slider control for photo visiblity
	IBOutlet NSButton			*mZoomIn;						// control for photo zoom in 	
	IBOutlet NSButton			*mZoomOut;						// control for photo zoom out	
	
		//Interface main window and other windows
	IBOutlet NSWindow			*mMainWindow;					// main window for media browser
	IBOutlet NSWindow			*mAboutWindow;					// window showing details about media browser
	IBOutlet NSTextView			*mAboutTextView;				// text view to display about media browser
	IBOutlet NSWindow			*mPreferencesWindow;			// window for preferences	
	IBOutlet NSWindow			*mMetaDataRetrieverWindow;
	
	NSStatusItem				*mStatusBarItem;				
	NSRect						mWindowFrame;
	
	IBOutlet NSButton			*mShowSmallSizeText;
	IBOutlet NSPopUpButton		*mToolBarDisplay;
	IBOutlet NSPopUpButton		*mAppAvailability;
	IBOutlet NSPopUpButton		*mAppVisibility;
	IBOutlet NSToolbar			*mToolBar;
	
	BOOL						mAppStatusBar;					// used for status bar app to be restored or not
	BOOL						mAppDock;						// used for dock item app to be restored or not
	BOOL						mWindowVisible;
}

	// Interface control action methods
- (IBAction) photoButtonSelected			:	(id)sender;
- (IBAction) linkButtonSelected				:	(id)sender;
- (IBAction) aboutMediaBrowser				:	(id)sender;
- (IBAction) preferencesButtonSelected		:	(id)sender;
- (IBAction) toolBarDisplaySelected			:	(id)sender;
- (IBAction) showSmallSizeTextSelected		:	(id)sender;
- (IBAction) appAvailabilitySelected		:	(id)sender;
- (IBAction) appVisibilitySelected			:	(id)sender;
- (IBAction) sendEmailSelected				:	(id)sender;
- (IBAction) relaunchApp					:	(id)sender;
- (IBAction) closePreferenceWindow			:	(id)sender;

	// Instance methods
- (void) setupInfoWindow; 
- (void) launchStatusBarApp;

	// User default methods
- (void) loadUserDefaultValues;
- (void) storeUserDefaultValues;

@end