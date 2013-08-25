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


@implementation FLWatchListViewController

@synthesize mWatchListScrollView,mPreviousImage,mCurrentImage,mNextImage;

- (void)viewDidLoad
{
    [super viewDidLoad];

	mPreviousImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 310, 300)];
	mCurrentImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 310, 300)];
	mNextImage = [[FLImageView alloc] initWithFrame:CGRectMake(0.f, 0.0f, 310, 300)];

	mPreviousImage.userInteractionEnabled = YES;
	mCurrentImage.userInteractionEnabled = YES;
	mNextImage.userInteractionEnabled = YES;
	
	mPreviousImage.delegate = self;
	mCurrentImage.delegate = self;
	mNextImage.delegate = self;
	
	mPreviousImage.tag=1;
	mCurrentImage.tag=2;
	mNextImage.tag=3;
	
	[self createToolBarItemsWithImages:[[FLDataManager sharedInstance] noOfWatches] forCurrentImage:1];
	[mWatchListScrollView setBackgroundColor:[UIColor darkGrayColor]]; 
	//CGSize pageSize width and height
	mWatchListScrollView.mPageSize = CGSizeMake(310, 300);
	// Important to listen to the delegate methods.
	mWatchListScrollView.mDelegate = self;
	[self.view addSubview:mWatchListScrollView];
}

-(void)showPreviousWatchImage
{
	[mWatchListScrollView showPreviousImage];
}

-(void)showNextWatchImage
{
	[mWatchListScrollView showNextImage];
}

#pragma mark -
#pragma mark FLWatchListScrollViewDelegate methods
-(UIView*)viewForItemAtIndex:(FLWatchListScrollView*)scrollView index:(NSInteger)index
{	
	switch (index%3) 
	{
		case 0:
			[[FLDataManager sharedInstance] loadWatchImage:mPreviousImage withIndex:index];
			mPreviousImage.contentMode =UIViewContentModeScaleAspectFit;			
			return mPreviousImage;
			break;
			
		case 1:
			[[FLDataManager sharedInstance] loadWatchImage:mCurrentImage withIndex:index];
			mCurrentImage.contentMode =UIViewContentModeScaleAspectFit;
			return mCurrentImage;
			break;
			
		case 2:
			[[FLDataManager sharedInstance] loadWatchImage:mNextImage withIndex:index];
			mNextImage.contentMode =UIViewContentModeScaleAspectFit;	
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

- (void) showCustomWatchAlertView
{
	FLCustomAlertView *customAlertView = [[FLCustomAlertView alloc] initWithText:@"Allie White Chronograph"];
	[self.view addSubview:customAlertView.view];
	[customAlertView performSelector:@selector(initialDelayEnded) withObject:nil afterDelay:0.5];
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	[self didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
- (void)dealloc 
{
	[mWatchListScrollView release];
	mPreviousImage=nil;
	mCurrentImage=nil;
	mNextImage=nil;
    [super dealloc];
}

@end
