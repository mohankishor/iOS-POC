//
//  FLProductViewController.m
//  Fossil
//
//  Created by Shirish Gone on 16/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLProductViewController.h"


@implementation FLProductViewController
@synthesize tableView = mTableView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor clearColor];
	
	if (mTableView)
	{
		[mTableView removeFromSuperview];
		self.tableView = nil;
	}
	
	mTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
	mTableView.delegate = self;
	mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	mTableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
	
	if(FL_IS_IPAD)
	{
		mTableView.rowHeight = FL_IPAD_CELL_ROW_HEIGHT;
	}
	else
	{
		mTableView.rowHeight = FL_IPHONE_CELL_ROW_HEIGHT;
	}
	
	[self.view addSubview:mTableView];
	
	if (mTableSource)
	{
		[mTableSource release];
	}
	mTableSource = [[FLProductTableDataSource alloc] init];
	mTableView.dataSource = mTableSource;
	
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.tableView = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end


#pragma mark -
#pragma mark Data source methods

@implementation FLProductTableDataSource

@synthesize customCell = mCustomCell;


- (NSInteger) tableView:(UITableView *) table numberOfRowsInSection:(NSInteger) section
{
	return 10;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath 
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FL_PRODUCT_VIEW_CELL_IDENTIFIER];
	
	if (!cell)
	{
		if (FL_IS_IPAD)
		{
			[[NSBundle mainBundle] loadNibNamed:@"FLProductPageCell_iPad" owner:self options:nil];
		} 
		else
		{
			[[NSBundle mainBundle] loadNibNamed:@"FLProductPageCell_iPhone" owner:self options:nil];
		}
		cell = mCustomCell;
		self.customCell = nil;
		cell.contentView.backgroundColor = [UIColor whiteColor];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	return cell;
}

-(IBAction)fbButtonClicked
{
	NSLog(@"fbButtonClicked");
}
-(IBAction)twButtonClicked
{
	NSLog(@"twButtonClicked");

}
-(IBAction)buyNowClicked
{
	NSLog(@"buyNowClicked");

}
-(IBAction)emailClicked
{
	NSLog(@"emailClicked");

}


@end
