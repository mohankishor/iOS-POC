//
//  MBLinkController.m
//  Media Browser
//
//  Created by Sandeep GS on 27/07/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBLinkController.h"
#import "MBLinkLibraryNode.h"
#import "MBLinkData.h"
#import "MBOutlineViewCell.h"
#import "MBTableViewCell.h"

@interface MBLinkController (links)
	- (void) parseLinksForName			: (NSString *)relativeName;
	- (void) recursivelyParseLinkItem	: (NSDictionary *)itemDict;	
@end

@implementation MBLinkController (links)
- (void)recursivelyParseLinkItem:(NSDictionary *)itemDict
{
	NSArray *collectionArray = [itemDict objectForKey:@"Children"];		
	
	NSEnumerator *e = [collectionArray objectEnumerator];
	NSDictionary *cur;
	
	while (cur = [e nextObject]){
		if ([[cur objectForKey:@"WebBookmarkType"] isEqualToString:@"WebBookmarkTypeList"]){
			[self recursivelyParseLinkItem:cur];
		}
		else{
			mLinkNode = [[MBLinkData alloc]init];
			mLinkNode.mLinkTitle = [[cur objectForKey:@"URIDictionary"] objectForKey:@"title"];
			mLinkNode.mLinkPath = [cur objectForKey:@"URLString"];			
			[mLinkDataSource addObject:mLinkNode];
			[mLinkNode release];
		}
	}
}
	//Traverse through a plist for links
- (void) parseLinksForName:(NSString *)relativeName
{	
	NSDictionary *root = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/Safari/Bookmarks.plist", NSHomeDirectory()]];;	
	
	NSEnumerator *groupEnum = [[root objectForKey:@"Children"] objectEnumerator];
	NSDictionary *cur;
	
	while (cur = [groupEnum nextObject]){
		if([relativeName isEqualToString:@"Safari"]){
			[self recursivelyParseLinkItem:cur];
		}		
		if([[cur objectForKey:@"Title"] isEqualToString:relativeName]){
			[self recursivelyParseLinkItem:cur];	
			break;
		}
		else {
			NSArray *collectionArray = [cur objectForKey:@"Children"];		
			if([collectionArray count]){
				for(int i=0; i<[collectionArray count]; i++){
					NSDictionary *child = [collectionArray objectAtIndex:i];
					if([[child objectForKey:@"Title"] isEqualToString:relativeName]){
						[self recursivelyParseLinkItem:child];	
						break;
					}
				}
			}
		}
	}	
}
@end

@implementation MBLinkController

- (id) init
{
	self = [super init];
	if (self != nil) {
		mLinkDataSource		= [[NSMutableArray alloc]init];					// datasource for table to display links
	}
	return self;
}

- (void) awakeFromNib
{
	[mLinkOutlineView setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
	[mLinkOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];			// sets selection to previous item of deleted item in outlineview		
	
	MBOutlineViewCell *linksOutlineCell = [[[MBOutlineViewCell alloc]init]autorelease];			// links outlineview customization
	[[mLinkOutlineView tableColumnWithIdentifier:@"Links"] setDataCell:linksOutlineCell];
	
	MBTableViewCell *linkCell = [[[MBTableViewCell alloc]init]autorelease];						// links tableview customization
	[[mLinkTableView tableColumnWithIdentifier:@"Links"] setDataCell:linkCell];	
	
	[mLinkTableView setDoubleAction:@selector(openLinkInBrowser:)];											// double click to open links in browser
	[mLinkTableView setTarget:self];
}

#pragma mark outlineview datasource methods
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item 
{
	return (item == nil) ? 1 : [item numberOfChildren];	
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	return (item == nil) ? YES : ([item numberOfChildren] != 0);	
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item 
{
	MBLinkLibraryNode *node = nil;  
	if(item == nil){
		node = [[MBLinkLibraryNode alloc] initWithNode:[NSString stringWithFormat:@"%@/Library/Safari/Bookmarks.plist", NSHomeDirectory()] parent:nil];
	}
	else{
		node = [(MBLinkLibraryNode *)item childAtIndex:index];
	}		
	return node;				// need to release
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item 
{
	id returnObj = nil;
	returnObj = (item == nil) ? @"/" : (id)[item relativeNode];			
	return returnObj;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	return NO;
}

	// customize each cell of outlineview
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	NSImage *folderIcon;
	MBOutlineViewCell *outlineCell = cell;
	NSUInteger row;
	
	row = [mLinkOutlineView rowForItem:item];
	MBLinkLibraryNode *node = [mLinkOutlineView itemAtRow:row];
	NSString *linkFolder = [node relativeNode];
	
	if([linkFolder isEqualToString:@"BookmarksMenu"]){
		folderIcon = [NSImage imageNamed:@"SafariBookmarksMenu.png"];	
	}
	else if([linkFolder isEqualToString:@"BookmarksBar"]){
		folderIcon = [NSImage imageNamed:@"SafariBookmarksBar.png"];	
	}	
	else if([linkFolder isEqualToString:@"Safari"]){ 
		folderIcon = [NSImage imageNamed:@"links.png"];
	}
	else{
			folderIcon = [NSImage imageNamed:@"NSFolder"];			
		}
	outlineCell.mFolderImage = [folderIcon retain];				// need to release
	outlineCell.mFolderName	= [[node relativeNode] retain];		// need to release
}
#pragma mark -

#pragma mark outline delegate methods
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
	[mLinkTableView selectRowIndexes:nil byExtendingSelection:NO];
	[mLinkDataSource removeAllObjects];
	unsigned row = [mLinkOutlineView selectedRow];
	NSString *selectedRowName = [[mLinkOutlineView itemAtRow:row]relativeNode];
	[self parseLinksForName:selectedRowName];
	[mLinkTableView reloadData];
}
#pragma mark -

#pragma mark Tableview dataSource methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [mLinkDataSource count];
}

- (void)tableView:(NSTableView *)tView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
	MBTableViewCell *linkCell = cell;
	if(rowIndex < [mLinkDataSource count]){		
		mLinkNode = [mLinkDataSource objectAtIndex:rowIndex];
		linkCell.mLinkImage = [[NSImage imageNamed:@"link.jpg"]retain];
		linkCell.mLinkName	= [mLinkNode.mLinkTitle retain];
	}
}

- (void)openLinkInBrowser:(id)sender
{
	int clickedRow = [mLinkTableView clickedRow];
	
	mLinkNode = [mLinkDataSource objectAtIndex:clickedRow];
	NSString *linkString = mLinkNode.mLinkPath;
	NSURL *linkURL = [NSURL URLWithString:linkString];
	[[NSWorkspace sharedWorkspace] openURL:linkURL];
}
#pragma mark -

#pragma mark dealloc
- (void) dealloc
{
	[mLinkDataSource release];
	mLinkNode = nil;
	[super dealloc];
}

@end
