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
#import "FLProduct.h"
#import "FLWatchListViewController.h"

/* this is the singleton class which manages the data for the application
 */

static FLDataManager *sharedInstance = nil;

@interface FLDataManager ()

-(UIImage*) loadCoverImage;
-(void) receiveImageLoaded:(UIImage *)image byLoader:(id) self;
-(UIImage *) loadSpreadForLeft:(NSString*)image1 andRight:(NSString*)image2;
-(UIImage *) loadSpreadForLeftId:(int)image1 andRightId:(int)image2;
-(UIImage *) loadSpreadWithId:(NSInteger) imageid;
-(UIImage *) loadSpreadWithPageNumber:(int) page;
-(NSString *) pageImagePath:(NSInteger) pageNumber;
-(NSString *) highResImagePathForPage:(NSInteger) pageNumber;
-(NSString *)watchImagePath:(NSInteger) index; 

-(UIImage*) cacheImageWithKey:(NSString*)key;
-(void) addCacheImage:(UIImage*)image withKey:(NSString*)key;


@end


@implementation FLDataManager

-(id) init
{
	self = [super init];
	if(self) 
	{
		mSqliteManager = [[FLSqliteDataBaseManager alloc] init];
		mTableImageLoader = [[FLTableImageLoader alloc] init];
		mCache = [[NSMutableDictionary alloc] init];
		mProductImageLoads = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void) dealloc 
{
	[mWatchListLoader1 release];
	[mWatchListLoader2 release];
	[mWatchListLoader3 release];
	[mCache release];
	[mSqliteManager release];
	[mTableImageLoader release];
	[mProductImageLoads release];
	[super dealloc];
}

#pragma mark - 
#pragma mark Cover Page Methods

-(void) loadCoverImage:(UIImageView*)imageView //asynchronous
{
	imageView.image = [self loadCoverImage];
}

-(void) clearCache
{
	[mCache removeAllObjects];
}

#pragma mark - 
#pragma mark Grid Methods

-(NSInteger) noOfPages 
{
	return [mSqliteManager noOfPages];
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
-(void) cancelAllPageLoads
{
		//currently everything loaded from bundle synchronously for spreads
}

-(void) loadHighResolutionSpread:(NSInteger) page forImageView:(UIImageView*) image
{
	NSString *leftPath = [[NSBundle mainBundle] pathForResource:[[FLDataManager sharedInstance] highResImagePathForPage:page] ofType:@"png"];
	UIImage *left = [[UIImage alloc] initWithContentsOfFile:leftPath];
	
	NSString *rightPath = [[NSBundle mainBundle] pathForResource:[[FLDataManager sharedInstance] highResImagePathForPage:page+1] ofType:@"png"];
	UIImage *right = [[UIImage alloc] initWithContentsOfFile:rightPath];
	
	UIImage *spread = [FLCatalogGridViewController combineImageLeft:left andRight:right];
	image.image = spread;
	
	[left release];
	[right release];
}

-(void) cancelHighResolutionLoad
{
		//loaded from bundle
}

#pragma mark - 
#pragma mark Product Methods

-(NSInteger) noOfProductsInPage:(NSInteger)pageNumber
{
	return [mSqliteManager noOfProductsInPage:pageNumber];
}
-(FLProduct *) productInPage:(NSInteger) pageNumber withIndex:(NSInteger) index
{
	return [mSqliteManager productInPage:pageNumber withIndex:index];
}
-(void) loadProduct:(FLProduct *)product withCell:(UITableViewCell*) cell tableView:(UITableView*)tableView indexPath:(NSIndexPath*) indexPath
{
	UILabel *titleLabel = (UILabel*)[cell viewWithTag:2];
	UILabel *priceLabel = (UILabel*)[cell viewWithTag:3];
	
	titleLabel.text = product.productTitle;
	priceLabel.text = [NSString stringWithFormat:@"$%f",[product.productPrice floatValue]];
	
	UIImage *productImage = [mCache objectForKey:product.productImagePath];
	
	UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
	if(productImage == nil)
	{
		imageView.image = nil;//TODO:add loading image
		[mTableImageLoader loadImage:product.productImagePath withTag:1 forTable:tableView andIndexPath:indexPath];
	} else {
		imageView.image = productImage;
	}
}


-(void) cancelAllProductLoads
{
		//TODO: implement 
}

#pragma mark -
#pragma mark Watch Methods

-(NSInteger) noOfWatches
{
	return [mSqliteManager noOfWatches];
	
}
-(void) loadWatchImage:(UIImageView*)image withIndex:(int) index
{
	NSLog(@"tag number:%d",image.tag);
		//image.contentMode = UIViewContentModeScaleAspectFit;
	
	switch (image.tag)
	{
		case 1:
				//if (mWatchListLoader1==nil) {
			mWatchListLoader1 = [[FLImageLoader alloc] init];
				//}else {
				//[mWatchListLoader1 cancel];
				//}
			
			image.image=nil;
			mWatchListImageView1 = image;
				//mWatchListImageView1.contentMode =UIViewContentModeScaleAspectFit;
			NSLog(@"image path :%@",[[FLDataManager sharedInstance] watchImagePath:index]);
			[mWatchListLoader1 loadImageForDelegate:self withUrlString:[[FLDataManager sharedInstance] watchImagePath:index]];
			
			break;
		case 2:
				//if (mWatchListLoader2==nil) {
			mWatchListLoader2 = [[FLImageLoader alloc] init];
				//}else {
				//	//[mWatchListLoader2 cancel];
				//}
			
			image.image=nil;
			mWatchListImageView2 = image;
				//mWatchListImageView2.contentMode =UIViewContentModeScaleAspectFit;
			[mWatchListLoader2 loadImageForDelegate:self withUrlString:[[FLDataManager sharedInstance] watchImagePath:index]];
			
			break;
			
		case 3:
				//if (mWatchListLoader3==nil) {
			mWatchListLoader3 = [[FLImageLoader alloc] init];
				//}else {
				//[mWatchListLoader3 cancel];
				//}
			
			image.image=nil;
			mWatchListImageView3 = image;
				//mWatchListImageView3.contentMode =UIViewContentModeScaleAspectFit;
			
			[mWatchListLoader3 loadImageForDelegate:self withUrlString:[[FLDataManager sharedInstance] watchImagePath:index]];
			
			break;
			
		default:
			break;
	}
}
-(void) cancelWatchLoad:(UIImageView*)image withIndex:(int) index
{
	[mWatchListLoader1 cancel]; 
	[mWatchListLoader2 cancel];
	[mWatchListLoader3 cancel];
	
}

-(FLProduct *)watchAtIndex:(NSInteger) index
{
	return [mSqliteManager watchAtIndex:index];
}


#pragma mark -
#pragma mark instance image methods

-(UIImage*) loadCoverImage //synchronous
{
	int coverPageId = [mSqliteManager pageImageId:1];
	UIImage *cachedImage = [self loadSpreadWithId:coverPageId];
	
	return cachedImage;
}
-(void) receiveImageLoaded:(UIImage *)image byLoader:(id) sender
{
	
	if(image) 
	{
		if([sender isEqual:mWatchListLoader1]) 
		{
			mWatchListImageView1.image = image;
			mWatchListImageView1 =nil;
		}
		else if([sender isEqual:mWatchListLoader2])
		{
			mWatchListImageView2.image = image;
			mWatchListImageView2 =nil;
		}
		else if([sender isEqual:mWatchListLoader3])
		{
			mWatchListImageView3.image = image;
			mWatchListImageView3 =nil;
		}
		else
		{
			mCoverImageView.image = image;
			[mCache setObject:image forKey:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%d",[mSqliteManager pageImageId:1]] ofType:@"png"]];
		}
	}
	
	if([sender isEqual:mWatchListLoader1]) 
	{
		[mWatchListLoader1 release];
	}
	else if([sender isEqual:mWatchListLoader2])
	{
		[mWatchListLoader2 release];
	}
	else if([sender isEqual:mWatchListLoader3])
	{
		[mWatchListLoader3 release];
	}
	else {
		[mCoverImageLoader release];
		mCoverImageLoader = nil;
		mCoverImageView = nil;
		
	}
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
									
-(UIImage *) loadSpreadWithId:(NSInteger) imageId
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
	
-(UIImage *) loadSpreadWithPageNumber:(int) page
{
	int imageId = [mSqliteManager pageImageId:page];
	return [self loadSpreadForLeftId:imageId andRightId:imageId+1];
}

-(NSString *) pageImagePath:(NSInteger) pageNumber
{
	return [mSqliteManager pageImagePath:pageNumber];
}
-(NSString *) highResImagePathForPage:(NSInteger) pageNumber
{
	int imageId = [mSqliteManager pageImageId:pageNumber];
	NSString *url = [NSString stringWithFormat:@"%d_high",imageId];
	NSLog(@"loading high res= %@",url);
	return url;
}

-(NSString *)watchImagePath:(NSInteger) index
{
	return [mSqliteManager watchImagePath:index];
}

-(UIImage*) cacheImageWithKey:(NSString*)key
{
	UIImage *image = [mCache objectForKey:key];
	return image;
}
-(void) addCacheImage:(UIImage*)image withKey:(NSString*)key
{
	if(image)
	{
		[mCache setObject:image forKey:key];
	}
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
