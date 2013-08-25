//
//  MBPhotoLibraryNode.h
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MBLibraryNode.h"

@interface MBPhotoLibraryNode : MBLibraryNode
{
	NSString					*mRelativePath;
	MBPhotoLibraryNode			*mParent;
	NSMutableArray				*mPhotoChildren;	
}

@end
