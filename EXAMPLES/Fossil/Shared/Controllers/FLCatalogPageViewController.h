//
//  FLCatalogPageViewController.h
//  Fossil
//
//  Created by Ganesh Nayak on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBaseViewController.h"
#import "FLScrollView.h"
#import"FLShopNowAlertView.h"

@interface FLCatalogPageViewController : FLBaseViewController <UIScrollViewDelegate,FLImageViewDelegate>
{
	UIScrollView            *mScrollView;
	int					  mCurrentSpread;//mCurrentSpread is 0 based page index. 0,1,2,...n-1
	NSMutableSet		 *mRecycledPages;//stores FLScrollView pages
	NSMutableSet		  *mVisiblePages;
	FLShopNowAlertView *mCustomAlertView;
}


@property (nonatomic, assign) int currentSpread;
@property (nonatomic, retain) UIScrollView *scrollView;

- (id) initWithPageNumber:(int) spread;

- (void) tilePages;
- (int) spreadCount;
- (BOOL) isDisplayingSpreadForIndex:(int) index;
- (void) configurePage:(FLScrollView*) page forIndex:(int) spread;
- (FLScrollView*) dequeRecycledPage;

- (void) imageTapped: (id) sender;

- (void) showNextPageImage;
- (void) showPreviousPageImage;
-(void) updateToolbarIconsForCurrentSpread;
@end

