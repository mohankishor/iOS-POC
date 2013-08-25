//
//  MBLinkLibraryNode.m
//  Media Browser
//
//  Created by Sandeep GS on 02/06/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBLinkLibraryNode.h"

@interface MBLinkLibraryNode (LinkLibraryNode)
	- (NSArray *) linksChildren;
	- (void) recursivelyParseLinkItem:(NSDictionary *)itemDict;
@end

@implementation MBLinkLibraryNode (LinkLibraryNode)
- (void)recursivelyParseLinkItem:(NSDictionary *)itemDict
{
	NSArray *collectionArray = [itemDict objectForKey:@"Children"];		
	if([collectionArray count]){
		MBLinkLibraryNode *item = [[MBLinkLibraryNode alloc] initWithNode:[itemDict objectForKey:@"Title"] parent:self];
		[mLinksChildren addObject:item];
		item.root = (NSMutableDictionary*)itemDict;
		[item release];
	}		
}

- (NSArray *) linksChildren
{	
	mLinksChildren = [[NSMutableArray alloc]init];	
	if(mParent == nil){
		mRootDict = [NSMutableDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/Library/Safari/Bookmarks.plist", NSHomeDirectory()]];
	}
	else {
			//		NSLog(@"Relative Name = %@", [mRootDict objectForKey:@"Title"]);
	}
	
	NSEnumerator *groupEnum = [[mRootDict objectForKey:@"Children"] objectEnumerator];
	NSDictionary *cur;
	
	while (cur = [groupEnum nextObject]){
		[self recursivelyParseLinkItem:cur];
	}	
	return mLinksChildren;
}
@end

@implementation MBLinkLibraryNode

@synthesize root = mRootDict;

- (id) init
{
	self = [super init];
	if (self != nil) {
		mRootDict = [[NSMutableDictionary alloc]init];
	}
	return self;
}

- (id)initWithNode:(NSString *)name parent:(MBLinkLibraryNode *)obj
{
	if (self = [super init]) 
	{
		mRelativeName = [name copy];
        mParent = obj;
	}
	return self;
}

- (NSInteger) numberOfChildren
{
	id tmp = [self linksChildren];
	NSInteger count = (tmp) ? [tmp count] : 0;
	return 	count;	
}

- (id) childAtIndex: (NSInteger)index
{
	return [[self linksChildren] objectAtIndex:index];	
}

- (NSString *) relativeNode
{
	NSString *linkFolder = [mRelativeName lastPathComponent];
	if([linkFolder isEqualToString:@"Bookmarks.plist"]){
		return @"Safari";	
	}
	return mRelativeName;
}		

- (void)dealloc
{
	if (mLinksChildren != nil){
		[mLinksChildren release];	
		mLinksChildren = nil;
	}
	self.root = nil;
	[mRootDict release];
	[mRelativeName release];
	[super dealloc];
}

@end