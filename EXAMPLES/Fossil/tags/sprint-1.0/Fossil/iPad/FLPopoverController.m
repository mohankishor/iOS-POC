//
//  FLPopoverController.m
//  Fossil
//
//  Created by Ganesh Nayak on 08/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLPopoverController.h"

@implementation FLPopoverController

@synthesize homeScreenItems = mHomeScreenItems;
@synthesize catalogTableView = mCatalogTableView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
	
	UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 250, 300) style:UITableViewCellAccessoryNone];
	self.catalogTableView = tableView;
	[tableView release];
	mCatalogTableView.delegate = self;
	mCatalogTableView.dataSource = self;
	
	NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:@"Browse All Catalog", @"Browse This Catalog",
						@"Store Locator", @"Try on a Watch", @"Current Promotion", @"Catalog & Newsletters", @"Shop Fossil.com", nil];
	self.homeScreenItems = items;
	[items release];
}


#pragma mark -

- (UIPopoverController *) showUtilityPopover
{	
	mCatalogTableView.scrollEnabled = NO;
	
	if (mUtilityPopoverController)
	{
		[mUtilityPopoverController dismissPopoverAnimated:NO];
		[mUtilityPopoverController release];
	}
	
	CGRect toolbarViewRect = CGRectMake(0, 0, 350, 44);
	CGRect titleRect = CGRectMake(10, 0, 340, 44);
	CGRect tableViewRect = CGRectMake(0, 44, 350, 355);
	CGRect contentRect = CGRectMake(0, 0, 350, 355);

	mCatalogTableView.frame = tableViewRect;

	UILabel *fossil_Catalog_Menu = [[UILabel alloc] initWithFrame:titleRect];
	fossil_Catalog_Menu.backgroundColor = [UIColor clearColor];
	fossil_Catalog_Menu.textColor = [UIColor whiteColor];
	fossil_Catalog_Menu.font = [UIFont boldSystemFontOfSize:22];	
	fossil_Catalog_Menu.text = @"Fossil Catalog Menu";
	
	UIToolbar *titleView = [[UIToolbar alloc] initWithFrame:toolbarViewRect];
	titleView.barStyle = UIBarStyleBlackTranslucent;
	titleView.tintColor = [UIColor brownColor];
	[titleView addSubview:fossil_Catalog_Menu];
	[fossil_Catalog_Menu release];

	UIViewController *popoverContent = [[UIViewController alloc] init];
	popoverContent.view.backgroundColor = [UIColor brownColor];
	[popoverContent.view addSubview:titleView];
	[titleView release];

	[popoverContent.view addSubview:mCatalogTableView];
	popoverContent.contentSizeForViewInPopover = contentRect.size;
	mUtilityPopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
	[popoverContent release];
	
	return mUtilityPopoverController;	
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *) tableView
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
	cell.textLabel.font = [UIFont boldSystemFontOfSize:24];
	
	cell.textLabel.textAlignment = UITextAlignmentRight;
	cell.textLabel.text = [mHomeScreenItems objectAtIndex:indexPath.row];
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Overriden to allow any orientation.
    return YES;
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
