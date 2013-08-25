//
//  ScrollMoreImagesViewController.m
//  Fossil
//
//  Created by Ganesh Nayak on 14/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ScrollMoreImagesViewController.h"

#define IPHONE_WIDTH 480.0
#define IPHONE_HEIGHT 300.0
#define IPHONE_FIRST_VIEW 0.0
#define IPHONE_SECOND_VIEW 480.0
#define IPHONE_LAST_VIEW 960.0

#define IPAD_WIDTH 1024.0
#define IPAD_HEIGHT 748.0
#define IPAD_FIRST_VIEW 0.0
#define IPAD_SECOND_VIEW 1024.0
#define IPAD_LAST_VIEW 2048.0

@implementation ScrollMoreImagesViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void) loadView 
{
	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	mainView.backgroundColor = [UIColor blackColor];
	self.view = mainView;
	[mainView release];
	
	if (mImageList == nil)
	{
		mImageList = [[NSMutableArray alloc] init];
	}

	NSArray *imageList = [[NSArray alloc] initWithObjects:@"One", @"Two", @"Three", @"Four", @"Five", @"One", @"Seven", @"Two", @"Three", @"Four", nil];

	for (NSString *imageName in imageList)
	{
		UIImage *image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imageName ofType:@"gif"]];
		[mImageList addObject:image];
		[image release];
	}
		
	mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 480, 300)];
	mScrollView.backgroundColor=[UIColor redColor];
	
	[self.view addSubview:mScrollView];	
		
	mScrollView.pagingEnabled = YES;
  	mScrollView.delegate = self;
	mScrollView.scrollsToTop = NO;
	mScrollView.showsVerticalScrollIndicator = NO;
	mScrollView.showsHorizontalScrollIndicator = NO;

	[mScrollView setContentSize:CGSizeMake(1440, 280)];
}
	
-(void) setImageToView
{
	if(mPageNumber!=0 && mPageNumber<9)
	{
		UIImage *preImage = [mImageList objectAtIndex:mPageNumber-2];
		UIImageView *setImage =[[UIImageView alloc] initWithImage:preImage];
		CGRect rect = setImage.frame;
		rect.size.height = 300;
		rect.size.width = 480;
		setImage.frame = rect;
		[mScrollView addSubview:setImage];
		[setImage release];
		
		UIImage *curImage = [mImageList objectAtIndex:mPageNumber-1];
		UIImageView *setImage1 =[[UIImageView alloc] initWithImage:curImage];
		CGRect rect1 = setImage1.frame;
		rect1.size.height = 300;
		rect1.size.width = 480;
		rect1.origin.x =480;
		setImage1.frame = rect1;
		[mScrollView addSubview:setImage1];
		[setImage1 release];
		
		UIImage *nextImage = [mImageList objectAtIndex:mPageNumber];
		UIImageView *setImage2 =[[UIImageView alloc] initWithImage:nextImage];
		CGRect rect2 = setImage2.frame;
		rect2.size.height = 300;
		rect2.size.width = 480;
		rect2.origin.x =960;
		setImage2.frame = rect2;
		[mScrollView addSubview:setImage2];
		[setImage2 release];
	}

}


#pragma mark scrollView delegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	CGPoint  value = [mScrollView contentOffset];

	if (value.x ==960 && mPageNumber < 8) 
	{
		CGPoint size;
		size.x=480;
		size.y=0;
		
		[mScrollView setContentOffset:size animated:NO];
		mPageNumber++;
		[self setImageToView];

	}
	else if(value.x == 0 && mPageNumber >2)
	{
		CGPoint size;
		size.x=480;
		size.y=0;
		[mScrollView setContentOffset:size animated:NO];
		mPageNumber--;
		[self setImageToView];
	}else if (value.x==480 && mPageNumber==1) {
		mPageNumber++;
	}

}
 //Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	
    [super viewDidLoad];
	mPageNumber=1;


	UIImage *setImage = [mImageList objectAtIndex:0];
	UIImageView *setImageView =[[UIImageView alloc] initWithImage:setImage];
	CGRect rect = setImageView.frame;
	rect.size.height = 300;
	rect.size.width = 480;
	setImageView.frame = rect;
	[mScrollView addSubview:setImageView];
	[setImageView release];
	
	UIImage *setImage1 = [mImageList objectAtIndex:1];
	UIImageView *setImageView1 =[[UIImageView alloc] initWithImage:setImage1];
	CGRect rect1 = setImageView1.frame;
	rect1.size.height = 300;
	rect1.size.width = 480;
	rect1.origin.x=480;
	setImageView1.frame = rect1;
	[mScrollView addSubview:setImageView1];
	[setImageView1 release];
	
	UIImage *setImage2 = [mImageList objectAtIndex:2];
	UIImageView *setImageView2 =[[UIImageView alloc] initWithImage:setImage2];
	CGRect rect2 = setImageView2.frame;
	rect2.size.height = 300;
	rect2.size.width = 480;	
	rect2.origin.x=960;
	setImageView2.frame = rect2;
	[mScrollView addSubview:setImageView2];
	[setImageView2 release];	
	
	
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void) dealloc
{
    [super dealloc];
	[mImageList release];
	[mScrollView release];
}

@end
