//
//  MBLinkController.h
//  Media Browser
//
//  Created by Sandeep GS on 27/07/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MBLinkData;
@interface MBLinkController : NSObject 
{	
	MBLinkData					*mLinkNode;						// creating node object for link details
	
	IBOutlet NSOutlineView		*mLinkOutlineView;				// outline view for photos
	IBOutlet NSTableView		*mLinkTableView;				// table view to display links	
	NSMutableArray				*mLinkDataSource;				// used to store data for links in table
}

@end
