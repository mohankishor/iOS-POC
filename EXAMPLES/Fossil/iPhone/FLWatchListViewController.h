//
//  FLWatchListViewController.h
//  FLWatchListViewController
//
//  Created by Lokesh P on 17/09/10.
//  Copyright Sourcebits Technologies  2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLWatchListScrollView.h"
#import "FLBaseViewController.h"
#import "FLImageView.h"
#import "FLCustomAlertView.h"
#import "FLShopNowAlertView.h"

@interface FLWatchListViewController : FLBaseViewController <FLWatchListScrollViewDelegate>
{
	FLWatchListScrollView         *mWatchListScrollView;
	FLImageView					 		*mPreviousImage;
	FLImageView					    	 *mCurrentImage;
	FLImageView							    *mNextImage;
	FLCustomAlertView				  *mCustomAlertView;
	FLShopNowAlertView				    *mShopAlertView;
}
@property (nonatomic, retain)IBOutlet FLWatchListScrollView *mWatchListScrollView;
@property (nonatomic, retain)FLImageView *mPreviousImage;
@property (nonatomic, retain)FLImageView *mCurrentImage;
@property (nonatomic, retain)FLImageView *mNextImage;
-(void) showPrevious;
-(void) showNext;
-(void) updateImageCountWithImages:(int)mTotalWatches forCurrentImage:(int)page;
@end

