    //
//  FLCatalogMenuDataSource.m
//  Fossil
//
//  Created by Ganesh Nayak on 24/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCatalogMenuDataSource.h"


@implementation FLCatalogMenuDataSource
@synthesize delegate = mDelegate;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)init
{
    if ((self = [super init]))
	{
        // Custom initialization
		mMenu = [[NSMutableArray alloc] initWithObjects:@"Browse Catalog", 
				 @"Fossil Videos", 
				 @"Sotre Locator", 
				 @"Visit Our Blog", 
				 @"Shop Fossil.com", 
				 nil];
		
		if(FL_HAS_CAMERA) 
		{
			[mMenu insertObject:@"Try on a Watch" atIndex:3];
		}
    }
    return self;
}


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

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[mDelegate handleMenuActions:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [mMenu count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FL_CATALOG_MENU_TABLE_CELL_IDENTIFIER];
	
	if(!cell) 
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:FL_CATALOG_MENU_TABLE_CELL_IDENTIFIER] autorelease];
	}
	
	cell.textLabel.text = [mMenu objectAtIndex:indexPath.row];
	
	//set cell properties
	cell.textLabel.textAlignment = UITextAlignmentRight;
	if(FL_IS_IPAD) 
	{
		cell.textLabel.font = [UIFont systemFontOfSize:FL_CATALOG_MENU_FONT_SIZE_IPAD];	
	} 
	else 
	{
		cell.textLabel.font = [UIFont systemFontOfSize:FL_CATALOG_MENU_FONT_SIZE_IPHONE];
	} 
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	return cell;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
	[mMenu release];
    [super dealloc];
}


@end
