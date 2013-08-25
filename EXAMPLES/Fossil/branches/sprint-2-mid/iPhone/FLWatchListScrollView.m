//
//  FLWatchListScrollView.m
//  FLWatchListViewController
//
//  Created by Lokesh P on 17/09/10.
//  Copyright 2010 Sourcebits Technologies . All rights reserved.
//

#import "FLWatchListScrollView.h"
#import "FLDataManager.h"

@implementation FLWatchListScrollView

@synthesize mScrollView, mFirstLayout, mPageSize, mDelegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame]))
	{
        // Initialization code
		mFirstLayout = YES;
    }
    return self;
}

-(void) awakeFromNib
{
	mFirstLayout=YES;
	mTotalWatches = [[FLDataManager sharedInstance] noOfWatches];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) loadPage:(NSInteger) page
{

	if (page<0)
	{
		return;
	}
	if (page>=mTotalWatches) 
	{
		return;
	}
	 //Check if the page is already loaded
	UIView *view = [mScrollViewPages objectAtIndex:page];

	
	if ((NSNull *)view ==[NSNull null])
	{
		view = [mDelegate viewForItemAtIndex:self index:page+1];
		[mScrollViewPages replaceObjectAtIndex:page withObject:view];
	}

	if (view.superview == nil)
	{
		// Position the view in our scrollview
		// set view specific possition in scroll view 
		CGRect viewFrame = view.frame;
		viewFrame.origin.x = (viewFrame.size.width * page);
		viewFrame.origin.y = 0;
		view.frame = viewFrame;
		[self.mScrollView addSubview:view];
		
	}
	
}
// override point. called by layoutIfNeeded automatically. base implementation does nothing

-(void) layoutSubviews
{
	if(mFirstLayout)
	{
		// Position and size the scrollview. It will be centered in the view.
		CGRect scrollViewRect = CGRectMake(0, 0, mPageSize.width, mPageSize.height);
		scrollViewRect.origin.x = ((self.frame.size.width - mPageSize.width) / 2);
		scrollViewRect.origin.y = ((self.frame.size.height - mPageSize.height) / 2);
		
		mScrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
		mScrollView.clipsToBounds = NO; // Important, this creates the "preview"
		mScrollView.pagingEnabled = YES;
		mScrollView.showsHorizontalScrollIndicator = NO;
		mScrollView.showsVerticalScrollIndicator = NO;
		mScrollView.delegate = self;
		[self addSubview:mScrollView];
		int pageCount = [mDelegate itemCount:self];
		mScrollViewPages = [[NSMutableArray alloc] initWithCapacity:pageCount];
		// Fill our pages collection with empty placeholders
		for(int i = 0; i < pageCount; i++)
		{
			[mScrollViewPages addObject:[NSNull null]];
		}

		// Calculate the size of all combined views that we are scrolling through 
		mScrollView.contentSize = CGSizeMake(pageCount * mScrollView.frame.size.width, mScrollView.frame.size.height);
		[self loadPage:0];
		[self loadPage:1];
		mFirstLayout = NO;
	}
	
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	
	// If the point is not inside the scrollview, ie, in the preview areas we need to return
	// the scrollview here for interaction to work
	if (!CGRectContainsPoint(mScrollView.frame, point)) {
		return self.mScrollView;
	}
	
	// If the point is inside the scrollview there's no reason to mess with the event.
	// This allows interaction to be handled by the active subview just like any scrollview
	return [super hitTest:point	withEvent:event];
}

- (int)currentPage
{
	// Calculate which page is visible 
	CGFloat pageWidth = mScrollView.frame.size.width;
	int page = floor((mScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	return page;	
}

-(void)showPreviousImage
{
	int page = [self currentPage];
	page= page-1;
	if (page >=0)
	{
		[mScrollView setContentOffset:CGPointMake(page*mScrollView.frame.size.width,0) animated:YES];

	}
}

-(void) showNextImage
{
	int page = [self currentPage]+1;
	if (page < mTotalWatches && page >= 1)
	{
		[mScrollView setContentOffset:CGPointMake(page*mScrollView.frame.size.width,0) animated:YES];
	}
	
}
#pragma mark scrollview delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	int page = [self currentPage];
	// Load the visible and neighbouring pages
	[self loadPage:page-1];
	[self loadPage:page];
	[self loadPage:page+1];
	[mDelegate updateImageCountWithImages:mTotalWatches forCurrentImage:page+1];
	// Load the visible and neighbouring pages 	
	int currentPage = page;
	// unload the pages which are no longer visible
	int numberOfPages = [mScrollViewPages count];
	for (int i = 0; i < numberOfPages; i++) 
	{
		UIView *viewController = [mScrollViewPages objectAtIndex:i];
        if((NSNull *)viewController != [NSNull null])
		{
			if(i < currentPage-1 || i > currentPage+1)
			{
				[viewController removeFromSuperview];
				[mScrollViewPages replaceObjectAtIndex:i withObject:[NSNull null]];
				NSLog(@"YES un visible image is deleted ");
				
			}
		}
	}
	
}

- (void)dealloc
{
	[mScrollViewPages release];
	[mScrollView release];
    [super dealloc];
}
@end
