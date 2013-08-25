//
//  FLCatalogPageViewController.h
//  Fossil
//
//  Created by Ganesh Nayak on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBaseViewController.h"
#import "FLImageView.h"

typedef enum
{
	ScrollViewModeNotInitialized,           // view has just been loaded
	ScrollViewModePaging,                   // fully zoomed out, swiping enabled
	ScrollViewModeZooming,                  // zoomed in, panning enabled
} ScrollViewMode;

@interface FLCatalogPageViewController : FLBaseViewController <UIScrollViewDelegate>
{
	UIScrollView          *mScrollView;
	int                    mPageNumber;
	FLImageView	   *mPreviousImageView;
	FLImageView     *mCurrentImageView;
	FLImageView		   *mNextImageView;
	ScrollViewMode     mScrollViewMode;
	CGFloat        mPendingOffsetDelta;
	NSArray				   *mPageViews;
	int					  mCurrentPage;
}


@property (nonatomic, assign) int pageNumber;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, retain) NSArray * pageViews;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIImageView *nextImageView;
@property (nonatomic, retain) UIImageView *currentImageView;
@property (nonatomic, retain) UIImageView *previousImageView;


- (id) initWithPageNumber:(int) page;

- (void) setImageToView;


@end

