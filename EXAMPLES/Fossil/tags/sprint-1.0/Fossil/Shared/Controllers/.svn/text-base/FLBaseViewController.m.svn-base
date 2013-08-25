    //
//  FLBaseViewController.m
//  Fossil
//
//  Created by Ganesh Nayak on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLBaseViewController.h"
#import "FLRootNavigationController.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "FLCatalogGridViewController.h"
#import "FLCatalogMenuViewController.h"

@implementation FLBaseViewController

@synthesize barsHidden = mBarsHidden;
@synthesize navigationBar = mNavigationBar;
@synthesize toolBar = mToolBar;
@synthesize delegate = mDelegate;


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;
	self.navigationController.toolbar.hidden = YES;
	
	CGRect navBarRect;
	CGRect toolBarRect;
	
	if (FL_IS_IPAD)
	{
		navBarRect = CGRectMake(0, 0, 1024, 50);
		toolBarRect = CGRectMake(0, 718, 1024, 50);
	}
	else
	{
		navBarRect = CGRectMake(0, 0, 480, 50);
		toolBarRect = CGRectMake(0, 270, 480, 50);
	}
	
	
	mNavigationBar = [[UINavigationBar alloc] initWithFrame:navBarRect];
	mToolBar = [[UIToolbar alloc] initWithFrame:toolBarRect];
	
	
	mNavigationBar.tintColor = [UIColor colorWithRed:0.2 green:0.09 blue:0.0 alpha:1.0];
	mToolBar.tintColor = [UIColor colorWithRed:0.4 green:0.27 blue:0.16 alpha:1.0];
	mToolBar.alpha = 0.9;
	
	
	mNavigationBar.hidden = YES;
	mToolBar.hidden = YES;
	
	[self.navigationController.view addSubview:mNavigationBar];
	[self.navigationController.view addSubview:mToolBar];

	
	self.barsHidden = YES;
}

- (void) createToolbarItems:(id)aPage
{
	UIImage *navTopRightImage = [UIImage imageNamed:@"navBar-logo.png"];
	
	CGRect topRightImageRect;
	CGRect topLeftLabelRect;
	UIFont *topLeftLabelFont;
	
	if (FL_IS_IPAD)
	{
		topRightImageRect = CGRectMake(960,8,navTopRightImage.size.width,navTopRightImage.size.height);
		topLeftLabelRect = CGRectMake(10,8,400,30);
		topLeftLabelFont = [UIFont boldSystemFontOfSize:18];
	}	
	else
	{
		topRightImageRect = CGRectMake(430,5,navTopRightImage.size.width,navTopRightImage.size.height);
		topLeftLabelRect = CGRectMake(20,8,400,30);
		topLeftLabelFont = [UIFont boldSystemFontOfSize:22];
	}
	
	
	UILabel *label = [[UILabel alloc] initWithFrame:topLeftLabelRect];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.text = @"Fossil Summer Catalog";
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = topLeftLabelFont;
	label.textAlignment = UITextAlignmentLeft;
	[mNavigationBar addSubview:label];
	[label release];
	
	
	//add a right hand side navigation button to the navbar
//	UINavigationItem *navItem;
//	navItem = [UINavigationItem alloc];
//	UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
//								   target:self action:@selector(saveNext:) ];
//	navItem.rightBarButtonItem = tempButton;
//	[mNavigationBar pushNavigationItem:navItem animated:YES];
//	[mNavigationBar setDelegate:self];    
//	[navItem release];
//	[tempButton release];
	
	
	
	
	
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:topRightImageRect];
	imageView.backgroundColor = [UIColor clearColor];
	imageView.image = navTopRightImage;
	[mNavigationBar addSubview:imageView];
	[imageView release];
	
	
	
	self.delegate = aPage;
	
	UIImage *image;
	UIBarButtonItem *barButton;

	NSMutableArray *buttonArray = [[NSMutableArray alloc] init];

	
	UIBarButtonItem *fixedBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	
	fixedBarButton.width = 10;
	
	UIBarButtonItem *flexibleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

	NSMutableArray *imageArray;
	
	if ([aPage isKindOfClass:[FLCatalogGridViewController class]])
	{
		imageArray = [[NSMutableArray alloc] initWithObjects:@"toolbar_previous",
									  @"toolbar-home", @"toolbar-shopBag",
									  @"toolbar-pageInfo", @"toolbar_next", nil];
	}
    else if([aPage isKindOfClass:[FLCatalogMenuViewController class]])
    {
		imageArray = [[NSMutableArray alloc] initWithObjects:@"toolbar_previous",
									  @"toolbar-gridView", @"toolbar-shopBag",
									  @"toolbar-pageInfo", @"toolbar_next", nil];
	}
	
	
	[buttonArray addObject:flexibleBarButton];
	
	image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageArray objectAtIndex:0] ofType:@"png"]];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleToolBarAction:)];
	barButton.tag = 1;
	[image release];
			 
    [buttonArray addObject:barButton];
	[buttonArray addObject:flexibleBarButton];
	
	for (int i = 1; i <= [imageArray count] - 2; i++)
	{
		image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageArray objectAtIndex:i] ofType:@"png"]];
		barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleToolBarAction:)];
		barButton.tag = i+1;
		[image release];
		
		[buttonArray addObject:barButton];
		[buttonArray addObject:fixedBarButton];
		[barButton release];
	}
	
	[buttonArray addObject:flexibleBarButton];
	image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageArray objectAtIndex:[imageArray count]-1] ofType:@"png"]];

	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleToolBarAction:)];
	barButton.tag = [imageArray count];
	[image release];

    [buttonArray addObject:barButton];
    [buttonArray addObject:flexibleBarButton];

	[mToolBar setItems:buttonArray];
	
	[buttonArray release];
	[flexibleBarButton release];
	[fixedBarButton release];
	[imageArray release];
	
	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
	[button setTitle:@"Back" forState:UIControlStateNormal];
	[button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
	[button release];
	mNavigationBar.topItem.leftBarButtonItem = backButton;
	[backButton release];
}


- (void) back
{
	[self.navigationController popViewControllerAnimated:YES];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) toggleBars
{
	if (self.barsHidden)
	{
		[mNavigationBar setHidden:NO];
		[mToolBar setHidden:NO];

		CATransition *animation = [CATransition animation];
		//kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
		//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
		
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromBottom];
		
		[animation setDuration:0.4];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[[mNavigationBar layer] addAnimation:animation forKey:kCATransition];
		
		animation = [CATransition animation];
		//kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
		//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
		
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromTop];
		
		[animation setDuration:0.4];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[[mToolBar layer] addAnimation:animation forKey:kCATransition];
		self.barsHidden = NO;
	}
	else
	{
		[mNavigationBar setHidden:YES];
		[mToolBar setHidden:YES];
		

		CATransition *animation = [CATransition animation];
		//kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
		//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
		
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromTop];
		
		[animation setDuration:0.4];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[[mNavigationBar layer] addAnimation:animation forKey:kCATransition];
		
		animation = [CATransition animation];
		//kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade
		//kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
		
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromBottom];
		
		[animation setDuration:0.4];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		
		[[mToolBar layer] addAnimation:animation forKey:kCATransition];
		
		self.barsHidden = YES;
	}	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self performSelector:@selector(longTap) withObject:nil afterDelay:0.5];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self 
											 selector:@selector(longTap) object:nil];
	
	UITouch *touch = (UITouch*)[touches anyObject];
	
	if (touch.tapCount == 1) 
	{
		[self toggleBars];
	}
}

-(void) longTap 
{
	NSLog(@"handle long tap..");
	
	//[self playMovie];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self 
											 selector:@selector(longTap) object:nil];
}

- (void) barsVisible:(BOOL) aBool
{
	if (aBool)
	{
		self.barsHidden = YES;
	}
	else
	{
		self.barsHidden = NO;
	}

	[self toggleBars];
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[mNavigationBar removeFromSuperview];
	[mToolBar removeFromSuperview];
	
	self.navigationBar = nil;
	self.toolBar = nil;
 
	[super dealloc];
}


- (void) handleToolBarAction:(id) sender
{	
	int tag = [sender tag];
	
	
	if ([self.delegate isKindOfClass:[FLCatalogGridViewController class]] )
	{
		if(tag == 2)
		{
			//home
			[self.navigationController gotoCatalogMenuViewController];
		}
	}
	
	if ([self.delegate isKindOfClass:[FLCatalogMenuViewController class]] )
	{
		if(tag == 2)
		{
			[self.navigationController gotoCatalogGridViewController];
			[self barsVisible:NO];
		}
	}
}

@end
