//
//  MBLinksTableCellStyle.m
//  Media Browser
//
//  Created by Sandeep GS on 31/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBTableViewCell.h"

@implementation MBTableViewCell

@synthesize mLinkImage;
@synthesize mLinkName;


- (id) init
{
	self = [super init];
	if (self != nil) {
		NSMutableParagraphStyle *aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
		[aParagraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
		[aParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
		[aParagraphStyle setAlignment:NSLeftTextAlignment];
		
		mLinkNameAttributes = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
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
	NSSize linkNameSize = [mLinkName sizeWithAttributes:mLinkNameAttributes];
	
	float aHorizontalPadding = 4.0;
	
	NSRect linkIconBox = NSMakeRect(cellFrame.origin.x+1,
									  cellFrame.origin.y+2,
									  cellFrame.size.height-3,
									  cellFrame.size.height-3);
	
	NSRect linkNameBox = NSMakeRect(cellFrame.origin.x + linkIconBox.size.width + aHorizontalPadding,
									  cellFrame.origin.y,
									  cellFrame.size.width - 50,
									  linkNameSize.height);
	
	if([self isHighlighted]){
		[mLinkNameAttributes setValue:[NSColor whiteColor] forKey:NSForegroundColorAttributeName];
		[mLinkNameAttributes setValue:[NSFont controlContentFontOfSize:13] forKey:NSFontAttributeName];
	}
	else{
		[mLinkNameAttributes setValue:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
	}
	
	[mLinkImage setFlipped:YES];
	
		//Drawing folder image and folder name
	[mLinkImage drawInRect:linkIconBox fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];	
	[mLinkName drawInRect:linkNameBox withAttributes:mLinkNameAttributes];
}

-(void) dealloc
{
	self.mLinkName = nil;
	self.mLinkImage = nil;
//	if (mLinkNameAttributes) {
//		[mLinkNameAttributes release];
//		mLinkNameAttributes = nil;
//	}
	[super dealloc];
}
@end