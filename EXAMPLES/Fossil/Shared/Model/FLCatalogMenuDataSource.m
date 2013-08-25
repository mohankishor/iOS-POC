    //
//  FLCatalogMenuDataSource.m
//  Fossil
//
//  Created by Ganesh ; on 24/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCatalogMenuDataSource.h"
#import "FLBaseViewController.h"

@implementation FLCatalogMenuDataSource
@synthesize delegate = mDelegate;

- (id) init
{
    if ((self = [super init]))
	{

        // Custom initialization		
		if(FL_IS_IPAD) 
		{
			mMenu = [[NSArray alloc] initWithObjects:@"Browse Holiday Catalog", 
					     @"Browse Watch Book",
			 			 @"Fossil Videos", 
			 			 @"Store Locator",
						 @"Visit Our Blog", 
						 @"Shop Fossil.com", 
						  nil];
		}
		else
		{
			mMenu = [[NSArray alloc] initWithObjects:@"Browse Holiday Catalog", 
					 @"Browse Watch Book",
					 @"Fossil Videos", 
					 @"Store Locator",
					 @"Try On Watch",
					 @"Visit Our Blog", 
					 @"Shop Fossil.com", 
					 nil];
		}

    }
    return self;
}

- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath
{
	UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
	cell.textLabel.highlighted = YES;
	[mDelegate handleMenuActions:indexPath.row];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
	cell.textLabel.highlighted = NO;
}
- (NSInteger) tableView:(UITableView *) table numberOfRowsInSection:(NSInteger) section
{
	return [mMenu count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath
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
	
	UIView *customView=[[UIView alloc]initWithFrame:cell.frame];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.selectedBackgroundView = customView;
	cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
	cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.77 green:0.38 blue:0.27 alpha:1.0];
	[customView release];
	return cell;
	
}

- (void) dealloc
{
	[mMenu release];
    [super dealloc];
}


@end
