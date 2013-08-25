//
//  MBOutlineViewCell.m
//  Media Browser
//
//  Created by Sandeep GS on 20/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBOutlineViewCell.h"


@implementation MBOutlineViewCell

@synthesize mFolderImage;
@synthesize mFolderName;


- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSMutableParagraphStyle *aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
		[aParagraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		[aParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
		[aParagraphStyle setAlignment:NSLeftTextAlignment];
		
		mFolderNameAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
							   [NSColor blackColor],NSForegroundColorAttributeName,
							   [NSFont labelFontOfSize:13],	NSFontAttributeName,
							   aParagraphStyle, NSParagraphStyleAttributeName,
							   nil];		
		[aParagraphStyle release];
	}
	return self;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	NSSize folderNameSize = [mFolderName sizeWithAttributes:mFolderNameAttributes];
	
	float aHorizontalPadding = 5.0;
	
	NSRect folderIconBox = NSMakeRect(cellFrame.origin.x+1,
									  cellFrame.origin.y+1,
									  cellFrame.size.height-4,
									  cellFrame.size.height-4);
	
	NSRect folderNameBox = NSMakeRect(cellFrame.origin.x + folderIconBox.size.width + aHorizontalPadding,
									  cellFrame.origin.y+1,
									  cellFrame.size.width - 50,
									  folderNameSize.height);
	
	if([self isHighlighted]){
		[mFolderNameAttributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
		[mFolderNameAttributes setValue:[NSFont controlContentFontOfSize:13] forKey:NSFontAttributeName];
	}
	else{
		[mFolderNameAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
		[mFolderNameAttributes setValue:[NSFont labelFontOfSize:13] forKey:NSFontAttributeName];
	}

	[mFolderImage setFlipped:YES];
	
		//Drawing folder image and folder name
	[mFolderImage drawInRect:folderIconBox fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];	
	[mFolderName drawInRect:folderNameBox withAttributes:mFolderNameAttributes];
}

-(void) dealloc
{
	self.mFolderName = nil;
	self.mFolderImage = nil;
//	if (mFolderNameAttributes) {
//		[mFolderNameAttributes release];
//		mFolderNameAttributes = nil;
//	}
	[super dealloc];
}
@end
