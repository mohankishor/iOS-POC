//
//  MBLibraryNode.m
//  Media Browser
//
//  Created by Sandeep GS on 29/07/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBLibraryNode.h"

@implementation MBLibraryNode

- (id) init
{
	self = [super init];
	if (self != nil) {
		mChildren = [[NSMutableArray alloc]init];
	}
	return self;
}

- (id) initWithNode:(NSString *)path parent: (id)obj
{
	return obj;
}

- (id) childAtIndex: (NSInteger)index
{
	return [mChildren objectAtIndex:index];
}

- (NSInteger) numberOfChildren
{
	return [mChildren count];
}

- (NSString *) relativeNode
{
	return mRelativeNode;
}

- (NSString *) fullPath
{
	return mFullPath;
}

- (void)dealloc
{
	[mChildren release];
	mChildren = nil;
	mRelativeNode = nil;
	mFullPath = nil;
	[super dealloc];
}
@end