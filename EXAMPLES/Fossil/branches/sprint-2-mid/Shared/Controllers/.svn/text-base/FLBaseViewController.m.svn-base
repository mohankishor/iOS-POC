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
#import "FLCatalogPageViewController.h"
#import "FLPopoverController.h"
#import "FLWatchListViewController.h"


@implementation FLBaseViewController

@synthesize barsHidden = mBarsHidden;
@synthesize navigationBar = mNavigationBar;
@synthesize toolBar = mToolBar;
@synthesize delegate = mDelegate;
@synthesize rightNavBarButtonItem = mRightNavButton;
@synthesize flPopoverController = mFLPopoverController;

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
		
		mFLPopoverController = [[FLPopoverController alloc] init];
		mFLPopoverController.delegate = self;
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

- (void) handleMenuActions:(int) index
{
	if(!FL_HAS_CAMERA && (index>=3))
	{
		index ++;//RANDMON num. required as "try on" method is dynamic.
	}
	switch (index)
	{
		case 0:
		case 30:
		{
			[self.navigationController gotoCatalogGridViewController];
			[self barsVisible:NO];
		}
			break;
		case 1:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"STUB"
															message:@"Fossil Videos"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
			
		case 2:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"STUB"
															message:@"Store Locator"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		
		case 3:
		{
			[self.navigationController gotoCatalogWatchListViewController];
			[self barsVisible:NO];
		}
			break;

		case  4:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"STUB"
															message:@"Visit Our Blog"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
			
			break;
		}
		case  5:
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"STUB"
															message:@"Shop Fossil.com"
														   delegate:nil
												  cancelButtonTitle:@"OK"
												  otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
			break;
		
				default:
			break;
	}
	[mFLPopoverController dismissPopoverIfVisible];
}

- (void) createToolbarItems:(id)aPage
{
	self.delegate = aPage;
	
	UIImage *navTopRightImage = [UIImage imageNamed:@"navBar-logo.png"];
	
	CGRect topRightImageRect;
	CGRect topLeftLabelRect;
	UIFont *topLeftLabelFont;
	
	UIImageView *imageView;
	
	
	if (FL_IS_IPAD)
	{
		topRightImageRect = CGRectMake(980,5,navTopRightImage.size.width,navTopRightImage.size.height);
		topLeftLabelRect = CGRectMake(10,8,400,30);
		topLeftLabelFont = [UIFont boldSystemFontOfSize:18];
		UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
		tempButton.frame = topRightImageRect;
		[tempButton setImage:navTopRightImage forState:UIControlStateNormal];
		[tempButton setShowsTouchWhenHighlighted:YES];// setHighlighted:NO];
		[tempButton addTarget:self action:@selector(showPopover) forControlEvents:UIControlEventTouchUpInside];
		mRightNavButton = tempButton;
		[mNavigationBar addSubview:tempButton];
	}	
	else
	{
		topRightImageRect = CGRectMake(430, 5, navTopRightImage.size.width,navTopRightImage.size.height);
		topLeftLabelRect = CGRectMake(20,8,400,30);
		topLeftLabelFont = [UIFont boldSystemFontOfSize:22];
		imageView = [[UIImageView alloc] initWithFrame:topRightImageRect];
		imageView.backgroundColor = [UIColor clearColor];
		imageView.image = navTopRightImage;
		[mNavigationBar addSubview:imageView];
		[imageView release];
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

	
	if (![self.delegate isKindOfClass:[FLWatchListViewController class]])
	{

		UIImage *image;
		UIBarButtonItem *barButton;

		NSMutableArray *buttonArray = [[NSMutableArray alloc] init];

		
		UIBarButtonItem *fixedBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		
		fixedBarButton.width = 10;
		
		UIBarButtonItem *flexibleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

		NSMutableArray *imageArray;
		
		imageArray = [[NSMutableArray alloc] initWithObjects:@"toolbar_previous",
						  @"toolbar-home", @"toolbar-gridView", @"toolbar-shopBag",
						  @"toolbar-pageInfo", @"toolbar_next", nil];

		[buttonArray addObject:flexibleBarButton];
		
		image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[imageArray objectAtIndex:0] ofType:@"png"]];
		barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleToolBarAction:)];
		barButton.tag = 1;
		[image release];
				 
		[buttonArray addObject:barButton];
		[buttonArray addObject:flexibleBarButton];
		
		
		for (int i = 1; i < [imageArray count] - 1; i++)
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
	
		if ([self.delegate isKindOfClass:[FLCatalogMenuViewController class]])
		{
			//UIBarButtonItem *buttonToBeDisabled = (UIBarButtonItem *)[mToolBar viewWithTag:1]; // TODO
			//[buttonToBeDisabled setEnabled:NO];
			//[[mToolBar viewWithTag:1] ];
			[[[mToolBar subviews] objectAtIndex:0] setEnabled:NO];

			[[[mToolBar subviews] objectAtIndex:1] setEnabled:NO];
			//NSLog(@"buttonToBeDisabled.tag:%d",buttonToBeDisabled.tag);
			//NSLog(@"mToolBar subviews:%@ tag:%d buttonArray:%@", [mToolBar subviews], [[[mToolBar subviews] objectAtIndex:1] tag], buttonArray);
		}
		else if ([self.delegate isKindOfClass:[FLCatalogGridViewController class]])
		{
			[[[mToolBar subviews] objectAtIndex:2] setEnabled:NO];
		}
		[buttonArray release];
		[flexibleBarButton release];
		[fixedBarButton release];
		[imageArray release];
	}
//	UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 50.0, 30.0)];
//	[button setTitle:@"Back" forState:UIControlStateNormal];
//	[button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//	[button release];
//	mNavigationBar.topItem.leftBarButtonItem = backButton;
//	[backButton release];

}

- (void) createToolBarItemsWithImages:(int) totalImages forCurrentImage:(int) currentImageCount
{
	CGRect topRightImageRect;
	CGRect topLeftLabelRect;
	UIFont *topLeftLabelFont;
	
	UIImage *navTopRightImage = [UIImage imageNamed:@"navBar-logo.png"];
	UIImageView *imageView;

	topRightImageRect = CGRectMake(430, 5, navTopRightImage.size.width,navTopRightImage.size.height);
	topLeftLabelRect = CGRectMake(80,8,400,30);
	topLeftLabelFont = [UIFont boldSystemFontOfSize:22];
	imageView = [[UIImageView alloc] initWithFrame:topRightImageRect];
	imageView.backgroundColor = [UIColor clearColor];
	imageView.image = navTopRightImage;
	[mNavigationBar addSubview:imageView];
	[imageView release];
	
	
	UILabel *label = [[UILabel alloc] initWithFrame:topLeftLabelRect];
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.text = @"Watch List";
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = topLeftLabelFont;
	label.textAlignment = UITextAlignmentLeft;
	[mNavigationBar addSubview:label];
	[label release];
	
	UIButton *button = [UIButton  buttonWithType:UIButtonTypeCustom];
	button.frame =CGRectMake(mNavigationBar.bounds.origin.x-5, mNavigationBar.bounds.origin.y+10,80,30);
	//[button set
	[button setImage:[UIImage imageNamed:@"toolbar_previous"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	[mNavigationBar addSubview:button];
	
	
	UIImage *image;
	UIBarButtonItem *barButton, *flexibleBarButton, *fixedBarButton;
	NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
	
	fixedBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedBarButton.width = 110;
	[buttonArray addObject:fixedBarButton];
	[fixedBarButton release];
	
	image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toolbar_previous" ofType:@"png"]];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleToolBarAction:)];
	barButton.tag = 1;
	[image release];
	[buttonArray addObject:barButton];
	[barButton release];

	flexibleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[buttonArray addObject:flexibleBarButton];
	[flexibleBarButton release];
	
	mCountbutton = [[UIBarButtonItem alloc] init];
	NSString *countString = [[NSString alloc] initWithFormat:@"%d/%d",currentImageCount,totalImages];
	mCountbutton.title = countString;
	[countString release];
	[buttonArray addObject:mCountbutton];
	[mCountbutton release];
	
	flexibleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[buttonArray addObject:flexibleBarButton];
	[flexibleBarButton release];
	
	image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"toolbar_next" ofType:@"png"]];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(handleToolBarAction:)];
	barButton.tag = 2;
	[image release];
	[buttonArray addObject:barButton];
	[barButton release];

	fixedBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedBarButton.width = 110;
	[buttonArray addObject:fixedBarButton];
	[fixedBarButton release];
	
	[mToolBar setItems:buttonArray];
	[buttonArray release];
}

- (void) updateImageCountWithImages:(int) totalImages forCurrentImage:(int) currentImageCount
{
	NSString *countString = [[NSString alloc] initWithFormat:@"%d/%d",currentImageCount,totalImages];
	mCountbutton.title = countString;
	[countString release];	
}


- (void) back
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) showPopover
{
	UIPopoverController *popoverController = [mFLPopoverController showUtilityPopover];

	if (![popoverController isPopoverVisible])
	{
		[popoverController presentPopoverFromRect:mRightNavButton.frame
										   inView:self.view
						 permittedArrowDirections:UIPopoverArrowDirectionUp
												   animated:YES];
	}

}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *) event
{
	NSLog(@"touches Ended..");

	[NSObject cancelPreviousPerformRequestsWithTarget:self 
											 selector:@selector(longTap) object:nil];
}

-(void) longTap 
{
	if([timer isValid])
		[timer invalidate];
	
	NSLog(@"handle long tap..");
	
	//[self playMovie];
}

- (void) touchesCancelled:(NSSet *) touches withEvent:(UIEvent *) event
{
	
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
	NSSet *allTouches = [event allTouches];
	
	switch ([allTouches count])
	{
		case 1:
		{ //Single touch
			//Get the first touch.
			UITouch *touch = [[allTouches allObjects] objectAtIndex:0];

			switch ([touch tapCount])
			{
				case 1:
				{
					if ([mDelegate respondsToSelector:@selector(toggleBars)]) 
					{						
						//Start a timer for 2 seconds.
						timer = [NSTimer scheduledTimerWithTimeInterval:FL_IMAGE_SINGLE_TAP_DELAY
																 target:self 
															   selector:@selector(toggleBars)
															   userInfo:nil
																repeats:NO];
						[timer retain];
					}
					
					[self performSelector:@selector(longTap) withObject:nil afterDelay:FL_IMAGE_LONG_PRESS_DELAY];
				}
			break;

				case 2:
				{
					NSLog(@"Double Tap :%d",[touch tapCount]);
					if([timer isValid])
					{
						[timer invalidate];
					}

					//Double tap.
				}
					break;
		    }
		}
			break;
		case 2:
		{
			NSLog(@"Double TOUCH");

			//Double Touch
		} 
			break;
		default:
			break;
	}
}

- (void) touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
	if([timer isValid])
		[timer invalidate];
	
	NSSet *allTouches = [event allTouches];
	
	switch ([allTouches count])
	{
		case 1:
		{
			[NSObject cancelPreviousPerformRequestsWithTarget:self 
													 selector:@selector(longTap) object:nil];
		} break;
		case 2:
		{
			NSLog(@"Double Tap");
		} break;
	}
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

- (void) dealloc
{
	[mNavigationBar removeFromSuperview];
	[mToolBar removeFromSuperview];
	
	self.navigationBar = nil;
	self.toolBar = nil;
	self.flPopoverController = nil;
 
	[super dealloc];
}

- (void) handleToolBarAction:(id) sender
{	
	NSLog(@"handleToolBarAction");
	int tag = [sender tag];    
	NSLog(@"tag:%d",tag);
	NSLog(@"self %@",self);

	
	
	switch (tag)
	{
		case 1:
			if ([self.delegate isKindOfClass:[FLCatalogMenuViewController class]])
			{
				[self.navigationController popViewControllerAnimated:YES];
				[self barsVisible:NO];
			}
			if ([self.delegate isKindOfClass:[FLCatalogGridViewController class]])
			{
				[self.navigationController popViewControllerAnimated:YES];
				[self barsVisible:NO];
			}
			if ([self isKindOfClass:[FLWatchListViewController class]] )
			{
				[self showPreviousWatchImage];
			}
			
			break;
		case 2:
			if ([self.delegate isKindOfClass:[FLCatalogGridViewController class]])
			{
				//home
				[self.navigationController gotoCatalogMenuViewController];
				[self barsVisible:NO];
			}
			if ([self.delegate isKindOfClass:[FLCatalogPageViewController class]])
			{
				//home
				[self.navigationController gotoCatalogMenuViewController];
				[self barsVisible:NO];
			}
			if ([self isKindOfClass:[FLWatchListViewController class]] )
			{
				[self showNextWatchImage];
			}
			
			break;
		case 3:
			if ([self.delegate isKindOfClass:[FLCatalogMenuViewController class]])
			{
				[self.navigationController gotoCatalogGridViewController];
				[self barsVisible:NO];
			}
			if ([self.delegate isKindOfClass:[FLCatalogPageViewController class]])
			{
				[self.navigationController popViewControllerAnimated:YES];
				[self barsVisible:NO];
			}
			break;
		case 4:
			//<#statements#>
			break;
		case 5:
			//<#statements#>
			break;
		case 6:
			//<#statements#>
			break;
		default:
			break;
	}
}


@end
