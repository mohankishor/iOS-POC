//
//  MBOutlineView.m
//  Media Browser
//
//  Created by Sandeep GS on 28/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBOutlineView.h"
#import "MBAppController.h"

@interface MBOutlineView (outlineview)
	- (void) addFolder;
	- (void) removeFolder;
	- (void) reloadSelectedItem;
@end

@implementation MBOutlineView (outlineview)
- (void) addFolder
{
	if(mOutlineDelegate && [mOutlineDelegate respondsToSelector:@selector(addCustomFolders)]){
		[mOutlineDelegate addCustomFolders];		//calls delegate method to adding custom folders
	}
}

- (void) removeFolder
{
	if(mOutlineDelegate && [mOutlineDelegate respondsToSelector:@selector(removeCustomFolders)]){
		[mOutlineDelegate removeCustomFolders];	//calls delegate method to remove custom folders	
	}
}

- (void) reloadSelectedItem
{
	if(mOutlineDelegate && [mOutlineDelegate respondsToSelector:@selector(reloadItem)]){
		[mOutlineDelegate reloadItem];	
	}
}
@end

@implementation MBOutlineView
@synthesize mOutlineDelegate;

- (id) init
{
	self = [super init];
	if (self != nil) {
//		NSLog(@"Class Initialized");
	}
	return self;
}

- (void)drawRect:(NSRect)aRect	
{
	[super drawRect:aRect];
	int mHeight = [self bounds].size.height;
	int dataHeight = [self rowHeight] * [self numberOfRows];	
	const int MARGIN_BELOW = 25;
	float xPos = [self visibleRect].size.width/2;
	
	if((dataHeight + MARGIN_BELOW <= mHeight)){
	
	NSTextFieldCell *cell = [[NSTextFieldCell alloc]init];
	[cell setAlignment:NSCenterTextAlignment];

	float fontSize = [NSFont systemFontSizeForControlSize:NSSmallControlSize];
	NSFont *font = [NSFont boldSystemFontOfSize:fontSize];
	[cell setFont:font];
	[cell setTextColor:[NSColor lightGrayColor]];
	
	[cell setStringValue:@"Drag additional source folders here"];
	
	NSRect textRect = NSMakeRect(xPos-105, mHeight-20, 210.0, 15.0);
	[cell drawWithFrame:textRect inView:self];
	[cell release];
	}
}

#pragma mark Menu for events
	//Handling menu events in outlineview
- (NSMenu *)menuForEvent:(NSEvent *)theEvent
{
		NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:NULL];
		
		int row = [self rowAtPoint:point];
//		NSLog(@"hello row event:%d",row);
		
		NSMenu *menu = [[[NSMenu alloc] init] autorelease];
		NSMenuItem *addCustomFoldersMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Add Custom Folders..." 
																		   action:@selector(addFolder) keyEquivalent:@""] autorelease];
		[addCustomFoldersMenuItem setTarget:self];
		[menu addItem:addCustomFoldersMenuItem];
		
		NSMenuItem *removeCustomFoldersMenuItem = [[[NSMenuItem alloc] initWithTitle:@"Remove Custom Folder"
																		   action:@selector(removeFolder) keyEquivalent:@""] autorelease];
		[removeCustomFoldersMenuItem setTarget:self];
		[menu addItem:removeCustomFoldersMenuItem];
	
		NSMenuItem *refreshSelectedItem = [[[NSMenuItem alloc] initWithTitle:@"Reload Item"
																		  action:@selector(reloadSelectedItem) keyEquivalent:@""] autorelease];
		[refreshSelectedItem setTarget:self];
		[menu addItem:refreshSelectedItem];
	
		return menu;		
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    if ([menuItem action] == @selector(addFolder))
        return YES;

	if ([menuItem action] == @selector(reloadSelectedItem))
        return YES;

	if ([menuItem action] == @selector(removeFolder)){
		BOOL editFolder = [mOutlineDelegate isFolderEditable];
		if(editFolder) return YES;
		else return NO;
	}
	return NO;
}
#pragma mark -

#pragma mark Keydown events
- (void) keyDown:(NSEvent *)theEvent
{
	NSString *chars = [theEvent characters];
	unichar c;
	if ([chars length] == 1)
	{
		c = [chars characterAtIndex:0];
		switch (c)
		{
			case ' ':
					if(mOutlineDelegate && [mOutlineDelegate respondsToSelector:@selector(showItemInfoInFinder)]){
						[mOutlineDelegate showItemInfoInFinder];		
					}
					return;	
			case 127:
			case NSDeleteFunctionKey:
			{ 
				if(mOutlineDelegate && [mOutlineDelegate respondsToSelector:@selector(removeCustomFolders)]){
					[mOutlineDelegate removeCustomFolders];
				}
				return;
			}
			case NSHomeFunctionKey:
			{
				[self selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
				[self scrollRowToVisible:0];
				return;
			}
			case NSEndFunctionKey:
			{
				[self selectRowIndexes:[NSIndexSet indexSetWithIndex:[self numberOfRows]-1] byExtendingSelection:NO];
				[self scrollRowToVisible:[self numberOfRows]-1];
				
				return;
			}				
		}
	}
	[super keyDown:theEvent];
	return;
}

- (BOOL) acceptsFirstResponder
{
	return YES;
}

- (BOOL) becomeFirstResponder
{
	return YES;
}
#pragma mark -

- (void) dealloc
{
	mOutlineDelegate = nil;
	[super dealloc];
}
@end
