    //
//  FLCatalogMenuViewController.m
//  Fossil
//
//  Created by Darshan on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCatalogMenuViewController.h"
#import "FLDataManager.h"
#import "FLRootNavigationController.h"

@implementation FLCatalogMenuViewController

@synthesize coverImageView = mCoverImageView;
@synthesize logoImageView = mLogoImageView;
@synthesize tableView = mTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		mMenu = [[NSMutableArray alloc] initWithObjects:@"Browse Catalog", 
				 @"Store Locator", 
				 @"Fossil Blog", 
				 @"Current Promotion", 
				 @"Fossil Video",
				 @"Shop Fossil.com", 
				 nil];
		
		if(!FL_IS_IPAD) 
		{
			[mMenu insertObject:@"Try on a Watch" atIndex:1];
		}
    }
    return self;
}


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self createToolbarItems:self];
	
	[[FLDataManager sharedInstance] loadCoverImage:self.coverImageView];
	
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft );
}


- (void)didReceiveMemoryWarning {
	[[FLDataManager sharedInstance] clearCache];
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void) dealloc 
{
	[mMenu release];

    [super dealloc];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	switch (indexPath.row)
	{
		case 0:
			//Browse Catalog
			[self barsVisible:NO];
			[self.navigationController gotoCatalogGridViewController];
			break;
			
		default:
			break;
	}
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

@end

