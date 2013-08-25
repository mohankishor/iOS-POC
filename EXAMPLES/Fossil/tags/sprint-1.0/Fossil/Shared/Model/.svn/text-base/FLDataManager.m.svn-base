//
//  FLDataManager.m
//  Fossil
//
//  Created by Darshan on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLDataManager.h"
#import "FLSqliteDataBaseManager.h"
#import "FLCatalogGridViewController.h"
#import "FLImageLoader.h"

/* this is the singleton class which manages the data for the application
 */

static FLDataManager *sharedInstance = nil;

@implementation FLDataManager

#pragma mark -
#pragma mark class delegate methods
-(id) init
{
	self = [super init];
	if(self) 
	{
		mSqliteManager = [[FLSqliteDataBaseManager alloc] init];
		mTableImageLoader = [[FLTableImageLoader alloc] init];
		mCache = [[NSMutableDictionary alloc] init];
	}
	return self;
}

-(void) dealloc 
{
	[mCache release];
	[mSqliteManager release];
	[mTableImageLoader release];
	[super dealloc];
}

-(NSInteger) noOfPages 
{
	return [mSqliteManager noOfPages];
}

-(NSString *) pageImagePath:(NSInteger) pageNumber
{
	return [mSqliteManager pageImagePath:pageNumber];
}

#pragma mark -
#pragma mark instance image methods

-(UIImage*) lowResCoverImage //synchronous
{
	int coverPageId = [mSqliteManager pageImageId:1];
	UIImage *cachedImage = [self loadImageWithId:coverPageId];
	
	return cachedImage;
}
	

//lazy load methods
-(void) loadCoverImage:(UIImageView*)imageView //asynchronous
{
	imageView.image = [self lowResCoverImage];
	mCoverImageView = imageView;
	[mCoverImageLoader release];
	mCoverImageLoader= [[FLImageLoader alloc] init];
	
	NSString *highRes = [[NSString alloc] initWithFormat:@"%@?wid=512&fmt=png",[self pageImagePath:1]];
	[mCoverImageLoader loadImageForDelegate:self withUrlString:highRes];
	[highRes release];
}
-(void) receiveImageLoaded:(UIImage *)image byLoader:(id) sender
{
	if(image) 
	{
		mCoverImageView.image = image;
		[mCache setObject:image forKey:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",[mSqliteManager pageImageId:1]] ofType:@"png"]];
	}
	[mCoverImageLoader release];
	mCoverImageLoader = nil;
	mCoverImageView = nil;
}

-(void) loadPagesWithCell:(UITableViewCell*)cell tableView:(UITableView*)tableView indexPath:(NSIndexPath*) indexPath
{
	int row=indexPath.row;
	int max = [self noOfPages];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if(row*6+2+FL_COVER_OFFSET < max) 
	{
		int image1 = [mSqliteManager pageImageId:row*6+1+FL_COVER_OFFSET];
		int image2 = [mSqliteManager pageImageId:row*6+2+FL_COVER_OFFSET] ;

		UIImage *cachedImage = [[self loadSpreadForLeftId:image1 andRightId:image2] retain];
		UIImageView *view=(UIImageView*) [cell viewWithTag:1];
		view.image = cachedImage;
			
		UIImageView *shadow = (UIImageView*) [cell viewWithTag:4];
		shadow.hidden = NO;
		[cachedImage release];
	}
	else 
	{
		UIImageView *view=(UIImageView*) [cell viewWithTag:1];
		view.image = nil;
		
		UIImageView *shadow = (UIImageView*) [cell viewWithTag:4];
		shadow.hidden = YES;
	}
	[pool release];
	
	pool = [[NSAutoreleasePool alloc] init];
	
	if(row*6+4+FL_COVER_OFFSET < max) 
	{
		int image1 = [mSqliteManager pageImageId:row*6+3+FL_COVER_OFFSET];
		int image2 = [mSqliteManager pageImageId:row*6+4+FL_COVER_OFFSET] ;
		
		UIImage *cachedImage = [[self loadSpreadForLeftId:image1 andRightId:image2] retain];
		UIImageView *view=(UIImageView*) [cell viewWithTag:2];
		view.image = cachedImage;
		
		UIImageView *shadow = (UIImageView*) [cell viewWithTag:5];
		shadow.hidden = NO;
		[cachedImage release];
	}
	else 
	{
		UIImageView *view=(UIImageView*) [cell viewWithTag:2];
		view.image = nil;
		
		UIImageView *shadow = (UIImageView*) [cell viewWithTag:5];
		shadow.hidden = YES;
	}
	[pool release];
	
	pool = [[NSAutoreleasePool alloc] init];
	if(row*6+6+FL_COVER_OFFSET < max) 
	{
		int image1 = [mSqliteManager pageImageId:row*6+5+FL_COVER_OFFSET];
		int image2 = [mSqliteManager pageImageId:row*6+6+FL_COVER_OFFSET] ;
		
		UIImage *cachedImage = [[self loadSpreadForLeftId:image1 andRightId:image2] retain];
		UIImageView *view=(UIImageView*) [cell viewWithTag:3];
		view.image = cachedImage;
		
		UIImageView *shadow = (UIImageView*) [cell viewWithTag:6];
		shadow.hidden = NO;
		[cachedImage release];
	}
	else 
	{
		UIImageView *view=(UIImageView*) [cell viewWithTag:3];
		view.image = nil;
		
		UIImageView *shadow = (UIImageView*) [cell viewWithTag:6];
		shadow.hidden = YES;
	}
	[pool release];
}


-(UIImage *) loadSpreadForLeft:(NSString*)image1 andRight:(NSString*)image2
{
	UIImage *cachedImage = (UIImage*)[mCache objectForKey:image1];
	if(cachedImage == nil) 
	{		
		UIImage *im1 = [[FLCatalogGridViewController imageFromUrlString:image1] retain];
		UIImage *im2 = [[FLCatalogGridViewController imageFromUrlString:image2] retain];
		cachedImage = [FLCatalogGridViewController combineImageLeft:im1 andRight:im2];
		[mCache setObject:cachedImage forKey:image1];
		
		[im1 release];
		[im2 release];
	}
	return cachedImage;
}
									
- (UIImage *) loadSpreadForLeftId:(int)image1 andRightId:(int)image2
{
	NSString *imageIdString = [[NSString alloc] initWithFormat:@"%d",image1];
	NSString *image1Path = [[NSBundle mainBundle] pathForResource:imageIdString ofType:@"png"];
	UIImage *cachedImage = nil;
	if(image1Path) 
	{
		cachedImage = [mCache objectForKey:image1Path];
		
		if(cachedImage == nil) 
		{
			UIImage *leftImage = [[UIImage alloc] initWithContentsOfFile:image1Path];
			
			NSString *imageId2String = [[NSString alloc] initWithFormat:@"%d",image2];
			NSString *image2Path = [[NSBundle mainBundle] pathForResource:imageId2String ofType:@"png"];
			UIImage *rightImage = [[UIImage alloc] initWithContentsOfFile:image2Path];
			[imageId2String release];
			
			cachedImage = [FLCatalogGridViewController combineImageLeft:leftImage andRight:rightImage];
			if(cachedImage)
			{
				[mCache setObject:cachedImage forKey:image1Path];
			}
			
			[leftImage release];
			[rightImage release];	
		}
	
	}
	[imageIdString release];

	return cachedImage;
}
									
-(UIImage *) loadImageWithId:(NSInteger) imageId
{
	NSString *imageIdString = [[NSString alloc] initWithFormat:@"%d",imageId];
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageIdString ofType:@"png"];

	UIImage *cachedImage = nil;
	if(imagePath) 
	{
	
	cachedImage = [mCache objectForKey:imagePath];
	if(cachedImage == nil) 
	{
		cachedImage = [[[UIImage alloc] initWithContentsOfFile:imagePath] autorelease];
		[mCache setObject:cachedImage forKey:imagePath];
	}
	}
	[imageIdString release];
	
	return cachedImage;
}
	
-(UIImage *) loadImageWithPageNumber:(int) page
{
	int imageId = [mSqliteManager pageImageId:page];
	return [self loadSpreadForLeftId:imageId andRightId:imageId+1];
}

-(void) clearCache
{
	[mCache removeAllObjects];
}

#pragma mark -
#pragma mark Singleton methods

+ (FLDataManager*)sharedInstance
{
    @synchronized(self)
    {
        if (sharedInstance == nil)
		{
			sharedInstance = [[FLDataManager alloc] init];
		}
    }
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) 
	{
        if (sharedInstance == nil) 
		{
            sharedInstance = [super allocWithZone:zone];
            return sharedInstance;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain 
{
    return self;
}

- (unsigned)retainCount 
{
    return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release 
{
		//do nothing
}

- (id)autorelease 
{
    return self;
}

@end
