//
//  FLSpreadLoader.m
//  Fossil
//
//  Created by Darshan on 28/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLSpreadLoader.h"
#import "FLDataManager.h"
#import "FLCatalogGridViewController.h"

@implementation FLSpreadLoader

@synthesize page = mPage;

-(id) initWithSpread:(int) spreadPage andView:(UIImageView*) imageView
{
	self = [super init];
	if(self)
	{
		mPage = spreadPage;
		mView = [imageView retain];
				
	}
	return self;
}
-(void) main
{
	if([self isCancelled])
	{
		[mView release];
		return;
	}
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSInteger maxNoOfPages=[[FLDataManager sharedInstance] noOfPages];
	
	if(mPage==0)
	{
		NSString *leftPath = [[NSBundle mainBundle] pathForResource:[[FLDataManager sharedInstance] highResImagePathForPage:mPage+1] ofType:@"jpg"];
		UIImage *left = [[UIImage alloc] initWithContentsOfFile:leftPath];
		
		NSString *rightPath = [[NSBundle mainBundle] pathForResource:[[FLDataManager sharedInstance] highResImagePathForPage:mPage+maxNoOfPages] ofType:@"jpg"];
		 
		UIImage *right = [[UIImage alloc] initWithContentsOfFile:rightPath];
		
		UIImage *spread = [FLCatalogGridViewController combineImageLeft:left andRight:right];
		
		[left release];
		[right release];
		
		 if(![self isCancelled])
		 {
			[mView performSelectorOnMainThread:@selector(setImage:) withObject:spread waitUntilDone:YES];
		 }
		
		[mView release];
	}
	
	else if(mPage !=0)
	{
		NSString *leftPath = [[NSBundle mainBundle] pathForResource:[[FLDataManager sharedInstance] highResImagePathForPage:mPage] ofType:@"jpg"];

		UIImage *left = [[UIImage alloc] initWithContentsOfFile:leftPath];
	
		NSString *rightPath = [[NSBundle mainBundle] pathForResource:[[FLDataManager sharedInstance] highResImagePathForPage:mPage+1] ofType:@"jpg"];
		UIImage *right = [[UIImage alloc] initWithContentsOfFile:rightPath];
	
		UIImage *spread = [FLCatalogGridViewController combineImageLeft:left andRight:right];
	
		[left release];
		[right release];
	
		 if(![self isCancelled])
		 {
			 [mView performSelectorOnMainThread:@selector(setImage:) withObject:spread waitUntilDone:YES];
		 }
		[mView release];
	}
	[pool release];
	
}

@end

