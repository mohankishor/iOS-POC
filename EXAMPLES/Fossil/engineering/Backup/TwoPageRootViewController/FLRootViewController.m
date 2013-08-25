//
//  FLRootViewController.m
//  Fossil
//
//  Created by Ganesh Nayak on 06/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLRootViewController.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "FLCommon.h"
#import "FLPopoverController.h"
#import "FLCatalogGridViewController.h"

@implementation FLRootViewController

@synthesize launchImage = mLaunchImage;
@synthesize screenIsTapped = mScreenIsTapped;
@synthesize homeScreenItems = mHomeScreenItems;
@synthesize catalogTableView = mCatalogTableView;
@synthesize flPopoverController = mFLPopoverController;
@synthesize topTransluscentView = mTopTransluscentView;
@synthesize bottomTransluscentView = mBottomTransluscentView;
@synthesize fossilToolbarLogoImage = mFossilToolbarLogoImage;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
	
	UIImage *fossilHolidayButtonImage = [UIImage imageNamed:@"fossilholiday_button_image.png"];
	CGRect logoImageButtonFrame;
	
	if (FL_IS_IPAD)
	{
		logoImageButtonFrame = CGRectMake(750, 5, 53, 33);
		mFossilToolbarLogoImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		mFossilToolbarLogoImage.frame = logoImageButtonFrame;
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 53, 33)];
		[imageView setImage:fossilHolidayButtonImage];
		[mFossilToolbarLogoImage addSubview:imageView];
		[imageView release];
		
		mFossilToolbarLogoImage.opaque = YES;
		[mFossilToolbarLogoImage addTarget:self action:@selector(showUtilityPopover) forControlEvents:UIControlEventTouchUpInside];
	}
	else
	{
		logoImageButtonFrame = CGRectMake(650, 5, 53, 33);
		mFossilToolbarLogoImage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		mFossilToolbarLogoImage.frame = logoImageButtonFrame;
		
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 53, 33)];
		[imageView setImage:fossilHolidayButtonImage];
		[mFossilToolbarLogoImage addSubview:imageView];
		[imageView release];
		
		mFossilToolbarLogoImage.opaque = YES;
	}

	[mTopTransluscentView addSubview:mFossilToolbarLogoImage];	
	mTopTransluscentView.barStyle = UIBarStyleBlackTranslucent;
	mTopTransluscentView.tintColor = [UIColor brownColor];
	
	mBottomTransluscentView.barStyle = UIBarStyleBlackTranslucent;
	mBottomTransluscentView.tintColor = [UIColor brownColor];
	mBottomTransluscentView.alpha = 0.7;
	
	mFLPopoverController = [[FLPopoverController alloc]init];
	self.navigationController.navigationBarHidden = YES;

	UIImage *summerFall = [UIImage imageNamed:@"fall2acc2010.png"];
	mLaunchImage.image = summerFall;
	mHomeScreenItems = [[NSMutableArray alloc]  initWithObjects:@"Browse All Catalog", @"Browse This Catalog",
						@"Store Locator", @"Try on a Watch", @"Current Promotion", @"Catalog & Newsletters", @"Shop Fossil.com", nil];
	mCatalogTableView.delegate = self;
	[mCatalogTableView reloadData];
	mScreenIsTapped = NO;
}

- (IBAction) animateTransluscentView:(id) sender
{
	if (!mScreenIsTapped)
	{
		self.topTransluscentView.hidden = NO;
		self.bottomTransluscentView.hidden = NO;
		
		CATransition *animation = [CATransition animation];
		[animation setType:kCATransitionMoveIn];
		[animation setSubtype:kCATransitionFromBottom];
		[animation setDuration:0.4];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[[self.topTransluscentView layer] addAnimation:animation forKey:kCATransition];

		animation = [CATransition animation];
		[animation setType:kCATransitionMoveIn];
		[animation setSubtype:kCATransitionFromTop];
		[animation setDuration:0.4];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[[self.bottomTransluscentView layer] addAnimation:animation forKey:kCATransition];
		
		 mScreenIsTapped = YES;
	}
	else
	{
		mScreenIsTapped = NO;		

		self.topTransluscentView.hidden = YES;
		self.bottomTransluscentView.hidden = YES;
		
		CATransition *animation = [CATransition animation];
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromTop];
		[animation setDuration:0.4];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[[self.topTransluscentView layer] addAnimation:animation forKey:kCATransition];
		
		animation = [CATransition animation];
		[animation setType:kCATransitionPush];
		[animation setSubtype:kCATransitionFromBottom];
		[animation setDuration:0.4];
		[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
		[[self.bottomTransluscentView layer] addAnimation:animation forKey:kCATransition];
	}
}

- (IBAction) gotoHome:(id) sender
{
	mScreenIsTapped = NO;		

	self.topTransluscentView.hidden = YES;
	self.bottomTransluscentView.hidden = YES;
	
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromTop];
	[animation setDuration:0.4];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.topTransluscentView layer] addAnimation:animation forKey:kCATransition];
	
	animation = [CATransition animation];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromBottom];
	[animation setDuration:0.4];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.bottomTransluscentView layer] addAnimation:animation forKey:kCATransition];
	
	UIDevice *thisDevice = [UIDevice currentDevice];
	
	if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		mLaunchImage.frame = CGRectMake(0, 0, IMAGE_VIEW_WIDTH_HOME_SCREEN_IPAD, TABLE_VIEW_HEIGHT_HOME_SCREEN_IPAD);
		mCatalogTableView.frame = CGRectMake(IMAGE_VIEW_WIDTH_HOME_SCREEN_IPAD+30, 0, TABLE_VIEW_WIDTH_HOME_SCREEN_IPAD-30, TABLE_VIEW_HEIGHT_HOME_SCREEN_IPAD);
	}
	else
	{
		mLaunchImage.frame = CGRectMake(0, 0, IMAGE_VIEW_WIDTH_HOME_SCREEN, TABLE_VIEW_HEIGHT_HOME_SCREEN);
		mCatalogTableView.frame = CGRectMake(IMAGE_VIEW_WIDTH_HOME_SCREEN, 0, TABLE_VIEW_WIDTH_HOME_SCREEN, TABLE_VIEW_HEIGHT_HOME_SCREEN);
	}
	
	animation = [CATransition animation];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromRight];
	[animation setDuration:0.4];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.launchImage layer] addAnimation:animation forKey:kCATransition];
	
	mCatalogTableView.hidden = NO;
	
	animation = [CATransition animation];
	[animation setType:kCATransitionPush];
	[animation setSubtype:kCATransitionFromRight];
	[animation setDuration:0.4];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[[self.catalogTableView layer] addAnimation:animation forKey:kCATransition];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft); 
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

// Customize the number of sections in the table view.
- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView
{
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section
{
    return [mHomeScreenItems count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
{
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	UIDevice *thisDevice = [UIDevice currentDevice];

	if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
	{
		cell.textLabel.font = [UIFont fontWithName:@"hevletica" size:34];
	}
	else
	{
 		cell.textLabel.font = [UIFont boldSystemFontOfSize:12];
	}

	if (indexPath.row == 0)
	{
		UIImage *fossil_logo = [UIImage imageNamed:@"fossil_logo_home_screen.png"];
		UIImageView *fossil_logo_imageView  = [[UIImageView alloc] initWithImage:fossil_logo];
		CGRect imageViewRect;
		
		if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			imageViewRect = CGRectMake(140, 50, fossil_logo.size.width , fossil_logo.size.height);
		}
		else
		{
			imageViewRect = CGRectMake(50, 15, fossil_logo.size.width , fossil_logo.size.height);
		}

		fossil_logo_imageView.frame = imageViewRect;
		[cell.contentView addSubview:fossil_logo_imageView];
		[fossil_logo_imageView release];
	}
	else
	{
		cell.textLabel.text = [mHomeScreenItems objectAtIndex:indexPath.row];
	}

	cell.textLabel.textAlignment = UITextAlignmentRight;
	cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath
{
	float height;
	UIDevice *thisDevice = [UIDevice currentDevice];

	if (indexPath.row == 0)
	{
		if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			height = 120;
		}
		else
		{
			height = 80;
		}
	}
	else
	{
		if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
		{
			height = 40;
		}
		else
		{
			height = 30;
		}
	}
	return height;
}

#pragma mark -
#pragma mark Table view delegate

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
	if (indexPath.row == 0)
	{
		[tableView deselectRowAtIndexPath:indexPath animated:NO];
		FLCatalogGridViewController *grid=[[FLCatalogGridViewController alloc] init];
		[self.navigationController pushViewController:grid animated:YES];
	}
}

- (void) showUtilityPopover
{
	UIPopoverController *popoverController = [mFLPopoverController showUtilityPopover];
	
	if (![popoverController isPopoverVisible])
	{
		[popoverController presentPopoverFromRect:mFossilToolbarLogoImage.frame inView:self.view 
						 permittedArrowDirections:UIPopoverArrowDirectionUp
										 animated:YES];
	}
	else
	{
		[popoverController dismissPopoverAnimated:YES];
	}
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) dealloc
{
	self.homeScreenItems = nil;
	self.launchImage = nil;
	self.topTransluscentView = nil;
	self.bottomTransluscentView = nil;
	self.catalogTableView = nil;
	self.flPopoverController = nil;
	self.fossilToolbarLogoImage = nil;
	[super dealloc];
}

@end
