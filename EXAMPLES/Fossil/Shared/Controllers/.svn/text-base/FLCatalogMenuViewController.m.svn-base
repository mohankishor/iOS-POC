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
#import "FLMovieViewController.h"

@implementation FLCatalogMenuViewController

@synthesize coverImageView = mCoverImageView;
@synthesize logoImageView = mLogoImageView;
@synthesize tableView = mTableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
	{
		
	}
	
	mAppDelegate = [[UIApplication sharedApplication] delegate];
	
	mSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
	mSwipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:mSwipeRecognizer];
	[mSwipeRecognizer release];
	mTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleBars)];
	self.coverImageView.userInteractionEnabled = YES;
	[self.coverImageView addGestureRecognizer:mTapRecognizer];
	[mTapRecognizer release];
	return self;
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer*)sender
{
	[self.navigationController gotoCatalogPageFromMenu];
}
- (IBAction)playVideo:(id)sender
{
	FLMovieViewController *movie = [[FLMovieViewController alloc] initWithNibName:@"FLMovieViewController" bundle:nil];
	[self.navigationController pushViewController:movie animated:NO];
	[movie release];
}

- (void) viewDidLoad 
{
    [super viewDidLoad];
	
	[[FLDataManager sharedInstance] loadCoverImage:self.coverImageView];
	
	
	FLCatalogMenuDataSource *dataSource = [[FLCatalogMenuDataSource alloc] init];
	
	dataSource.delegate = self;
	
	self.tableView.dataSource = dataSource;
	self.tableView.delegate = dataSource;
	
}
-(void) createToolbarItems
{
	[super createToolbarItems];
	UIBarButtonItem *home=[self.toolbarItems objectAtIndex:TB_HOME_INDEX];
	home.enabled = NO;
	
	UIBarButtonItem *left=[self.toolbarItems objectAtIndex:TB_PREV_INDEX];
	left.enabled = NO;
	
	//UIBarButtonItem *grid=[self.toolbarItems objectAtIndex:TB_GRID_INDEX];
//	grid.enabled = YES;
	
	UIBarButtonItem *next=[self.toolbarItems objectAtIndex:TB_NEXT_INDEX];
	next.enabled = NO;
	
	//UIBarButtonItem *bag=[self.toolbarItems objectAtIndex:TB_BAG_INDEX];
//	bag.enabled = NO;
	
}


-(void) showGrid
{
	[self.navigationController gotoCatalogGridViewController];
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
	self.logoImageView=nil;
	self.coverImageView=nil;
	self.tableView=nil;
}


- (void) dealloc 
{
	self.logoImageView=nil;
	self.coverImageView=nil;
	self.tableView=nil;
	//[mSwipeRecognizer release];
//	[mTapRecognizer release];
    [super dealloc];
}


@end

