//
//  FLWatchListViewController.m
//  FLWatchListViewController
//
//  Created by Lokesh P on 17/09/10.
//  Copyright Sourcebits Technologies  2010. All rights reserved.
//

#import "FLWatchListViewController.h"
#import "FLDataManager.h"
#import "FLBaseViewController.h"
#import "FLImageView.h"
#import "FLCustomAlertView.h"
#import "FLProduct.h"
#import "FLCatalogGridViewController.h"
@implementation FLWatchListViewController

@synthesize mWatchListScrollView,mPreviousImage,mCurrentImage,mNextImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	//if (FL_IS_IPAD)
//	{
//		mPreviousImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 512, 480)];
//		mCurrentImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 512, 480)];
//		mNextImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 512, 480)];
//	}
//	else
//	{
		mPreviousImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 310, 300)];
		mCurrentImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 310, 300)];
		mNextImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 310, 300)];		
//	}
	
	mPreviousImage.userInteractionEnabled = YES;
	mCurrentImage.userInteractionEnabled = YES;
	mNextImage.userInteractionEnabled = YES;
	
	mPreviousImage.delegate = self;
	mCurrentImage.delegate = self;
	mNextImage.delegate = self;
	
	mPreviousImage.tag=1;
	mCurrentImage.tag=2;
	mNextImage.tag=3;
	
	[self updateImageCountWithImages:[[FLDataManager sharedInstance] noOfWatches] forCurrentImage:1];
	
	[mWatchListScrollView setBackgroundColor:[UIColor darkGrayColor]]; 
	//CGSize pageSize width and height
	//if (FL_IS_IPAD)
//	{
//		mWatchListScrollView.mPageSize = CGSizeMake(512, 480);
//	}
//	else
//	{
		mWatchListScrollView.mPageSize = CGSizeMake(310, 300);

//	}

	// Important to listen to the delegate methods.
	mWatchListScrollView.mDelegate = self;
	[self.view addSubview:mWatchListScrollView];
}
-(void) createNavigationLeftItem
{
	UIImage *navTopLeftImage;
	//if (FL_IS_IPAD)
//	{
//		navTopLeftImage = [UIImage imageNamed:@"button_catalog@2x.png"];
//
//	}
//	else 
//	{
		navTopLeftImage = [UIImage imageNamed:@"button_catalog.png"];
//	}
	
	CGRect rect;
	//if(FL_IS_IPAD)
//	{
//		rect = CGRectMake(0,0,81,32);
//	}
//	else
//	{
		rect = CGRectMake(0,0,48.5,20);
//	}

	UIButton *customView=[[UIButton alloc] initWithFrame:rect];
	[customView	setBackgroundImage:navTopLeftImage forState:UIControlStateNormal];
	[customView addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithCustomView:customView];
	self.navigationItem.leftBarButtonItem = logo;
	self.title = @"Fossil Summer Catalog";
	
	[customView release];
	[logo release];	
}
-(void) back
{
	[self.navigationController popViewControllerAnimated:YES];
}
-(void) toggleBars
{
	if (self.navigationController.toolbarHidden)
	{

			int currentPage = [mWatchListScrollView currentPage];
			
			currentPage += 1;
			
			FLProduct *product = [[FLDataManager sharedInstance] watchAtIndex:currentPage];	
			mCustomAlertView = [[FLCustomAlertView alloc] initWithText:product.productTitle watchPath:product.productImagePath watchUrl:product.productURL];
			mCustomAlertView.navDelegate = self.navigationController;
			mCustomAlertView.delegate = self;
			
			[self.view addSubview:mCustomAlertView.view];
			[mCustomAlertView performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:0.0];

	}
	else
	{
			[mCustomAlertView dismiss ];
	}
	[super toggleBars];
}

-(void) showBag
{
	//[self toggleBars];
	[super showBag];
}

-(void)showPrevious
{
	int currentPage = [mWatchListScrollView currentPage];
	NSLog(@"showPrevious currentPage %i",currentPage);

	int totalWatches = [[FLDataManager sharedInstance] noOfWatches];
	if (currentPage >= 1 && currentPage <= totalWatches)
	{
		if (mCustomAlertView)
		{
			[mCustomAlertView dismiss];
		}
		FLProduct *product = [[FLDataManager sharedInstance] watchAtIndex:currentPage];	
		mCustomAlertView = [[FLCustomAlertView alloc] initWithText:product.productTitle watchPath:product.productImagePath watchUrl:product.productURL];
		mCustomAlertView.navDelegate = self.navigationController;
		mCustomAlertView.delegate = self;
		
		[self.view addSubview:mCustomAlertView.view];
		[mCustomAlertView performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:0.0];
		
		[mWatchListScrollView showPreviousImage];
	}
}


-(void)showNext
{
	
	int currentPage = [mWatchListScrollView currentPage];
	NSLog(@"showNext currentPage %i",currentPage);
	int totalWatches = [[FLDataManager sharedInstance] noOfWatches];
	if (currentPage >= 0 && currentPage <= totalWatches-2)
	{
		if (mCustomAlertView)
		{
			[mCustomAlertView dismiss];
		}
		int currentWatchPage = currentPage + 2;		
		FLProduct *product = [[FLDataManager sharedInstance] watchAtIndex:currentWatchPage];	
		mCustomAlertView = [[FLCustomAlertView alloc] initWithText:product.productTitle watchPath:product.productImagePath watchUrl:product.productURL];
		mCustomAlertView.navDelegate = self.navigationController;
		mCustomAlertView.delegate = self;
		
		[self.view addSubview:mCustomAlertView.view];
		[mCustomAlertView performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:0.0];
		
		[mWatchListScrollView showNextImage];
	}
}

-(void) updateImageCountWithImages:(int)mTotalWatches forCurrentImage:(int)page
{
	UIBarButtonItem *prev=[self.toolbarItems objectAtIndex:TB_WATCH_PREV_INDEX];
	UIBarButtonItem *title=[self.toolbarItems objectAtIndex:TB_WATCH_LABEL_INDEX];
	UIBarButtonItem *next=[self.toolbarItems objectAtIndex:TB_WATCH_NEXT_INDEX];
	if(page==1) 
	{
	  prev.enabled = NO;
	}else
	{
		prev.enabled = YES;
	}
	
	if(page==mTotalWatches)
	{
		next.enabled = NO;
	}
	else
	{
		next.enabled = YES;
	}
	
	NSString *titleString = [[NSString alloc] initWithFormat:@"%d / %d",page,mTotalWatches];
	title.title = titleString;
	[titleString release];
}

-(void) createToolbarItems
{
	UIBarButtonItem *barButton;
	
	NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
	UIBarButtonItem *fixedBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedBarButton.width = 50;
	UIBarButtonItem *flexibleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	UIImage *image;
	
	//HOME BUTTON
	image = [UIImage imageNamed:@"toolbar-home.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showHome)];
	[buttonArray addObject:barButton];
	[barButton release];
	[buttonArray addObject:flexibleBarButton];
	
	//BACK BUTTON
	image = [UIImage imageNamed:@"toolbar_previous.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showPrevious)];
	[buttonArray addObject:barButton];
	[barButton release];
	[buttonArray addObject:fixedBarButton];
	
	//LABEL
	barButton = [[UIBarButtonItem alloc] initWithTitle:@"0 / 0" style:UIBarButtonItemStylePlain target:nil action:nil];
	[buttonArray addObject:barButton];
	[barButton release];
	[buttonArray addObject:fixedBarButton];
	
	//NEXT BUTTON
	image = [UIImage imageNamed:@"toolbar_next.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showNext)];
	[buttonArray addObject:barButton];
	[barButton release];
	[buttonArray addObject:flexibleBarButton];
	
	//BAG BUTTON
	image = [UIImage imageNamed:@"toolbar-shopBag.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showBag)];
	[mCustomAlertView dismiss];
	[buttonArray addObject:barButton];
	[barButton release];
	
	
	self.toolbarItems = buttonArray;
	
	[buttonArray release];
	[flexibleBarButton release];
	[fixedBarButton release];
	
}

- (void) handleMenuActions:(int) index
{
	switch (index)
	{
		case 0:
		case 30:
		{
			[self forceHideBars];
			[self.navigationController gotoCatalogWebViewControllerFromWatchList];
		}
			break;
			
		default:
			[super handleMenuActions:index];
			break;
			
	}
	[mPopoverController dismissPopoverIfVisible];
}


#pragma mark -
#pragma mark FLWatchListScrollViewDelegate methods
-(UIView*) viewForItemAtIndex:(FLWatchListScrollView*) scrollView index:(NSInteger) index
{	
	switch (index%3) 
	{
		case 0:
			[[FLDataManager sharedInstance] loadWatchImage:mPreviousImage withIndex:index];
			//mPreviousImage.contentMode =UIViewContentModeScaleAspectFit;			
			//done in data manager as the spin indicator should not be scaled
			return mPreviousImage;
			break;
			
		case 1:
			[[FLDataManager sharedInstance] loadWatchImage:mCurrentImage withIndex:index];
			//mCurrentImage.contentMode =UIViewContentModeScaleAspectFit;
			return mCurrentImage;
			break;
			
		case 2:
			[[FLDataManager sharedInstance] loadWatchImage:mNextImage withIndex:index];
			//mNextImage.contentMode =UIViewContentModeScaleAspectFit;	
			return mNextImage;
			break;
			
		default:
			break;
	}
	return nil;
}

-(NSInteger)itemCount:(FLWatchListScrollView*)scrollView;
{
	return  [[FLDataManager sharedInstance] noOfWatches];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
	[[FLDataManager  sharedInstance] clearCache];
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
	[super viewDidUnload];
}

- (void)dealloc 
{
	[mCustomAlertView release];
	[mShopAlertView release];
	[mWatchListScrollView release];
	mPreviousImage=nil;
	mCurrentImage=nil;
	mNextImage=nil;
    [super dealloc];
}

@end
