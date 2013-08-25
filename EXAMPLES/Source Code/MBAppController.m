//
//  MBAppController.m
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//
#import "MBAppController.h"
#import "NSWindow+Flipr.h"
#import "NSApplication+Relaunch.h"

#define		TEMPPATH			NSTemporaryDirectory()			// temporary path store for thumbnail photos
	// USER DEFAULT CONSTANTS
#define		SELECTEDVIEW	@"SelectedView"
#define		WINDOWSIZE		@"MainWindowSize"
#define		SEARCHTEXT		@"SearchFieldValue"
#define		STATUSBAR		@"StatusBarApp"
#define		TITLE			@"Title"

@implementation MBAppController
- (id) init
{
	self = [super init];
	if (self != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginMetaDataSheet) name:@"kStartMetaDataWindow" object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endMetaDataSheet) name:@"kEndMetaDataWindow" object:nil];
	}
	return self;
}

- (void) awakeFromNib
{	
	NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	NSString *mTitle = nil;
	if (standardUserDefaults) 
		mTitle = [standardUserDefaults objectForKey:TITLE];
	if (mTitle != nil){
		[self loadUserDefaultValues];	
	}
	else {
		[mToolBar setSelectedItemIdentifier:@"Photos"];
		[self photoButtonSelected:self];
		mAppDock = YES;
		[self relaunchApp:self];
	}

	[mMetaDataRetrieverWindow setAlphaValue:0.75];
	[mPreferencesWindow setAlphaValue:0.75];

		// default preference control values
	mShowSmallSizeText.state = 0;
	[mToolBar setAllowsUserCustomization:NO];
		
	[self setupInfoWindow];               
}

#pragma mark User default method
- (void) loadUserDefaultValues
{
	mWindowFrame = NSRectFromString([[NSUserDefaults standardUserDefaults] objectForKey:WINDOWSIZE]);
	if(![NSStringFromRect(mWindowFrame) isEqualToString:NSStringFromRect(NSZeroRect)]){
		[mMainWindow setFrame:mWindowFrame display:YES];	
	}
	NSString *selectedItemIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:SELECTEDVIEW];
	if([selectedItemIdentifier isEqualToString:@"Photos"]){
		[mToolBar setSelectedItemIdentifier:selectedItemIdentifier];
		[self photoButtonSelected:self];
	}
	else {
		[mToolBar setSelectedItemIdentifier:selectedItemIdentifier];
		[self linkButtonSelected:self];
	}
	
	NSUInteger statusBar = [[NSUserDefaults standardUserDefaults] integerForKey:STATUSBAR];
	if(statusBar){
		[self launchStatusBarApp];
	}
}

- (void) launchStatusBarApp
{
	[mAppVisibility setEnabled:NO];
	[mAppAvailability selectItemAtIndex:1];
	mStatusBarItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[mMainWindow setLevel:3];
	[mPreferencesWindow setLevel:7];
	
	NSMenu *menu = [[[NSMenu alloc] init] autorelease];
	[menu setDelegate:self];
	
	[mStatusBarItem setMenu:menu];
	NSImage *statusImage = [NSImage imageNamed:@"MediaStatus.tiff"];
	[mStatusBarItem setImage:statusImage];	
}

- (void) menuWillOpen:(NSMenu *)menu
{
	NSUInteger mouseButton = [NSEvent pressedMouseButtons];
	
	if(mouseButton == 1){
		[menu removeAllItems];
		if(!mWindowVisible){
			[mMainWindow orderOut:self];	
			[mAboutWindow orderOut:self];	
			mWindowVisible=YES;
		}
		else {
			[mMainWindow makeKeyAndOrderFront:self];
			[mMainWindow setHidesOnDeactivate:NO];
			mWindowVisible=NO;
		}
	}
	if(mouseButton == 2){
		[menu removeAllItems];
		NSMenuItem *preferences = [[[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(preferencesButtonSelected:) keyEquivalent:@""] autorelease];
		[preferences setTarget:self];
		[menu addItem:preferences];
		[menu addItem:[NSMenuItem separatorItem]];
		
		NSMenuItem *feedback = [[[NSMenuItem alloc] initWithTitle:@"Feedback..." action:@selector(sendEmailSelected:) keyEquivalent:@""] autorelease];
		[feedback setTarget:self];
		[menu addItem:feedback];
		[menu addItem:[NSMenuItem separatorItem]];
		
		NSMenuItem *help = [[[NSMenuItem alloc] initWithTitle:@"Help" action:@selector(showHelp:) keyEquivalent:@""] autorelease];
		[help setTarget:nil];
		[menu addItem:help];
				
		NSMenuItem *about = [[[NSMenuItem alloc] initWithTitle:@"About" action:@selector(aboutMediaBrowser:) keyEquivalent:@""] autorelease];
		[about setTarget:self];
		[menu addItem:about];
		
		NSMenuItem *relaunch = [[[NSMenuItem alloc] initWithTitle:@"Relaunch" action:@selector(relaunchApp:) keyEquivalent:@""] autorelease];
		[relaunch setTarget:nil];
		[menu addItem:relaunch];
		
		NSMenuItem *quit = [[[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quitApplication) keyEquivalent:@""] autorelease];
		[quit setTarget:self];
		[menu addItem:quit];		
		[mStatusBarItem setMenu:menu];
	}
}
#pragma mark -

#pragma mark preferences and help methods
- (void)beginMetaDataSheet
{
	[NSApp beginSheet:mMetaDataRetrieverWindow modalForWindow:mMainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];	
}

- (void)endMetaDataSheet
{
	[NSApp endSheet:mMetaDataRetrieverWindow];
	[mMetaDataRetrieverWindow orderOut:nil];
}

- (void)setupInfoWindow 
{
		// set up special button
	NSButton *button = [mMainWindow standardWindowButton:NSWindowCloseButton];
	NSView *container = [button superview];
	float containerWidth = [container frame].size.width;
	NSRect frame = [button frame];
	NSButton *iButton = [[[NSButton alloc] initWithFrame:NSMakeRect(frame.origin.x + containerWidth - 11 - 11,frame.origin.y+2,11,11)] autorelease];
	[iButton setAutoresizingMask:NSViewMinYMargin|NSViewMinXMargin];
	
	[iButton setBordered:NO];
	[iButton setImage:[NSImage imageNamed:@"i.tiff"]];
	[iButton setAction:@selector(info:)];
	[iButton setTarget:self];
	[container addSubview:iButton];
	
		// Now do another button on the flip-side
	button = [mAboutWindow standardWindowButton:NSWindowCloseButton];
	container = [button superview];
	containerWidth = [container frame].size.width;
	frame = [button frame];
	iButton = [[[NSButton alloc] initWithFrame:NSMakeRect(frame.origin.x + containerWidth - 11 - 11,frame.origin.y+2,11,11)] autorelease];
	[iButton setAutoresizingMask:NSViewMinYMargin|NSViewMinXMargin];

	[iButton setBordered:NO];
	[iButton setImage:[NSImage imageNamed:@"i.tiff"]];
	[iButton setAction:@selector(flipBack:)];
	[iButton setTarget:self];
	[container addSubview:iButton];
	
	[NSWindow flippingWindow];
	[mAboutTextView setDrawsBackground:NO];

	NSScrollView *scrollView = [mAboutTextView enclosingScrollView];
	[scrollView setDrawsBackground:NO];
	[[scrollView contentView] setCopiesOnScroll:NO];
	
	NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"Info" ofType:@"html"];
	
	NSData *htmlContents = [NSData dataWithContentsOfFile:path];
	NSAttributedString *attr = [[NSAttributedString alloc] initWithHTML:htmlContents documentAttributes:nil];
	[mAboutTextView setEditable:NO];
	[[mAboutTextView textStorage] setAttributedString:attr];
	[attr release];
}	

- (IBAction) info:(id)sender
{
	[mAboutWindow setFrame:[mMainWindow frame] display:YES];
	[mMainWindow flipToShowWindow:mAboutWindow forward:YES reflectInto:nil];
}

- (IBAction) flipBack:(id)sender
{
	[mMainWindow setFrame:[mAboutWindow frame] display:NO];					// not really needed unless window is resized
	[mAboutWindow flipToShowWindow:mMainWindow forward:NO reflectInto:nil];
}

- (IBAction) aboutMediaBrowser:(id)sender
{
	[mMainWindow flipToShowWindow:mAboutWindow forward:YES reflectInto:nil];
}

- (IBAction) preferencesButtonSelected:(id)sender
{
	[NSApp beginSheet:mPreferencesWindow modalForWindow:mMainWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction) closePreferenceWindow:(id)sender
{
	[NSApp endSheet:mPreferencesWindow];
	[mPreferencesWindow orderOut:nil];
}

- (IBAction) sendEmailSelected:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"mailto:sandeep@sourcebits.com"]];
}

- (IBAction) showSmallSizeTextSelected:(id)sender
{
	if(mShowSmallSizeText.state){
		[mToolBar setSizeMode:NSToolbarSizeModeSmall];	
	}
	else {
		[mToolBar setSizeMode:NSToolbarSizeModeRegular];	
	}
}

- (IBAction) toolBarDisplaySelected:(id)sender
{
	if([mToolBarDisplay indexOfSelectedItem]==0) 
		[mToolBar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
	if([mToolBarDisplay indexOfSelectedItem]==1) 
		[mToolBar setDisplayMode:NSToolbarDisplayModeIconOnly];
	if([mToolBarDisplay indexOfSelectedItem]==2) 
		[mToolBar setDisplayMode:NSToolbarDisplayModeLabelOnly];		
}

- (IBAction) appAvailabilitySelected:(id)sender
{
	if([mAppAvailability indexOfSelectedItem]==0){
		[mAppVisibility setEnabled:YES];
		mAppStatusBar = NO;
		mAppDock = YES;
		NSAlert *statusPanel = [NSAlert alertWithMessageText:@"Change to Application with Dock Item" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"This change will occur the next time you launch Media Browser."];
		[statusPanel beginSheetModalForWindow:mPreferencesWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	}
	
	if([mAppAvailability indexOfSelectedItem]==1){
		[mAppVisibility setEnabled:NO];
		mAppStatusBar = YES;
		mAppDock = NO;
		NSAlert *statusPanel = [NSAlert alertWithMessageText:@"Change to Status Bar Item" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"This change will occur the next time you launch Media Browser."];
		[statusPanel beginSheetModalForWindow:mPreferencesWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
	} 	
}

- (IBAction) appVisibilitySelected:(id)sender
{
	if([mAppVisibility indexOfSelectedItem]==0){
		[mMainWindow setHidesOnDeactivate:YES];	
	} 
	
	if([mAppVisibility indexOfSelectedItem]==1){
		[mMainWindow setLevel:NSScreenSaverWindowLevel];
	} 	
}

- (void) quitApplication
{
	[[NSApplication sharedApplication] terminate:self];
	[mStatusBarItem release];
}
#pragma mark -

#pragma mark Interface control methods
	//Switch to photos-browser window
- (IBAction) photoButtonSelected: (id)sender
{
	[mPhotoSplitView setHidden:NO];
	[mLinkSplitView setHidden:YES];
	[mPhotoSlider setHidden:NO];
	[mZoomOut setHidden:NO];
	[mZoomIn setHidden:NO];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kPhotoButtonSelected" object:nil];
}

	//Switch to links-browser window
- (IBAction) linkButtonSelected: (id)sender
{
	[mLinkSplitView setHidden:NO];
	[mPhotoSplitView setHidden:YES];
	[mPhotoSlider setHidden:YES];
	[mZoomOut setHidden:YES];
	[mZoomIn setHidden:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kLinkButtonSelected" object:nil];
}

- (IBAction)relaunchApp:(id)sender
{
	[NSApp relaunch:self];
}

#pragma mark window delegate methods
- (void)windowWillClose:(NSNotification *)notification
{ 	
	NSFileManager *dirManager = [NSFileManager defaultManager];
	if([dirManager fileExistsAtPath:TEMPPATH]){
		[dirManager removeItemAtPath:TEMPPATH error:nil];	
	}		
	else{
		;
	}
	NSUInteger statusBar = [[NSUserDefaults standardUserDefaults] integerForKey:STATUSBAR];
	if(!statusBar){
		[[NSApplication sharedApplication] terminate:self];	
	}
	[self storeUserDefaultValues];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"kStoreDefaultValuesNotification" object:nil];
}

- (void) storeUserDefaultValues
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	mWindowFrame = [mMainWindow frame];
	
	[userDefaults setObject:NSStringFromRect(mWindowFrame) forKey:WINDOWSIZE];
	[userDefaults setObject:[mToolBar selectedItemIdentifier] forKey:SELECTEDVIEW];
	[userDefaults setObject:@"Media Browser" forKey:TITLE];

	NSString *bundleInfo = [[NSBundle mainBundle] bundlePath];
	bundleInfo = [NSString stringWithFormat:@"%@/Contents/Info.plist",bundleInfo];
	NSMutableDictionary *plistData = [NSDictionary dictionaryWithContentsOfFile:bundleInfo];
	
	if(mAppStatusBar){
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:STATUSBAR];
		[plistData setObject:[NSNumber numberWithBool:YES] forKey:@"LSUIElement"];
		[plistData writeToFile:bundleInfo atomically:YES];
	}
	if(mAppDock){
		[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:STATUSBAR];
		[plistData setObject:[NSNumber numberWithBool:NO] forKey:@"LSUIElement"];	
		[plistData writeToFile:bundleInfo atomically:YES];
	}
	[userDefaults synchronize];
}
#pragma mark -
- (void) dealloc
{
	[super dealloc];
}
@end