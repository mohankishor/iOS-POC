//
//  FLPopoverController.m
//  Fossil
//
//  Created by Ganesh Nayak on 08/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLPopoverController.h"
#import "FLCatalogGridViewController.h"
#import "FLCatalogMenuDataSource.h"

@implementation FLPopoverController

@synthesize delegate = mDelegate;
@synthesize homeScreenItems = mHomeScreenItems;
@synthesize catalogTableView = mCatalogTableView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -

- (UIPopoverController *) showUtilityPopover
{
	
	if (mUtilityPopoverController)
	{
		[mUtilityPopoverController dismissPopoverAnimated:NO];
	}
	else
	{
		UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 300) style:UITableViewCellAccessoryNone];
		self.catalogTableView = tableView;
		[tableView release];
		
		
		FLCatalogMenuDataSource *dataSource = [[FLCatalogMenuDataSource alloc] init];
		
		dataSource.delegate = self.delegate;
		self.catalogTableView.dataSource = dataSource;
		self.catalogTableView.delegate = dataSource;
		
		
		NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:@"Browse All Catalog", @"Browse This Catalog",
								 @"Store Locator", @"Try on a Watch", @"Current Promotion", @"Catalog & Newsletters", @"Shop Fossil.com", nil];
		self.homeScreenItems = items;
		[items release];
		
		mCatalogTableView.scrollEnabled = NO;
		
		
		CGRect toolbarViewRect = CGRectMake(0, 0, 340, 44);
		CGRect titleRect = CGRectMake(10, 0, 340, 44);
		CGRect tableViewRect = CGRectMake(20, 45, 300, 355);
		CGRect contentRect = CGRectMake(0, 0, 340, 355);
		
		mCatalogTableView.frame = tableViewRect;
		
		UILabel *fossil_Catalog_Menu = [[UILabel alloc] initWithFrame:titleRect];
		fossil_Catalog_Menu.backgroundColor = [UIColor clearColor];
		fossil_Catalog_Menu.textColor = [UIColor whiteColor];
		fossil_Catalog_Menu.font = [UIFont boldSystemFontOfSize:18];	
		fossil_Catalog_Menu.text = @"Fossil Catalog Menu";
		
		UIToolbar *titleView = [[UIToolbar alloc] initWithFrame:toolbarViewRect];
		titleView.barStyle = UIBarStyleBlackTranslucent;
		titleView.tintColor = [UIColor colorWithRed:0.2 green:0.09 blue:0.0 alpha:1.0];
		[titleView addSubview:fossil_Catalog_Menu];
		[fossil_Catalog_Menu release];
		
		UIViewController *popoverContent = [[UIViewController alloc] init];
		popoverContent.view.backgroundColor = [UIColor whiteColor];
		[popoverContent.view addSubview:titleView];
		[titleView release];
		
		[popoverContent.view addSubview:mCatalogTableView];
		popoverContent.contentSizeForViewInPopover = contentRect.size;
		mUtilityPopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		[popoverContent release];
		
	}
	return mUtilityPopoverController;
}


- (void) dismissPopoverIfVisible
{
	if (mUtilityPopoverController)
	{
		[mUtilityPopoverController dismissPopoverAnimated:YES];
	}
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	self.homeScreenItems = nil;
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.catalogTableView = nil;
}

- (void) dealloc
{
	if (mUtilityPopoverController)
	{
		[mUtilityPopoverController dismissPopoverAnimated:NO];
		[mUtilityPopoverController release];
	}
	self.homeScreenItems = nil;
	self.catalogTableView = nil;

    [super dealloc];
}


@end
