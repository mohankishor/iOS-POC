//
//  FLProductViewController.m
//  Fossil
//
//  Created by Shirish Gone on 16/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCatalogProductViewController.h"
#import "FLProduct.h"
#import "FLDataManager.h"
#import "FLRootNavigationController.h"

@implementation FLCatalogProductViewController
@synthesize tableView = mTableView;
@synthesize customCell = mCustomCell;

-(id)initWithPageNumber:(int)page
{
	if(FL_IS_IPAD)
	{
		self = [super initWithNibName:@"FLCatalogProductViewController_iPad" bundle:nil];
	}
	else 
	{
		self = [super initWithNibName:@"FLCatalogProductViewController_iPhone" bundle:nil];
	}

	if(self)
	{
		mPageNumber = page;
		mProductList = [[NSMutableArray alloc] init];
		[self populateProducts];
	}
	return self;
}

-(void) populateProducts
{
	for(int i=1;i<=[[FLDataManager sharedInstance] noOfProductsInPage:mPageNumber];i++) 
	{
		FLProduct *prod = [[FLDataManager sharedInstance] productInPage:mPageNumber withIndex:i];//autoreleased
		[mProductList addObject:prod];
	}
	for(int j=1;j<=[[FLDataManager sharedInstance] noOfProductsInPage:mPageNumber+1];j++)
	{
		FLProduct *prod = [[FLDataManager sharedInstance] productInPage:mPageNumber+1 withIndex:j];//autoreleased
		[mProductList addObject:prod];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning 
{
	[[FLDataManager sharedInstance] cancelAllProductLoads];
	[[FLDataManager sharedInstance] clearCache];
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
	[[FLDataManager sharedInstance] cancelAllProductLoads];
    [super viewDidUnload];
	self.tableView = nil;
}

- (void)dealloc 
{
	[mProductList release];
    [super dealloc];
}

- (NSInteger) tableView:(UITableView *) table numberOfRowsInSection:(NSInteger) section
{
	return [mProductList count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath 
{
	UITableViewCell *cell = nil;
	FLProduct *product = [mProductList objectAtIndex:indexPath.row];
	if(product.productIsWatch && !FL_IS_IPAD)
	{
		cell = [tableView dequeueReusableCellWithIdentifier:FL_PRODUCT_VIEW_CELL_IDENTIFIER_WATCH];	
	}
	else 
	{
		cell = [tableView dequeueReusableCellWithIdentifier:FL_PRODUCT_VIEW_CELL_IDENTIFIER];
	}

	
	
	if (!cell)
	{
		if (FL_IS_IPAD)
		{
			[[NSBundle mainBundle] loadNibNamed:@"FLProductPageCell_iPad" owner:self options:nil];
		} 
		else
		{
			if(product.productIsWatch && FL_HAS_CAMERA)
			{
				[[NSBundle mainBundle] loadNibNamed:@"FLProductWatchCell_iPhone" owner:self options:nil];
			}else 
			{
				[[NSBundle mainBundle] loadNibNamed:@"FLProductPageCell_iPhone" owner:self options:nil];
			}
		}
		
		
		cell = mCustomCell;
		self.customCell = nil;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	[[FLDataManager sharedInstance] loadProduct:product withCell:cell tableView:tableView indexPath:indexPath];
	
	return cell;
}

-(IBAction)facebookButtonClicked:(id) sender
{
	UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
	NSIndexPath *path = [mTableView indexPathForCell:cell] ;
	
	FLProduct *product = [mProductList objectAtIndex:path.row];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
													message:[NSString stringWithFormat:@"%@\n$%f",product.productTitle,[product.productPrice floatValue]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(IBAction)twitterButtonClicked:(id) sender
{
	UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
	NSIndexPath *path = [mTableView indexPathForCell:cell] ;
	
	FLProduct *product = [mProductList objectAtIndex:path.row];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
													message:[NSString stringWithFormat:@"%@\n$%f",product.productTitle,[product.productPrice floatValue]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
-(IBAction)buyNowClicked:(id) sender
{
	UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
	NSIndexPath *path = [mTableView indexPathForCell:cell] ;
	
	FLProduct *product = [mProductList objectAtIndex:path.row];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Buy Now"
													message:[NSString stringWithFormat:@"Buy url %@",product.productURL]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}
-(IBAction)emailClicked:(id) sender
{
	UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
	NSIndexPath *path = [mTableView indexPathForCell:cell] ;
	
	FLProduct *product = [mProductList objectAtIndex:path.row];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email"
													message:[NSString stringWithFormat:@"%@\n$%f",product.productTitle,[product.productPrice floatValue]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
-(IBAction)tryOnWatchClicked:(id) sender
{
	UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
	NSIndexPath *path = [mTableView indexPathForCell:cell] ;
	
	FLProduct *product = [mProductList objectAtIndex:path.row];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Try On Watch"
													message:[NSString stringWithFormat:@"watch image \n$%@",product.productImagePath]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(IBAction) dismiss
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
