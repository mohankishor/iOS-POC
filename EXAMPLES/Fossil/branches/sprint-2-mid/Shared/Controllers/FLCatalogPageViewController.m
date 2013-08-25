//
//  FLCatalogPageViewController.m
//  Fossil
//
//  Created by Ganesh Nayak on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCatalogPageViewController.h"
#import "FLDataManager.h"
#import "FLImageView.h"

@implementation FLCatalogPageViewController

@synthesize pageViews = mPageViews;
@synthesize pageNumber = mPageNumber;
@synthesize scrollView = mScrollView;
@synthesize currentPage = mCurrentPage;
@synthesize nextImageView = mNextImageView;
@synthesize currentImageView = mCurrentImageView;
@synthesize previousImageView = mPreviousImageView;

-(id)initWithPageNumber:(int) page
{
	self = [super initWithNibName:nil bundle:nil];
	
	if (self)
	{
		mPageNumber = page;
		mPageNumber *= 2;
	}
	return self;
}

- (CGFloat) imageHeight
{
	CGFloat height;
	
	if (FL_IS_IPAD)
	{
		height = FL_IPAD_HEIGHT;
	}
	else
	{
		height = FL_IPHONE_HEIGHT;
	}
	return height;
}

- (CGFloat) imageWidth
{
	CGFloat width;
	
	if (FL_IS_IPAD)
	{
		width = FL_IPAD_WIDTH;
	}
	else
	{
		width = FL_IPHONE_WIDTH;
	}
	return width;
}

- (CGSize) pageSize
{
	CGSize pageSize = mScrollView.frame.size;
	
	if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation))
	{
		return CGSizeMake(pageSize.height, pageSize.width);
	}
	else
	{
		return pageSize;
	}
}

- (void) setPagingMode
{
	CGFloat height = [self imageHeight];
	CGFloat width = [self imageWidth];
	
	// reposition pages side by side, add them back to the view

	NSUInteger page = 0;
	
	for (UIView *view in mPageViews)
	{
		if (!view.superview)
		{
			[mScrollView addSubview:view];
		}
		view.frame = CGRectMake(width * page++, 0, width, height);
	}
	
	mScrollView.pagingEnabled = YES;
	mScrollView.showsVerticalScrollIndicator = mScrollView.showsHorizontalScrollIndicator = NO;
	mScrollView.contentSize = CGSizeMake(width * [mPageViews count], height);
	mScrollView.contentOffset = CGPointMake(width * mCurrentPage, 0);
	mScrollViewMode = ScrollViewModePaging;
}

- (void) setZoomingMode
{
	mScrollViewMode = ScrollViewModeZooming;
	
	NSUInteger page = 0;

	for (UIView *view in mPageViews)
	{
		if (mCurrentPage != page++)
		{
			[view removeFromSuperview];
		}
	}
	mScrollView.pagingEnabled = NO;
	mScrollView.showsVerticalScrollIndicator = mScrollView.showsHorizontalScrollIndicator = YES;
	mPendingOffsetDelta = mScrollView.contentOffset.x;
	mScrollView.bouncesZoom = YES;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView 
{

	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	mainView.backgroundColor = [UIColor blackColor];
	self.view = mainView;
	[mainView release];
	
	CGFloat width = [self imageWidth];
	CGFloat height = [self imageHeight];
	
	mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	mScrollView.backgroundColor=[UIColor darkGrayColor];
	mScrollView.userInteractionEnabled = YES;
	
	[self.view addSubview:mScrollView];	
	
	mScrollView.pagingEnabled = YES;
  	mScrollView.delegate = self;
	mScrollView.scrollsToTop = NO;
	mScrollView.showsVerticalScrollIndicator = NO;
	mScrollView.showsHorizontalScrollIndicator = NO;

	[mScrollView setContentSize:CGSizeMake(width * 3, height)];
	
	mPreviousImageView = [[FLImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
	mCurrentImageView = [[FLImageView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
	mNextImageView = [[FLImageView alloc] initWithFrame:CGRectMake(width * 2, 0, width, height)];
	
	mPreviousImageView.delegate = self;
	mCurrentImageView.delegate = self;
	mNextImageView.delegate = self;

	
	mPreviousImageView.userInteractionEnabled = YES;
	mCurrentImageView.userInteractionEnabled = YES;
	mNextImageView.userInteractionEnabled = YES;
	
	mPreviousImageView.contentMode = UIViewContentModeScaleAspectFit;
	mCurrentImageView.contentMode = UIViewContentModeScaleAspectFit;
	mNextImageView.contentMode = UIViewContentModeScaleAspectFit;

	
	mPageViews = [[NSArray alloc] initWithObjects:mPreviousImageView, mCurrentImageView, mNextImageView, nil];

	[mScrollView addSubview:mPreviousImageView];
	[mScrollView addSubview:mCurrentImageView];
	[mScrollView addSubview:mNextImageView];
	mScrollView.maximumZoomScale = 3.0f;
	mScrollView.minimumZoomScale = 1.0f;
}

- (void) productPage
{
	[self.navigationController gotoCatalogProductViewControllerWithPage:mPageNumber];
}

- (void) setImageToView
{
	CGFloat width = [self imageWidth];
	CGFloat height = [self imageHeight];	
	
	int maxPages = [[FLDataManager sharedInstance] noOfPages];
	
	maxPages -=2;
	
	if (mPageNumber == maxPages)
	{
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber-4 forImageView:mPreviousImageView];
		CGRect rect = mPreviousImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = 0;
		mPreviousImageView.frame = rect;
		
		
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber-2 forImageView:mCurrentImageView];
		rect = mCurrentImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = width;
		mCurrentImageView.frame = rect;
		
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber forImageView:mNextImageView];
		
		rect = mNextImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = width * 2;
		mNextImageView.frame = rect;
		
	}
	
	if (mPageNumber == 2)
	{
		
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber forImageView:mPreviousImageView];
		
		CGRect rect = mPreviousImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = 0;
		mPreviousImageView.frame = rect;
		
		
		
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber+2 forImageView:mCurrentImageView];
		rect = mCurrentImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = width;
		mCurrentImageView.frame = rect;
		
		
		
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber+4 forImageView:mNextImageView];
		rect = mNextImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = width * 2;
		mNextImageView.frame = rect;
		
	}
	
	
	if (mPageNumber > 2 && mPageNumber < maxPages)
	{
		
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber-2 forImageView:mPreviousImageView];
		CGRect rect = mPreviousImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = 0;
		mPreviousImageView.frame = rect;
		
		
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber forImageView:mCurrentImageView];
		rect = mCurrentImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = width;
		mCurrentImageView.frame = rect;
		
		
		
		[[FLDataManager sharedInstance] loadHighResolutionSpread:mPageNumber+2 forImageView:mNextImageView];
		rect = mNextImageView.frame;
		rect.size.height = height;
		rect.size.width = width;
		rect.origin.x = width * 2;
		mNextImageView.frame = rect;
		
	}
}

- (void) currentPageForZooming:(NSUInteger) page
{
	if (page == mCurrentPage)
		return;
	mCurrentPage = page;
}

#pragma mark scrollView delegate 
- (void) scrollViewDidScroll:(UIScrollView *) scrollView
{	
	CGFloat width = [self imageWidth];

	if (mScrollViewMode == ScrollViewModePaging)
	{
		int maxPages = [[FLDataManager sharedInstance] noOfPages];

		maxPages -= 2;
		CGPoint  value = [mScrollView contentOffset];		
		
		if (value.x == width && mPageNumber == 2)
		{			
			mPageNumber += 2;
		}
		if (value.x == width * 2 && mPageNumber == maxPages )
		{
			mPageNumber -= 2;
		}
		if (value.x == width * 2 && mPageNumber < maxPages - 2)
		{
			CGPoint size;
			size.x = width;
			size.y = 0;
			
			[mScrollView setContentOffset:size animated:NO];

			mPageNumber += 2;
			[self setImageToView];
		}
		if (value.x == 0 && mPageNumber > 4)
		{
			CGPoint size;
			size.x = width;
			size.y = 0;
			[mScrollView setContentOffset:size animated:NO];
			mPageNumber -= 2;
			[self setImageToView];
		}
		
		if (mScrollViewMode == ScrollViewModePaging)
		{
			[self currentPageForZooming:roundf(mScrollView.contentOffset.x / width)];
		}
	}
}

 //Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad 
{
    [super viewDidLoad];

	mScrollViewMode = ScrollViewModeNotInitialized;
}

- (void) viewWillAppear:(BOOL) animated
{
	[self setPagingMode];
	
	int maxPages = [[FLDataManager sharedInstance] noOfPages];

	CGFloat width = [self imageWidth];

	CGPoint size;

	if (mPageNumber == 2)
	{
		size.x = 0;
		size.y = 0;
	}
	else if (mPageNumber == maxPages - 2)
	{
		size.x = width * 2;
		size.y = 0;
	}
	else
	{
		size.x = width;
		size.y = 0;
	}
	
	[mScrollView setContentOffset:size animated:NO];

	[self setImageToView];
	
	
	[self createToolbarItems:self];

}

- (void) zoomInOut:(CGPoint) clickedPoint
{
	CGFloat width = [self imageWidth];
	UIImageView *imgView = [mPageViews objectAtIndex:mCurrentPage];

	if ([imgView frame].size.width == width)
	{
		[mScrollView zoomToRect:CGRectMake(clickedPoint.x, clickedPoint.y, 0.0, 0.0) animated:YES];
	}
	else
	{
		[mScrollView zoomToRect:imgView.frame animated:YES];
	}
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) aScrollView
{
	UIView *imgView = [mPageViews objectAtIndex:mCurrentPage];
	
	if (mScrollViewMode != ScrollViewModeZooming)
	{
		[self setZoomingMode];
		
		CGFloat width = [self imageWidth];
		CGFloat height = [self imageHeight];
		
		imgView.center = CGPointMake(imgView.center.x - mPendingOffsetDelta, imgView.center.y);
		
		mScrollView.contentOffset = CGPointMake(mScrollView.contentOffset.x - mPendingOffsetDelta, mScrollView.contentOffset.y);
		mScrollView.contentSize = CGSizeMake(width * mScrollView.zoomScale, height * mScrollView.zoomScale);
		mPendingOffsetDelta = 0;
	}
	
	return [mPageViews objectAtIndex:mCurrentPage];
}

- (void) scrollViewDidEndZooming:(UIScrollView *) aScrollView withView:(UIView *) view atScale:(float) scale
{
	CGFloat width = [self imageWidth];
	CGFloat height = [self imageHeight];
	
	if (mScrollView.zoomScale == mScrollView.minimumZoomScale)
	{
		[self setPagingMode];
	}
	
	if (mPendingOffsetDelta > 0)
	{
		view.center = CGPointMake(view.center.x - mPendingOffsetDelta, view.center.y);

		mScrollView.contentOffset = CGPointMake(mScrollView.contentOffset.x - mPendingOffsetDelta, mScrollView.contentOffset.y);
		mScrollView.contentSize = CGSizeMake(width * mScrollView.zoomScale, height * mScrollView.zoomScale);
		mPendingOffsetDelta = 0;
	}
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[[FLDataManager sharedInstance] clearCache];
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (void) dealloc
{
	self.pageViews = nil;
	self.scrollView = nil;
	self.nextImageView = nil;
	self.currentImageView = nil;
	self.previousImageView = nil;
	
    [super dealloc];	
}

@end
