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

    }
    return self;
}

-(void) awakeFromNib
{
	mFirstLayout=YES;
	mTotalWatches = [[FLDataManager sharedInstance] noOfWatches];
}

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
		CGRect viewFrame = view.frame;
		viewFrame.origin.x = (viewFrame.size.width * page);
		viewFrame.origin.y = 0;
		view.frame = viewFrame;
		[self.mScrollView addSubview:view];
		
	}
	
}
-(void) layoutSubviews
{
	if(mFirstLayout)
	{
		CGRect scrollViewRect = CGRectMake(0, 0, mPageSize.width, mPageSize.height);
		scrollViewRect.origin.x = ((self.frame.size.width - mPageSize.width) / 2);
		scrollViewRect.origin.y = ((self.frame.size.height - mPageSize.height) / 2);
		
		mScrollView = [[UIScrollView alloc] initWithFrame:scrollViewRect];
		mScrollView.clipsToBounds = NO; 
		mScrollView.pagingEnabled = YES;
		mScrollView.showsHorizontalScrollIndicator = NO;
		mScrollView.showsVerticalScrollIndicator = NO;
		mScrollView.delegate = self;
		[self addSubview:mScrollView];
		int pageCount = [mDelegate itemCount:self];
		mScrollViewPages = [[NSMutableArray alloc] initWithCapacity:pageCount];

		for(int i = 0; i < pageCount; i++)
		{
			[mScrollViewPages addObject:[NSNull null]];
		}

		mScrollView.contentSize = CGSizeMake(pageCount * mScrollView.frame.size.width, mScrollView.frame.size.height);
		[self loadPage:0];
		[self loadPage:1];
		mFirstLayout = NO;

	}
	
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	
	if (!CGRectContainsPoint(mScrollView.frame, point)) {
		return self.mScrollView;
	}

	return [super hitTest:point	withEvent:event];
}

- (int)currentPage
{
	CGFloat pageWidth = mScrollView.frame.size.width;
	int page = floor((mScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	if (page < 0)
	{
		return 0;
	}
	
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
	[self loadPage:page-1];
	[self loadPage:page];
	[self loadPage:page+1];
	[mDelegate updateImageCountWithImages:mTotalWatches forCurrentImage:page+1];
	int currentPage = page;
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
