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
	if(urlString == nil) 
	{
		return;
	}
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
	//[mConnection release];
	//[image release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"error loading image : %@  , %@",[error localizedDescription],[error localizedFailureReason]);
	
	[mData release];
	[mConnection release];
	[mDelegate receiveImageLoaded:nil byLoader:self];
}
- (void) cancel
{
	[mConnection cancel];
}
@end

@implementation FLTableImageNode

@synthesize indexPath = mIndexPath;
@synthesize tableView = mTableView;
@synthesize tag = mTag;
@synthesize imageLoader = mImageLoader;
@synthesize imagePath = mImagePath;

- (void) dealloc
{
	self.indexPath=nil;
	self.imageLoader = nil;
	self.imagePath = nil;
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

- (void) loadImage:(NSString*)path withTag:(int)tag forTable:(UITableView*) tableView andIndexPath:(NSIndexPath*) indexPath
{
	FLTableImageNode *node=[[FLTableImageNode alloc] init];
	node.indexPath = indexPath;
	node.tableView = tableView;
	node.tag = tag;
	
	FLImageLoader *imageLoader = [[FLImageLoader alloc] init];
	[imageLoader loadImageForDelegate:self withUrlString:path];
	
	node.imagePath = path;
	
	node.imageLoader = imageLoader;
	[imageLoader release];
	[mActiveDownloads addObject:node];
	[node release];
	
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
				UIImageView *imageView = (UIImageView*)[cell viewWithTag:node.tag];
				if(image)
				{
					imageView.image = image;
				} else
				{
					imageView.image = [UIImage imageNamed:@"missing_mage.png"];
				}
			}

			//add image to cache
			if(image)
			{
				[[FLDataManager sharedInstance] addCacheProductImage:image withKey:value.imagePath];
			}
			
			[mActiveDownloads removeObject:sender];
			break;
		}
	}
}

@end
