//
//  MBLinkLibraryNode.h
//  Media Browser
//
//  Created by Sandeep GS on 02/06/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBLibraryNode.h"

@interface MBLinkLibraryNode : MBLibraryNode 
{
	NSMutableDictionary			*mRootDict;				// Dictionary to hold root node
	NSString					*mRelativeName;
	MBLinkLibraryNode			*mParent;				
	NSMutableArray				*mLinksChildren;
}

@property (nonatomic, retain) NSMutableDictionary *root;

@end
