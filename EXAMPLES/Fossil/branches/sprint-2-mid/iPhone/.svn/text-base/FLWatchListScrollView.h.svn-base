//
//  FLWatchListScrollView.h
//  FLWatchListViewController
//
//  Created by Lokesh P on 17/09/10.
//  Copyright 2010 Sourcebits Technologies . All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLWatchListScrollView;

@protocol FLWatchListScrollViewDelegate
@required

-(UIView*)viewForItemAtIndex:(FLWatchListScrollView*)scrollView index:(NSInteger)index;
-(NSInteger)itemCount:(FLWatchListScrollView*)scrollView;
@end

@interface FLWatchListScrollView : UIView <UIScrollViewDelegate>
{
	UIScrollView								     *mScrollView;	
	id<FLWatchListScrollViewDelegate, NSObject>         mDelegate;
	NSMutableArray								*mScrollViewPages;
	BOOL											 mFirstLayout;
	CGSize											    mPageSize;
	int                                              mTotalWatches;
}
@property (nonatomic, retain) UIScrollView *mScrollView;
@property (nonatomic, assign) id<FLWatchListScrollViewDelegate, NSObject> mDelegate;
@property (nonatomic, assign) BOOL mFirstLayout;
@property (nonatomic, assign) CGSize mPageSize;
-(void) showPreviousImage;
-(void)     showNextImage;

@end
