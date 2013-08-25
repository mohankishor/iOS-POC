//
//  FLImageLoader.h
//  Fossil
//
//  Created by Darshan on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FLImageLoaderDelegate

@required

- (void) receiveImageLoaded:(UIImage*) image byLoader:(id) sender;//image ownership transferred

@end


@interface FLImageLoader : NSObject
{
	NSMutableData		          *mData;
	id <FLImageLoaderDelegate> mDelegate;
	NSURLConnection         *mConnection;
}

- (void) loadImageForDelegate:(id<FLImageLoaderDelegate>) delegate withUrlString:(NSString*) urlString;

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response;

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data;

- (void) connectionDidFinishLoading:(NSURLConnection *) connection;

- (void) connection:(NSURLConnection *) connection didFailWithError:(NSError *) error;
- (void) cancel;
@end



@interface FLTableImageNode : NSObject
{
@public
	NSIndexPath     *mIndexPath;
	UITableView     *mTableView;
	NSUInteger      mTag;
	FLImageLoader *mImageLoader;
	NSString	*mImagePath;
} 

@property (nonatomic, assign) NSUInteger tag;
@property (nonatomic, assign) NSIndexPath *indexPath;
@property (nonatomic, assign) UITableView *tableView;
@property (nonatomic, retain) FLImageLoader *imageLoader;
@property (nonatomic, retain) NSString *imagePath;

@end

@interface FLTableImageLoader : NSObject<FLImageLoaderDelegate>
{
	NSMutableSet *mActiveDownloads;
}

//loads the images and updates the table view images when load completes
- (void) loadImage:(NSString *)path withTag:(int)tag forTable:(UITableView*) tableView andIndexPath:(NSIndexPath*) indexPath;

- (void) receiveImageLoaded:(UIImage*) image byLoader:(id) sender;

@end