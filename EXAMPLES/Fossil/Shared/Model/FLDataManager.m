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
#import "FLSpreadLoader.h"
//#import "FLWatchCatalogViewController.h"
/* this is the singleton class which manages the data for the application
 */
#define ERROR_IMAGE @"missing_mage.png"


static FLDataManager *sharedInstance = nil;

@interface FLDataManager ()

-(UIImage*) loadCoverImage;
-(void) receiveImageLoaded:(UIImage *)image byLoader:(id) self;
-(UIImage *) loadSpreadForLeft:(NSString*)image1 andRight:(NSString*)image2;
-(UIImage *) loadSpreadForLeftId:(int)image1 andRightId:(int)image2;
-(UIImage *) loadSpreadWithId:(NSInteger) imageid;
-(UIImage *) loadSpreadWithPageNumber:(int) page;
-(NSString *) pageImagePath:(NSInteger) pageNumber;

-(NSString *)watchImagePath:(NSInteger) index; 
-(void) addCacheImage:(UIImage*)image withKey:(NSString*)key;
@end


@implementation FLDataManager

-(id) init
{
	self = [super init];
	if(self) 
	{
		mSqliteManager = [[FLSqliteDataBaseManager alloc] initWithDb:@"catalog"];
		mWatchManager = [[FLWatchManager alloc] initWithDb:@"catalog" andWatchDb:@"watchcatalog"];
		mTableImageLoader = [[FLTableImageLoader alloc] init];
		mCache = [[NSMutableDictionary alloc] init];
		mProductImageLoads = [[NSMutableArray alloc] init];
		mHighResolutionLoads = [[NSOperationQueue alloc] init];
		[mHighResolutionLoads setMaxConcurrentOperationCount:1];
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
	[mHighResolutionLoads release];
	[mMenuImage release];
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
//----------------------------------------------------------------------------------------------------------------------------
/*-(void) loadImagesWithCell:(UITableViewCell*)cell tableView:(UITableView*)tableView indexPath:(NSIndexPath*) indexPath
{
	int row = indexPath.row;
	int max = [ self noOfWatches];
	NSLog(@"Row and  max----$%d",row);
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
	if(row*6+1< max) 
	{
		if(row==0) 
		{
			NSString* imageId = [mSqliteManager watchImageId:row*6+1];
			//int image2 = [mSqliteManager watchImageId:row*6+max] ;
			NSLog(@"no watches------------->%@",imageId);
			UIImage *cachedImage = [[self loadImageWithId:imageId] retain];
			//UIImage *cachedImage = [[self loadSpreadForLeftId:image1 andRightId:image2] retain];
			//UIImageView *view=(UIImageView*) [cell viewWithTag:1];
			UIImageView *view=[[UIImageView alloc]init];
			view.image = cachedImage;
			//
//			UIImageView *shadow = (UIImageView*) [cell viewWithTag:4];
//			shadow.hidden = NO;
			[cachedImage release];
			
		}
		else
		{
			NSString* image1 = [mSqliteManager watchImageId:row*6+1];
			//int image2 = [mSqliteManager watchImageId:row*6] ;
			NSLog(@"else no watches------------->%d",image1);
			UIImage *cachedImage = [[self loadImageWithId:image1 ]retain];
			//UIImageView *view=(UIImageView*) [cell viewWithTag:1];
//			view.image = cachedImage;
//			
//			UIImageView *shadow = (UIImageView*) [cell viewWithTag:4];
//			shadow.hidden = NO;
//			[cachedImage release];
			
			UIImageView *view=[[UIImageView alloc]init];
			view.image=cachedImage;
		}
		
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
	
	if(row*6+3 < max) 
	{
		int image1 = [mSqliteManager pageImageId:row*6+2];
		int image2 = [mSqliteManager pageImageId:row*6+3] ;
		
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
	if(row*6+5< max) 
	{
		int image1 = [mSqliteManager pageImageId:row*6+4];
		int image2 = [mSqliteManager pageImageId:row*6+5] ;
		
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

	
//}
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
-(void) loadPagesWithCell:(UITableViewCell*)cell tableView:(UITableView*)tableView indexPath:(NSIndexPath*) indexPath
{
	int row=indexPath.row;
	int max = [self noOfPages];
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	if(row*6+1< max) 
	{
		if(row==0) 
		{
			int image1 = [mSqliteManager pageImageId:row*6+1];
			int image2 = [mSqliteManager pageImageId:row*6+max] ;
			
			UIImage *cachedImage = [[self loadSpreadForLeftId:image1 andRightId:image2] retain];
			UIImageView *view=(UIImageView*) [cell viewWithTag:1];
			view.image = cachedImage;
			
			UIImageView *shadow = (UIImageView*) [cell viewWithTag:4];
			shadow.hidden = NO;
			[cachedImage release];
			
		}
		else
		{
			int image1 = [mSqliteManager pageImageId:row*6];
			int image2 = [mSqliteManager pageImageId:row*6+1] ;
			
			UIImage *cachedImage = [[self loadSpreadForLeftId:image1 andRightId:image2] retain];
			UIImageView *view=(UIImageView*) [cell viewWithTag:1];
			view.image = cachedImage;
			
			UIImageView *shadow = (UIImageView*) [cell viewWithTag:4];
			shadow.hidden = NO;
			[cachedImage release];
		}
		
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
	
	if(row*6+3 < max) 
	{
		int image1 = [mSqliteManager pageImageId:row*6+2];
		int image2 = [mSqliteManager pageImageId:row*6+3] ;
		
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
	if(row*6+5< max) 
	{
		int image1 = [mSqliteManager pageImageId:row*6+4];
		int image2 = [mSqliteManager pageImageId:row*6+5] ;
		
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
	//callee responsibility to cancel all previous page loads
	
	UIImage *spread = [self loadSpreadWithPageNumber:page];
	image.image = spread;
	
	FLSpreadLoader *operation = [[FLSpreadLoader alloc] initWithSpread:page andView:image];
	[mHighResolutionLoads addOperation:operation];
	[operation release];
}

-(void) cancelHighResolutionLoad
{
	[mHighResolutionLoads cancelAllOperations];
}
-(void) cancelHighResolutionLoadForPage:(int)index
{
	for(FLSpreadLoader *operation in [mHighResolutionLoads operations])
	{
		if(index == operation.page)
		{
			[operation cancel];
			//do not break. multiple loads of same page can be happening at once.
		}
	}
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
	priceLabel.text = [NSString stringWithFormat:@"$%d",[product.productPrice intValue]];
	UIImage *productImage;
	if (FL_NOT_REACHABLE)
	{	
		productImage = [UIImage imageNamed:ERROR_IMAGE];
	}
	else
	{
		productImage = [mCache objectForKey:product.productImagePath];
	}

	UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
	if(productImage == nil)
	{
		imageView.image = nil;//TODO:add loading image
		[mTableImageLoader loadImage:product.productImagePath withTag:1 forTable:tableView andIndexPath:indexPath];
	} else 
	{
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
	return [mWatchManager noOfWatches];
	
}
-(void) loadWatchImage:(UIImageView*)image withIndex:(int) index
{
	//image.contentMode = UIViewContentModeScaleAspectFit;
	NSArray *animationImages=nil;
	if(FL_LOAD_WATCH_SPIN_IMAGE)
	{
		animationImages = [[NSArray alloc] initWithObjects:
								[UIImage imageNamed:@"spinner1.png"],
								[UIImage imageNamed:@"spinner2.png"],
								[UIImage imageNamed:@"spinner3.png"],
								[UIImage imageNamed:@"spinner4.png"],
								[UIImage imageNamed:@"spinner5.png"],
								[UIImage imageNamed:@"spinner6.png"],
								[UIImage imageNamed:@"spinner7.png"],
								[UIImage imageNamed:@"spinner8.png"],
								[UIImage imageNamed:@"spinner9.png"],
								[UIImage imageNamed:@"spinner10.png"],
								[UIImage imageNamed:@"spinner11.png"],
								[UIImage imageNamed:@"spinner12.png"],
								nil];
		image.animationImages = animationImages;
		image.animationDuration = 1.0;
		image.contentMode = UIViewContentModeCenter;
		[image startAnimating];
	}
	image.image = nil;
	
	switch (image.tag)
	{
		case 1:
			if (mWatchListLoader1!=nil) {
				[mWatchListLoader1 cancel];
				[mWatchListLoader1 release];
			}
			mWatchListLoader1 = [[FLImageLoader alloc] init];
			
			mWatchListImageView1 = image;

			NSLog(@"image path :%@",[[FLDataManager sharedInstance] watchImagePath:index]);
			[mWatchListLoader1 loadImageForDelegate:self withUrlString:[[FLDataManager sharedInstance] watchImagePath:index]];
			 
			break;
		case 2:
			if (mWatchListLoader2!=nil) {
				[mWatchListLoader2 cancel];
				[mWatchListLoader2 release];
			}
			mWatchListLoader2 = [[FLImageLoader alloc] init];
			
			mWatchListImageView2 = image;
			[mWatchListLoader2 loadImageForDelegate:self withUrlString:[[FLDataManager sharedInstance] watchImagePath:index]];
			
			break;
			
		case 3:
			if (mWatchListLoader3==nil) {
				[mWatchListLoader3 cancel];
				[mWatchListLoader3 release];
			}
			mWatchListLoader3 = [[FLImageLoader alloc] init];
			
			mWatchListImageView3 = image;
			//-------------------Leak-----------
			[mWatchListLoader3 loadImageForDelegate:self withUrlString:[[FLDataManager sharedInstance] watchImagePath:index]];
			
			break;
			[mWatchListLoader3 release];
			
		default:
			break;
	}
	if(FL_LOAD_WATCH_SPIN_IMAGE)
	{
		[animationImages release];
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
	return [mWatchManager watchAtIndex:index];
}

-(NSString *)watchImagePath:(NSInteger) index
{
	return [mWatchManager watchImagePath:index];
}

#pragma mark -
#pragma mark menu image methods

-(void) storeMenuImage:(UIImage*) image
{
	if(!mMenuImage) {
		mMenuImage = [image retain];
	}
}
-(UIImage*) menuImage
{
	return [[mMenuImage retain] autorelease];
}

#pragma mark -
#pragma mark instance image methods

-(UIImage*) loadCoverImage //synchronous
{
	int coverPageId = [mSqliteManager pageImageId:1];
	NSString *imageIdString = [[NSString alloc] initWithFormat:@"%d_high",coverPageId];
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageIdString ofType:@"jpg"];
	
	UIImage *cachedImage = nil;
	if(imagePath) 
	{
		cachedImage = [[[UIImage alloc] initWithContentsOfFile:imagePath] autorelease];
	}
	
	[imageIdString release];
	return cachedImage;
}
-(void) receiveImageLoaded:(UIImage *)image byLoader:(id) sender
{
	
	if(image) 
	{
		if([sender isEqual:mWatchListLoader1]) 
		{
			if(FL_LOAD_WATCH_SPIN_IMAGE)
			{
				[mWatchListImageView1 stopAnimating];
				mWatchListImageView1.animationImages = nil;
			}
			mWatchListImageView1.contentMode =UIViewContentModeScaleAspectFit;
			mWatchListImageView1.image = image;
		}
		else if([sender isEqual:mWatchListLoader2])
		{
			if(FL_LOAD_WATCH_SPIN_IMAGE)
			{
				[mWatchListImageView2 stopAnimating];
				mWatchListImageView2.animationImages = nil;
			}
			mWatchListImageView2.contentMode =UIViewContentModeScaleAspectFit;
			mWatchListImageView2.image = image;
		}
		else if([sender isEqual:mWatchListLoader3])
		{
			if(FL_LOAD_WATCH_SPIN_IMAGE)
			{
				[mWatchListImageView3 stopAnimating];
				mWatchListImageView3.animationImages = nil;
			}
			mWatchListImageView3.contentMode =UIViewContentModeScaleAspectFit;
			mWatchListImageView3.image = image;
		}
		else
		{
			mCoverImageView.image = image;
		}
	}
	
	if([sender isEqual:mWatchListLoader1]) 
	{
		[mWatchListLoader1 release];
		mWatchListLoader1 = nil;
	}
	else if([sender isEqual:mWatchListLoader2])
	{
		[mWatchListLoader2 release];
		mWatchListLoader2 = nil;
	}
	else if([sender isEqual:mWatchListLoader3])
	{
		[mWatchListLoader3 release];
		mWatchListLoader3 = nil;
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
		[self addCacheGridImage:cachedImage withKey:image1];
		
		[im1 release];
		[im2 release];
	}
	return cachedImage;
}
/*
//-------------------------------------------------------------------------------
-(UIImage *) loadImageWithId:(NSString*)imageId
{
	//NSString *imageIdString = [[NSString alloc] initWithFormat:@"%d",imageId];
	NSLog(@",,,,,,,,,,,,,,,,,,,,,,,,,,,,,->%@",imageId);
	NSString *image1Path = [[NSBundle mainBundle] pathForResource:imageId ofType:@"jpg"];
	UIImage *cachedImage = nil;
	
	if(image1Path) 
	{
		
		cachedImage = [mCache objectForKey:image1Path];
		
		if(cachedImage == nil) 
		{
			UIImage *leftImage = [[UIImage alloc] initWithContentsOfFile:image1Path];
			
			NSString *imageId2String = [[NSString alloc] initWithFormat:@"%d",imageId];
			
			NSString *image2Path = [[NSBundle mainBundle] pathForResource:imageId2String ofType:@"jpg"];
			UIImage *rightImage = [[UIImage alloc] initWithContentsOfFile:image2Path];
			[imageId2String release];
			
			cachedImage = [FLWatchCatalogViewController combineImageLeft:leftImage andRight:rightImage];
			if(cachedImage)
			{
				[self addCacheGridImage:cachedImage withKey:image1Path];
			}
			
			[leftImage release];
			
		}
	}
	//[imageIdString release];
	return cachedImage;
	
}
		*/							
- (UIImage *) loadSpreadForLeftId:(int)image1 andRightId:(int)image2
{
	NSString *imageIdString = [[NSString alloc] initWithFormat:@"%d",image1];
	NSString *image1Path = [[NSBundle mainBundle] pathForResource:imageIdString ofType:@"jpg"];
	UIImage *cachedImage = nil;
	
	if(image1Path) 
	{
		
		cachedImage = [mCache objectForKey:image1Path];
				
		if(cachedImage == nil) 
		{
			UIImage *leftImage = [[UIImage alloc] initWithContentsOfFile:image1Path];
		
			NSString *imageId2String = [[NSString alloc] initWithFormat:@"%d",image2];
			
			NSString *image2Path = [[NSBundle mainBundle] pathForResource:imageId2String ofType:@"jpg"];
			UIImage *rightImage = [[UIImage alloc] initWithContentsOfFile:image2Path];
			[imageId2String release];
			
			cachedImage = [FLCatalogGridViewController combineImageLeft:leftImage andRight:rightImage];
			if(cachedImage)
			{
				[self addCacheGridImage:cachedImage withKey:image1Path];
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
	NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageIdString ofType:@"jpg"];

	UIImage *cachedImage = nil;
	if(imagePath) 
	{
	
	cachedImage = [mCache objectForKey:imagePath];
	if(cachedImage == nil) 
	{
		cachedImage = [[[UIImage alloc] initWithContentsOfFile:imagePath] autorelease];
		[self addCacheGridImage:cachedImage withKey:imagePath];
	}
	}
	[imageIdString release];
	
	return cachedImage;
}
	
-(UIImage *) loadSpreadWithPageNumber:(int) page
{
	
	int imageId = [mSqliteManager pageImageId:page];
	
	if(page< 2  && imageId!=[mSqliteManager pageImageId:2]) {
		//means cover+end page
		return [self loadSpreadForLeftId: [mSqliteManager pageImageId:1] andRightId:[mSqliteManager pageImageId:[mSqliteManager noOfPages]]];
	}
		return [self loadSpreadForLeftId:imageId andRightId:imageId+1];
}

-(NSString *) pageImagePath:(NSInteger) pageNumber
{
	return [mSqliteManager pageImagePath:pageNumber];
}
-(NSString *) highResImagePathForPage:(NSInteger) pageNumber
{
	@synchronized(self) 
	{		
		int imageId = [mSqliteManager pageImageId:pageNumber];
		NSString *url = [NSString stringWithFormat:@"%d_high",imageId];
		NSLog(@"loading high res= %@",url);
		return url;
	}
}



-(UIImage*) cacheImageWithKey:(NSString*)key
{
	UIImage *image = [mCache objectForKey:key];
	return image;
}
-(void) addCacheGridImage:(UIImage*)image withKey:(NSString*)key
{
	//[self addCacheImage:image withKey:key];
}
-(void) addCacheProductImage:(UIImage*)image withKey:(NSString*)key
{
	[self addCacheImage:image withKey:key];
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


#pragma mark -
#pragma mark switch DB methods

-(void)switchDataBase:(int)index
{
	//if(mDbIndex == index)return;
	mDbIndex = index;
	if(mDbIndex == 0)
	{
		[mSqliteManager release];
		mSqliteManager=[[FLSqliteDataBaseManager alloc] initWithDb:@"catalog"];
	}
	else if(mDbIndex == 1)
	{
		[mSqliteManager release];
		mSqliteManager=[[FLSqliteDataBaseManager alloc] initWithDb:@"watchcatalog"];
	}
	mDbIndex =index;
}


@end
