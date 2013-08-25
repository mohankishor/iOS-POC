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
#import "FLCatalogWebViewController.h"
#import "FLCataLogVisitBlogWebView.h"
#import "FLDataManager.h"

@interface FLBaseViewController()
-(void) longTap;
@end

@implementation FLBaseViewController





-(void) viewDidLoad
{
	[super viewDidLoad];
	
	[self configureBars];
	
	[self createNavigationBarItems];
	
	[self createToolbarItems];
	
	

	self.navigationController.toolbarHidden = YES; //TODO:check if initial hiding is required
	
	if(FL_IS_IPAD)
	{
		self.navigationController.navigationBarHidden = NO;
	}
	else
	{
		self.navigationController.navigationBarHidden = YES;
	}
}
	
-(void) configureBars
{
}
-(void) createNavigationBarItems
{
	[self createNavigationLeftItem];
	[self createNavigationRightItem];
}

-(void) createNavigationRightItem
{	
	NSLog(@"added right");
	CGRect rect;
	if(FL_IS_IPAD)
	{
		UIImage *navTopRightImage = [UIImage imageNamed:@"navBar-logo-ipad.png"];
		rect = CGRectMake(0,0,64,34);
		UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeCustom];
		tempButton.clipsToBounds = YES;
		tempButton.frame = rect;
		tempButton.contentMode = UIViewContentModeScaleToFill;
		[tempButton setImage:navTopRightImage forState:UIControlStateNormal];
		[tempButton setShowsTouchWhenHighlighted:YES];// setHighlighted:NO];
		[tempButton addTarget:self action:@selector(showPopover) forControlEvents:UIControlEventTouchUpInside];
		UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:tempButton];
		self.navigationItem.rightBarButtonItem = barButton;
		
		mPopoverController = [[FLPopoverController alloc] init];
		mPopoverController.delegate = self;
		[barButton release];
	}
	else
	{
		UIImage *navTopRightImage = [UIImage imageNamed:@"navBar-logo.png"];
		rect = CGRectMake(0,0,40,21);
		UIImageView *customView=[[UIImageView alloc] initWithFrame:rect];
		customView.image = navTopRightImage;
		UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithCustomView:customView];
		self.navigationItem.rightBarButtonItem = logo;
		[customView release];
		[logo release];
	}
}

-(void) createNavigationLeftItem
{
	CGRect topLeftLabelRect;
	UIFont *topLeftLabelFont;
	
	if (FL_IS_IPAD)
	{
		topLeftLabelRect = CGRectMake(10,8,400,30);
		topLeftLabelFont = [UIFont boldSystemFontOfSize:18];
	}	
	else
	{
		topLeftLabelRect = CGRectMake(20,8,400,30);
		topLeftLabelFont = [UIFont boldSystemFontOfSize:22];
	}
	
	//UILabel *label = [[UILabel alloc] initWithFrame:topLeftLabelRect];
//	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//	label.text = @"Fossil Summer Catalog";
//	label.backgroundColor = [UIColor clearColor];
//	label.textColor = [UIColor whiteColor];
//	label.font = topLeftLabelFont;
//	label.textAlignment = UITextAlignmentLeft;
	
	//UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:label];
	//self.navigationItem.leftBarButtonItem = bar;
	//[bar release];
}

-(void) createToolbarItems
{
	UIBarButtonItem *barButton;
	
	NSMutableArray *buttonArray = [[NSMutableArray alloc] init];
	UIBarButtonItem *fixedBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	fixedBarButton.width = 50;
	UIBarButtonItem *flexibleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	
	//HOME BUTTON (previous tag 2)
	UIImage* image = [UIImage imageNamed:@"toolbar-home.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showHome)];
	[buttonArray addObject:barButton];
	[barButton release];
	[buttonArray addObject:flexibleBarButton];
	
	//BACK BUTTON (previous tag 1)
	image = [UIImage imageNamed:@"toolbar_previous.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showPrevious)];
	[buttonArray addObject:barButton];
	[barButton release];
	[buttonArray addObject:fixedBarButton];
	
	//GRID BUTTON (previous tag 
	image = [UIImage imageNamed:@"toolbar-gridView.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showGrid)];
	[buttonArray addObject:barButton];
	[barButton release];
	[buttonArray addObject:fixedBarButton];
	
	//INFO BUTTON (previous tag 5)
	image = [UIImage imageNamed:@"toolbar_next.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showNext)];
	[buttonArray addObject:barButton];
	[barButton release];
	[buttonArray addObject:flexibleBarButton];
	
	//FORWARD BUTTON (previous tag 6)
	image = [UIImage imageNamed:@"toolbar-shopBag.png"];
	barButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showBag)];
	[buttonArray addObject:barButton];
	[barButton release];
	
	self.toolbarItems = buttonArray;
	
	[buttonArray release];
	[flexibleBarButton release];
	[fixedBarButton release];
}

-(void) setButtonEnabled:(BOOL)enabled atIndex:(int) index
{
	UIBarButtonItem *prevButton = [self.toolbarItems objectAtIndex:index];
	[prevButton setEnabled:enabled];
}

- (void) handleMenuActions:(int) index
{
	if(FL_IS_IPAD && (index>=3))
	{
		index ++;//RANDMON num. required as "try on" method is dynamic.
	}
	switch (index)
	{
		case 0:
		case 30:
		{
			[self forceHideBars];
			NSLog(@"browse catalog");
			if ([self isKindOfClass:[FLCatalogGridViewController class]])
			{
				[[FLDataManager sharedInstance]switchDataBase:0];
				[self.navigationController gotoCatalogGridViewController];
			}
			else
			{
				NSLog(@"watch  catalog");
				[[FLDataManager sharedInstance]switchDataBase:0];
				[self.navigationController gotoCatalogGridViewController];
			}
		}
			break;
		case 1:
		{
			[self forceHideBars];
					
			if ([self isKindOfClass:[FLCatalogGridViewController class]])
			{
				[[FLDataManager sharedInstance]switchDataBase:1];
				[self.navigationController gotoCatalogGridViewController];
			}
			else
			{
				NSLog(@"watch  catalog");
				[[FLDataManager sharedInstance]switchDataBase:1];
				[self.navigationController gotoCatalogGridViewController];
				
			}
			
		}
			break;
		//--------------------------------------------------------------------------------------*/
		case 2:
		{
			FL_IF_CONNECTED()
			{
				NSString *urlAddress =@"http://m.youtube.com/results?&q=fossiltv+-terra";
				[self forceHideBars];
				//FLCatalogWebViewController *webViewController = [[FLCatalogWebViewController alloc] initWithUrl:urlAddress];
//				[self.navigationController pushViewController:webViewController animated:YES];
//				
//				[webViewController release];
				[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]];
				[urlAddress release];
				self.navigationController.navigationBarHidden = YES;
			}
		}
			break;
			
		case 3:
		{
			FL_IF_CONNECTED()
			{
				NSString *urlAddress;
				if(FL_IS_IPAD)
				{
					urlAddress=@"http://www.fossil.com/en_US/shop/fossil-store_locator.html";
				}
				else
				{
					urlAddress=@"http://mobile.usablenet.com/mt/www.fossil.com/webapp/wcs/stores/servlet/StoreLocatorResultsView?storeId=12052&langId=-1&catalogId=10052&loc=10013&x=14&y=14";
				}

				
				[self forceHideBars];
				//FLCatalogWebViewController *webViewController = [[FLCatalogWebViewController alloc] initWithUrl:urlAddress];
//				[self.navigationController pushViewController:webViewController animated:YES];
//				
//				
//				[webViewController release];  
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlAddress]];
				[urlAddress release];
				self.navigationController.navigationBarHidden = YES;
			}
		}
			break;
			
		case 4:
		{
			FL_IF_CONNECTED()
			{
				NSString *urlAddress;
				if (FL_IS_IPAD)
				{
					[self forceHideBars];

					urlAddress=@"http://www.fossil.com/en_US/shop/fossil-store_locator.html";
					[[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlAddress]];
					[urlAddress release];
					self.navigationController.navigationBarHidden = YES;
				}
				else
				{
					[self forceHideBars];
					if (![self isKindOfClass:[FLWatchListViewController class]])
					{
						[self.navigationController gotoCatalogWatchListViewController];
					}
					
				}

				
			}
		}
			break;
			
		case  5:
		{
			FL_IF_CONNECTED() 
			{
				
				NSString *urlAddress = @"http://blog.fossil.com";
				[self forceHideBars];
				//FLCataLogVisitBlogWebView *visitWebViewController = [[FLCataLogVisitBlogWebView alloc] initWithUrl:urlAddress];
//				[self.navigationController pushViewController:visitWebViewController animated:YES];
//				[visitWebViewController release];	
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlAddress]];
				self.navigationController.navigationBarHidden = YES;
			}
		}
			break;
		case  6:
		{
			FL_IF_CONNECTED()
			{
				NSString *urlAddress;
				if(! FL_IS_IPAD)
				{
					 urlAddress = @"http://m.fossil.com";
				}
				else
				{
					urlAddress = @"http://www.fossil.com";
				}
				[self forceHideBars];
				//FLCatalogWebViewController *webViewController = [[FLCatalogWebViewController alloc] initWithUrl:urlAddress];
//				[self.navigationController pushViewController:webViewController animated:YES];
//				[webViewController release];
				[[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlAddress]];
			}
		}
			break;
		
		default:
			//[self forceHideBars];
			break;
	}
	[mPopoverController dismissPopoverIfVisible];
}

-(void) toggleBars
{
	//[self configureBars];
	[self toggleNavigationBar];
	[self toggleToolbar];
}
-(void) toggleNavigationBar
{
	//[self forceHideBars];
}
-(void) toggleToolbar
{
	
	if(self.navigationController.toolbarHidden==YES)
	{
		[self.navigationController setToolbarHidden:NO animated:YES];
	}
	else
	{
		[self.navigationController setToolbarHidden:YES animated:YES];
	}

	
}

-(void) forceHideBars
{
	if(!FL_IS_IPAD)
	{
		[self.navigationController setNavigationBarHidden:YES animated:YES];
		
	}
	else
	{
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		
	}
	//[self.navigationController setToolbarHidden:YES animated:YES];
}

- (void) showPopover
{
	UIPopoverController *popoverController = [mPopoverController showUtilityPopover];

	if (![popoverController isPopoverVisible])
	{
		[popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
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
	if([mTimer isValid])
		[mTimer invalidate];
	
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
			NSLog(@"Single touch%d",[touch tapCount]);
			
			switch ([touch tapCount])
			{
				case 1:
				{
					if ([self respondsToSelector:@selector(toggleBars)]) 
					{						
						//Start a timer for 2 seconds.
						mTimer = [NSTimer scheduledTimerWithTimeInterval:FL_IMAGE_SINGLE_TAP_DELAY
																 target:self 
															   selector:@selector(toggleBars)
															   userInfo:nil
																repeats:NO];
	                   [mTimer retain];
					}
					
					[self performSelector:@selector(longTap) withObject:nil afterDelay:FL_IMAGE_LONG_PRESS_DELAY];
				}
					break;
					
				case 2:
				{
					NSLog(@"Double Tap :%d",[touch tapCount]);
					if([mTimer isValid])
					{
						[mTimer invalidate];
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
	if([mTimer isValid])
		[mTimer invalidate];
	
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


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
	[mPopoverController release];
	mPopoverController = nil;
}

- (void) dealloc
{
	[mTimer release];
	[mPopoverController release];
	[super dealloc];
}


-(void) showInfo{} //derived class need to override
-(void) showNext{}
-(void) showPrevious{}
-(void) showBag
{
	[self forceHideBars];
	[self.navigationController gotoCatalogBag];
}
-(void) showHome
{
	//[self forceHideBars];
	[self.navigationController gotoCatalogMenuViewController];
}
-(void) showGrid{}




@end
