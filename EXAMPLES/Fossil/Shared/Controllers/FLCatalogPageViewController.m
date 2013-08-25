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
#import"FLShopNowAlertView.h"
#import "AppDelegate.h"

@implementation FLCatalogPageViewController

@synthesize scrollView = mScrollView;
@synthesize currentSpread = mCurrentSpread;



- (id) initWithPageNumber:(int) spread
{
	self = [super initWithNibName:nil bundle:nil];
	
	if (self)
	{
		mCurrentSpread = spread; //mCurrentSpread is 0 based page index. 0,1,2,...n-1
	}
	return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView 
{
	[super loadView];
	NSLog(@"long ");
	CGRect pageFrame = [UIScreen mainScreen].bounds;//TODO:check why bounds or applicationFrame doesnt work
	if (FL_IS_IPAD)
	{
		pageFrame = CGRectMake(0,0,FL_IPAD_WIDTH,FL_IPAD_HEIGHT-FL_IPAD_NAVBAR_HEIGHT);
	}
	else
	{
		pageFrame = CGRectMake(0,0,FL_IPHONE_WIDTH,FL_IPHONE_HEIGHT);
	}
	UIView *mainView = [[UIView alloc] init];
	mainView.frame = pageFrame;
	mainView.backgroundColor = [UIColor blackColor];
	
	mScrollView = [[UIScrollView alloc] init];
	mScrollView.frame = pageFrame;
	mScrollView.backgroundColor=[UIColor darkGrayColor];
	
	mScrollView.pagingEnabled = YES;
	mScrollView.delegate = self;
	mScrollView.scrollsToTop = NO;
	mScrollView.showsVerticalScrollIndicator = NO;
	mScrollView.showsHorizontalScrollIndicator = YES;
	mScrollView.canCancelContentTouches = YES; 
	
	[mainView addSubview:mScrollView];	
	
	CGFloat width = [self spreadCount] * pageFrame.size.width;
	[mScrollView setContentSize:CGSizeMake(width, pageFrame.size.height)];
	[mScrollView setContentOffset:CGPointMake(mCurrentSpread * pageFrame.size.width, 0)];
	
	mRecycledPages = [[NSMutableSet alloc] init];
	mVisiblePages = [[NSMutableSet alloc] init];
	[self tilePages]; //position the initial spread pages
	
	self.view = mainView;
	[mainView release];
}

-(void) createToolbarItems
{
	[super createToolbarItems];
	[self updateToolbarIconsForCurrentSpread];
}
-(void) showGrid
{
	[self forceHideBars];
	[self.navigationController popViewControllerAnimated:YES];
}
-(void) showNext
{
	[self showNextPageImage];
}
-(void) showPrevious
{
	[self showPreviousPageImage];
}
-(void) updateToolbarIconsForCurrentSpread
{
	UIBarButtonItem *left=[self.toolbarItems objectAtIndex:TB_PREV_INDEX];
	if(mCurrentSpread == 0)
		left.enabled = NO;
	else
		left.enabled = YES;
	
	UIBarButtonItem *next=[self.toolbarItems objectAtIndex:TB_NEXT_INDEX];
	if(mCurrentSpread == [self spreadCount]-1)
		next.enabled = NO;
	else
		next.enabled = YES;
}
- (void) viewDidLoad
{
	[super viewDidLoad];
}
	

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
	
	self.scrollView = nil;
	[mRecycledPages release];
	mRecycledPages = nil;
	[mVisiblePages release];
	mVisiblePages = nil;
}

- (void) dealloc
{
	self.scrollView = nil;
	[mRecycledPages release];
	mRecycledPages = nil;
	[mVisiblePages release];
	mVisiblePages = nil;
	[mCustomAlertView release];
    [super dealloc];	
}

#pragma mark instance methods
- (int) spreadCount
{
	return (([[FLDataManager sharedInstance] noOfPages])/2);
}
	
- (void) tilePages 
{
    // Calculate which pages are visible
	CGRect visibleBounds = mScrollView.bounds;
	CGFloat spreadWidth = CGRectGetWidth(visibleBounds);
	
	int firstNeededSpreadIndex = floorf((CGRectGetMinX(visibleBounds)+5.0) / spreadWidth);//5 pixels for buffering the bounce back of scrollview
	int lastNeededSpreadIndex  = floorf((CGRectGetMaxX(visibleBounds)-5.0) / spreadWidth);
	

    firstNeededSpreadIndex = MAX(firstNeededSpreadIndex, 0);
    lastNeededSpreadIndex  = MIN(lastNeededSpreadIndex, [self spreadCount] - 1);
	
    // Recycle no-longer-visible pages 
    for (FLScrollView *page in mVisiblePages)
	{
        if (page.tag < firstNeededSpreadIndex || page.tag > lastNeededSpreadIndex)
		{
            [mRecycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    [mVisiblePages minusSet:mRecycledPages];
    
    // add missing pages
    for (int index = firstNeededSpreadIndex; index <= lastNeededSpreadIndex; index++)
	{
        if (![self isDisplayingSpreadForIndex:index])
		{
            FLScrollView *page = [self dequeRecycledPage];
			
            if (page == nil)
			{
                page = [[[FLScrollView alloc] init] autorelease];
            }
			else
			{
				[[FLDataManager sharedInstance] cancelHighResolutionLoadForPage:(page.index)*2];
			}
            [self configurePage:page forIndex:index];
            [mScrollView addSubview:page];
            [mVisiblePages addObject:page];
        }
    }    
}

- (void) showPreviousPageImage
{
	int pageCount = mCurrentSpread;
	
	
	pageCount -= 1;

	if (pageCount >= 0)
	{
		[mScrollView setContentOffset:CGPointMake(pageCount * mScrollView.frame.size.width, 0) animated:NO];
		mCurrentSpread = pageCount;
	}
	
	[self updateToolbarIconsForCurrentSpread];
}

- (void) showNextPageImage
{
	int pageCount = mCurrentSpread;

	pageCount += 1;

	if (pageCount < [self spreadCount])
	{
		[mScrollView setContentOffset:CGPointMake(pageCount * mScrollView.frame.size.width, 0) animated:NO];
		mCurrentSpread = pageCount;
	}
	
	[self updateToolbarIconsForCurrentSpread];
}

- (void) setCurrentSpread:(int) current
{
	//reset all zoomscales if page changed
	if(mCurrentSpread != current)
	{
		for(FLScrollView *page in mVisiblePages) 
		{
			page.zoomScale = 1.0f;
		}
	}
	mCurrentSpread = current;
}

- (void) scrollViewDidEndDragging:(UIScrollView *) scrollView willDecelerate:(BOOL) decelerate
{
	//update the current spread index
	if(decelerate == NO)
	{
		self.currentSpread = floorf(CGRectGetMidX(mScrollView.bounds) / CGRectGetWidth(mScrollView.bounds));
	}
	[self updateToolbarIconsForCurrentSpread];
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *) scrollView
{
	//update the current spread index
	self.currentSpread = floorf(CGRectGetMidX(mScrollView.bounds) / CGRectGetWidth(mScrollView.bounds));
	
	[self updateToolbarIconsForCurrentSpread];
}

- (BOOL) isDisplayingSpreadForIndex:(int) index
{
	BOOL ret = NO;
	for(UIImageView *page in mVisiblePages) 
	{
		if(page.tag == index)
		{
			ret = YES;
			break;
		}
	}
	return ret;
}

- (void) configurePage:(FLScrollView*) page forIndex:(int) spread
{
	CGRect frame = CGRectMake( spread * mScrollView.frame.size.width, 0, mScrollView.frame.size.width, mScrollView.frame.size.height);
	page.frame = frame;
	page.tag = spread;
	page.zoomScale = 1.0f;
	page.actionDelegate = self;
	page.index = spread;
	page.imageView.frame = CGRectMake(0,0,frame.size.width,frame.size.height);
	if([page superview])
	{
		[page removeFromSuperview];
	}
	
	[[FLDataManager sharedInstance] loadHighResolutionSpread:(spread)*2 forImageView:page.imageView];
	
}

- (FLScrollView*) dequeRecycledPage
{
	id ret = [mRecycledPages anyObject];
	if(ret)
	{
		[[ret retain] autorelease];
		[mRecycledPages removeObject:ret];
	}
	return ret;
}
#pragma mark scrollView delegate 
- (void) scrollViewDidScroll:(UIScrollView *) scrollView
{	
	[self tilePages];
}


#pragma mark image action delegate
- (void) imageTapped: (id) sender
{
	NSLog(@"imageTapped");
	[self toggleBars];
}



-(void) showInfo
{
	//Showing memory warning at below line
	[self toggleBars];
	[self.navigationController gotoCatalogProductViewControllerWithPage:(mCurrentSpread)*2];
}

-(void)showBag
{
	[self toggleBars];
	[super showBag];
	
}

-(void)toggleBars
{
	if(self.navigationController.toolbarHidden)
	{
		mCustomAlertView = [[FLShopNowAlertView alloc] initWithText:@"" watchPath:@""];
		
		mCustomAlertView.navDelegate = self.navigationController;
		mCustomAlertView.delegate = self;
		[self.view addSubview:mCustomAlertView.view];
		[mCustomAlertView performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:0.0];
		self.scrollView.scrollEnabled=NO;
		self.scrollView.multipleTouchEnabled = NO;
		FL_APP_DELEGATE.alertDisplay=YES;
		//self.scrollView.contentScaleFactor = 1.0;
	 }
	else 
	{
		[mCustomAlertView dismiss];
		self.scrollView.scrollEnabled=YES;
		FL_APP_DELEGATE.alertDisplay= NO;
	}
	[super toggleBars];
	
 }

@end
