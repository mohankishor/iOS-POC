//
//  MBPhotoLibraryNode.m
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBPhotoLibraryNode.h"

@interface MBPhotoLibraryNode (PhotoLibraryNode)
	- (NSArray *) photoChildren;
@end

@implementation MBPhotoLibraryNode (PhotoLibraryNode)
	// Creates and returns the array of children Loads children incrementally
- (NSArray *) photoChildren 
{
	if (mPhotoChildren == NULL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
		NSString *fullPath = [self fullPath];
		NSMutableArray *newArray = [NSMutableArray array];
		NSString *newFileName;
        BOOL isDir, valid = [fileManager fileExistsAtPath:fullPath isDirectory:&isDir];
		
        if (valid && isDir) 
		{
			NSArray *array = [fileManager contentsOfDirectoryAtPath:fullPath error:nil];
			for(int i=0; i<[array count]; i++)
			{
				newFileName = [array objectAtIndex:i];				
				if([newFileName characterAtIndex:0]!='.')
				{
					BOOL dirCheck;
					MBPhotoLibraryNode *item = [[MBPhotoLibraryNode alloc] initWithNode:newFileName parent:self];
					[fileManager fileExistsAtPath:[item fullPath] isDirectory:&dirCheck];
					[item release];
					if(dirCheck){
						[newArray addObject:newFileName]; 
					}
				}
			}
			NSInteger cnt, childrenCount = [newArray count];
			mPhotoChildren = [[NSMutableArray alloc] initWithCapacity:childrenCount];
			for (cnt = 0; cnt < childrenCount; cnt++) {
				MBPhotoLibraryNode *item = [[MBPhotoLibraryNode alloc] initWithNode:[newArray objectAtIndex:cnt] parent:self];
				[mPhotoChildren addObject:item];
				[item release];
            }
        }
		else {
			mPhotoChildren = nil;
        }
    }
    return mPhotoChildren;
}
@end

@implementation MBPhotoLibraryNode
- (id)initWithNode:(NSString *)path parent:(MBPhotoLibraryNode *)obj 
{
	if (self = [super init]) 
	{
		mRelativePath = [path copy];
        mParent = obj;
	}
	return self;
}

- (NSInteger) numberOfChildren
{
	id tmp = [self photoChildren];
	NSInteger count = (tmp) ? [tmp count] : 0;
	return 	count;	
}

- (id) childAtIndex: (NSInteger)index
{
	return [[self photoChildren] objectAtIndex:index];	
}

	// returns last path component
- (NSString *) relativeNode 
{
	NSString *folderName = [mRelativePath lastPathComponent];
	if([folderName isEqualToString:@"Pictures"])
		return @"Pictures Folder"; 
	else 
		return [mRelativePath lastPathComponent];
}
	
	// returns full path component
- (NSString *) fullPath 
{
    return mParent ? [[mParent fullPath] stringByAppendingPathComponent:mRelativePath] : mRelativePath;
}

- (void) dealloc 
{
    if (mPhotoChildren != nil){
		[mPhotoChildren release];	
		mPhotoChildren = nil;
	}
	[mRelativePath release];
	mParent = nil;
    [super dealloc];
}
@end