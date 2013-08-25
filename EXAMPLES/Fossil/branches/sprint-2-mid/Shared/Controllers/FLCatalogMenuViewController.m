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
#import "FLWatchListViewController.h"
#import "FLCatalogMenuDataSource.h"

@implementation FLCatalogMenuViewController

@synthesize coverImageView = mCoverImageView;
@synthesize logoImageView = mLogoImageView;
@synthesize tableView = mTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{

    }
    return self;
}


- (void) viewDidLoad 
{
    [super viewDidLoad];
	
	[self createToolbarItems:self];
	
	[[FLDataManager sharedInstance] loadCoverImage:self.coverImageView];
	
	
	FLCatalogMenuDataSource *dataSource = [[FLCatalogMenuDataSource alloc] init];
	
	dataSource.delegate = self;
	
	self.tableView.dataSource = dataSource;
	self.tableView.delegate = dataSource;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void) didReceiveMemoryWarning
{
	[[FLDataManager sharedInstance] clearCache];
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void) dealloc 
{
    [super dealloc];
}


@end

