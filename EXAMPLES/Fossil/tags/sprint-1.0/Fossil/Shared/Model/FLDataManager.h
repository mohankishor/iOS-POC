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

@class FLSqliteDataBaseManager;

@interface FLDataManager : NSObject <FLDataManagerProtocol,FLImageLoaderDelegate>
{
@private
	FLSqliteDataBaseManager *mSqliteManager;
	
	FLImageLoader *mCoverImageLoader;
	UIImageView *mCoverImageView;
	
	FLTableImageLoader *mTableImageLoader;
	NSMutableDictionary *mCache;
}

+ (FLDataManager*)sharedInstance;

-(NSInteger) noOfPages;
-(NSString *) pageImagePath:(NSInteger) pageNumber;

-(UIImage*) lowResCoverImage;
-(void) loadCoverImage:(UIImageView*)imageView;
-(void) receiveImageLoaded:(UIImage *)image byLoader:(id) self;
-(void) loadPagesWithCell:(UITableViewCell*)cell tableView:(UITableView*)tableView indexPath:(NSIndexPath*) indexPath;
-(UIImage *) loadSpreadForLeft:(NSString*)image1 andRight:(NSString*)image2;
-(UIImage *) loadSpreadForLeftId:(int)image1 andRightId:(int)image2;
-(UIImage *) loadImageWithId:(NSInteger) imageid;

-(void) clearCache;

@end

