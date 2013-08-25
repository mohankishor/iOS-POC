//
//  FLImageLoader.m
//  Fossil
//
//  Created by Darshan on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLImageLoader.h"
#import "FLDataManager.h"

@implementation FLImageLoader

- (void) loadImageForDelegate:(id<FLImageLoaderDelegate>) delegate withUrlString:(NSString*) urlString
{
	mDelegate = delegate;
	NSURL *url = [[NSURL alloc] initWithString:urlString];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	
	mConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[mConnection start];
	
	[request release];
	[url release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[mData release];
	mData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[mData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	UIImage *image = [[UIImage alloc] initWithData:mData];
	[mData release];
	mData = nil;
	
	[mConnection release];
	
	[mDelegate receiveImageLoaded:image byLoader:self];
	[image autorelease];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"error loading image");
	
	[mData release];
	[mConnection release];
	[mDelegate receiveImageLoaded:nil byLoader:self];
}

@end

@implementation FLTableImageNode

@synthesize indexPath = mIndexPath;
@synthesize tableView = mTableView;
@synthesize pageNumber = mPageNumber;
@synthesize imageLoader = mImageLoader;

- (void) dealloc
{
	self.imageLoader = nil;
	[super dealloc];
}
@end


@implementation FLTableImageLoader 

- (id) init
{
	self = [super init];
	if(self) 
	{
		mActiveDownloads = [[NSMutableSet alloc] init];
	}
	return self;
}

- (void) dealloc
{
	[mActiveDownloads release];
	[super dealloc];
}

- (void) loadImagesForTable:(UITableView*) tableView andIndexPath:(NSIndexPath*) indexPath
{
	int row = indexPath.row;//TODO:how to combine images asynchronously
	int max = [[FLDataManager sharedInstance] noOfPages];

	for (int i=1;i<=3;i++)
	{
		if ((row*3+i+FL_COVER_OFFSET)<max)
		{
			FLTableImageNode *node=[[FLTableImageNode alloc] init];
			node.indexPath = indexPath;
			node.tableView = tableView;
			node.pageNumber = i;
			
			FLImageLoader *imageLoader = [[FLImageLoader alloc] init];
			NSString *urlString = [[[FLDataManager sharedInstance] pageImagePath:row*3+i+FL_COVER_OFFSET] retain];
			[imageLoader loadImageForDelegate:self withUrlString:urlString];
			[urlString release];
			
			node.imageLoader = imageLoader;
			[imageLoader release];
			[mActiveDownloads addObject:node];
			[node release];
		}
	}
}

- (void) receiveImageLoaded:(UIImage*) image byLoader:(id) sender
{
	NSEnumerator *enumerator = [mActiveDownloads objectEnumerator];
	FLTableImageNode *value;

	while (value = [enumerator nextObject])
	{
		if ([sender isEqual:value.imageLoader])
		{
			FLTableImageNode *node = (FLTableImageNode*) value;

			UITableViewCell *cell = [node.tableView cellForRowAtIndexPath:node.indexPath];
			
			if (cell != nil)
			{
				UIImageView *imageView = (UIImageView*)[cell viewWithTag:node.pageNumber];
				imageView.image = image;
			}
			
			[mActiveDownloads removeObject:sender];
		}
	}
}

@end
