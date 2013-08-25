//
//  FLDataManager.h
//  Fossil
//
//  Created by Darshan on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLDataManagerProtocol.h"
#import "FLImageLoader.h"
#import "FLWatchManager.h"

@class FLSqliteDataBaseManager;
@class FLWatchManager;

@interface FLDataManager : NSObject <FLDataManagerProtocol,FLImageLoaderDelegate>
{
@private
	
	
	
	FLSqliteDataBaseManager *mSqliteManager;
	
	FLImageLoader *mCoverImageLoader;
	UIImageView *mCoverImageView;
	
	FLTableImageLoader *mTableImageLoader;
	NSMutableDictionary *mCache;
	
	NSMutableArray *mProductImageLoads;
	NSOperationQueue *mHighResolutionLoads;
	
	FLImageLoader *mWatchListLoader1;
	UIImageView *mWatchListImageView1;
	FLImageLoader *mWatchListLoader2;
	UIImageView *mWatchListImageView2;
	FLImageLoader *mWatchListLoader3;
	UIImageView *mWatchListImageView3;
	
	UIImage *mMenuImage;
	int mDbIndex;
	
	FLWatchManager *mWatchManager;
}
//---------------------------------------
-(UIImage *) loadImageWithId:(NSString*)imageId;
-(void) loadImagesWithCell:(UITableViewCell*)cell tableView:(UITableView*)tableView indexPath:(NSIndexPath*) indexPath;
-(void)switchDataBase:(int)index;
//---------------------------------------
+ (FLDataManager*)sharedInstance;

-(void) loadCoverImage:(UIImageView*)imageView;
-(void) clearCache;

-(NSInteger) noOfPages;
-(void) loadPagesWithCell:(UITableViewCell*)cell tableView:(UITableView*)tableView indexPath:(NSIndexPath*) indexPath;
-(void) cancelAllPageLoads;

-(void) loadHighResolutionSpread:(NSInteger) page forImageView:(UIImageView*) image;
-(void) cancelHighResolutionLoadForPage:(int)index;
-(void) cancelHighResolutionLoad;

-(NSInteger) noOfProductsInPage:(NSInteger)pageNumber;
-(FLProduct *) productInPage:(NSInteger) pageNumber withIndex:(NSInteger) index; 
-(void) loadProduct:(FLProduct *) product withCell:(UITableViewCell*) cell tableView:(UITableView*)tableView indexPath:(NSIndexPath*) indexPath;
-(void) cancelAllProductLoads;

 
-(NSInteger) noOfWatches;
-(void) loadWatchImage:(UIImageView*)image withIndex:(int) index;
-(void) cancelWatchLoad:(UIImageView*)image withIndex:(int) index;
-(FLProduct *)watchAtIndex:(NSInteger) index; 

-(void) storeMenuImage:(UIImage*) image;
-(UIImage*) menuImage;

-(UIImage*) cacheImageWithKey:(NSString*)key;
-(void) addCacheGridImage:(UIImage*)image withKey:(NSString*)key;
-(void) addCacheProductImage:(UIImage*)image withKey:(NSString*)key;
-(NSString *) highResImagePathForPage:(NSInteger) pageNumber;
@end

