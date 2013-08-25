//
//  MBLibraryNode.h
//  Media Browser
//
//  Created by Sandeep GS on 29/07/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MBLibraryNode : NSObject
{
	NSMutableArray	*mChildren;
	NSString		*mRelativeNode;
	NSString		*mFullPath;
}

- (id) initWithNode: (NSString *)path parent:(id)obj;
- (id) childAtIndex: (NSInteger)index;
- (NSInteger) numberOfChildren;
- (NSString *) relativeNode;
- (NSString *) fullPath;
@end