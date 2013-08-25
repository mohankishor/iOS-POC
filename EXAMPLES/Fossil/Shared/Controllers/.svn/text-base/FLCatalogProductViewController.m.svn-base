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
#import  "NSData+Base64.h"
#import "FLCatalogWebViewController.h"

#define PREPARE_STRING @"<html><body><table border=0><tr><td><img width = \"72\" height = \"72\" src='data:image/png;base64,%@'><td>&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td><td>%@<br>$%d<br><a href=\"%@\"><INPUT TYPE=\"BUTTON\" VALUE=\"View Product\"></a></td></tr></body></html>"


@implementation FLCatalogProductViewController
@synthesize tableView = mTableView;
@synthesize customCell = mCustomCell;
@synthesize delegate = mProductDelegate;

- (id) initWithPageNumber:(int) page
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
		mFBloginmanager = nil;
	}
	return self;
}

-(id)initWithProducts
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
		
		mProductList = [[NSMutableArray alloc] init];
		[self populateAllProducts];
		
	}
	return self;
	
}

-(void) populateAllProducts
{
	NSLog(@"Populate all products%d",[[FLDataManager sharedInstance] noOfPages]);
	for(int i=FL_COVER_OFFSET;i<=[[FLDataManager sharedInstance] noOfPages];i++) 
	{
	   for(int j=1;j<=[[FLDataManager sharedInstance] noOfProductsInPage:i];j++)
		{
		    FLProduct *prod = [[FLDataManager sharedInstance] productInPage:i withIndex:j];//autoreleased
			
			if (prod!=nil)
			{
				[mProductList addObject:prod];
			}
		}
		
	}
}

- (void) populateProducts
{
	int totalPages = [[FLDataManager sharedInstance] noOfPages];
	NSLog(@"total pages %i",totalPages);
	
	if (mPageNumber == 0) 
	{
		for(int i=1;i<=[[FLDataManager sharedInstance] noOfProductsInPage:1];i++) 
		{
			FLProduct *prod = [[FLDataManager sharedInstance] productInPage:1 withIndex:i];//autoreleased
			
			if (prod!=nil)
			{
				[mProductList addObject:prod];
			}
		}
		for(int j=1;j<=[[FLDataManager sharedInstance] noOfProductsInPage:totalPages];j++)
		{			
			FLProduct *prod = [[FLDataManager sharedInstance] productInPage:totalPages withIndex:j];//autoreleased
			
			if (prod!=nil)
			{
				[mProductList addObject:prod];
			}
		}
	}
	else
	{
		for(int i=1;i<=[[FLDataManager sharedInstance] noOfProductsInPage:mPageNumber];i++) 
		{
			FLProduct *prod = [[FLDataManager sharedInstance] productInPage:mPageNumber withIndex:i];//autoreleased
			
			if (prod!=nil)
			{
				[mProductList addObject:prod];
			}
		}
		for(int j=1;j<=[[FLDataManager sharedInstance] noOfProductsInPage:mPageNumber+1];j++)
		{			
			FLProduct *prod = [[FLDataManager sharedInstance] productInPage:mPageNumber+1 withIndex:j];//autoreleased
			
			if (prod!=nil)
			{
				[mProductList addObject:prod];
			}
		}
	}
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void )didReceiveMemoryWarning 
{
	[[FLDataManager sharedInstance] cancelAllProductLoads];
	[[FLDataManager sharedInstance] clearCache];
    [super didReceiveMemoryWarning];
}

- (void )viewDidUnload 
{
	[[FLDataManager sharedInstance] cancelAllProductLoads];
    [super viewDidUnload];
	self.tableView = nil;
}

- (void)dealloc 
{
	[mProductList release];
	if(mFBloginmanager != nil)
	{
		[mFBloginmanager logout];
		[mFBloginmanager release];
		mFBloginmanager = nil;
	}
	[mProgressIndicator release];
	[mTwitterShareController release];
	//[picker release];
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

- (IBAction) facebookButtonClicked:(id) sender
{
	FL_IF_CONNECTED()
	{
		UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
		NSIndexPath *path = [mTableView indexPathForCell:cell] ;
	
		FLProduct *product = [mProductList objectAtIndex:path.row];
 
		if(mFBloginmanager != nil)
			[mFBloginmanager release];
	
		mFBloginmanager = [[FBLoginManager alloc]initWithProduct:product];
		[mFBloginmanager LoginAndPublish];
	}
}

- (IBAction) twitterButtonClicked:(id) sender
{
	FL_IF_CONNECTED()
	{		
		UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
	
		NSIndexPath *path = [mTableView indexPathForCell:cell];
	
		FLProduct *product = [mProductList objectAtIndex:path.row];
	
		if (mProgressIndicator)
		{
			[mProgressIndicator release];
		}
		mProgressIndicator = [[FLProgressIndicator alloc] initWithFrame:self.view.frame isWatchList:NO];
		[self.view addSubview:mProgressIndicator];
		[mProgressIndicator start];
	
		NSArray *productArray = [[NSArray alloc] initWithObjects:product,nil];
	
		[self performSelector:@selector(showTwitter:) withObject:productArray afterDelay:0.1];
	
		[productArray release];
	}
}

-(void)showTwitter:(NSArray *)array
{
	FLProduct *product = [array objectAtIndex:0];
	//Memory Leak
	mTwitterShareController = [[FLTwitterShareViewController alloc] initWithProduct:product];
	[mProgressIndicator stop];
	[mProgressIndicator removeFromSuperview];
}


- (IBAction) buyNowClicked:(id) sender
{
	FL_IF_CONNECTED()
	{		
		UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
		NSIndexPath *path = [mTableView indexPathForCell:cell] ;
	
		FLProduct *product = [mProductList objectAtIndex:path.row];
	
		NSArray *productArray = [[NSArray alloc] initWithObjects:product.productURL,nil];
		
		[self.delegate performSelector:@selector(showBuyNow:) withObject:productArray afterDelay:1.0];
	
		[productArray release];
	
		[self dismiss];
	}
}


- (IBAction) emailClicked:(id) sender
{
	//	// We must always check whether the current device is configured for sending emails
	FL_IF_CONNECTED()
	{		
		if([MFMailComposeViewController canSendMail])
		{
			UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
			NSIndexPath *path = [mTableView indexPathForCell:cell];		
			FLProduct *product = [mProductList objectAtIndex:path.row];	
		
			if (mProgressIndicator)
			{
				[mProgressIndicator release];
			}
			mProgressIndicator = [[FLProgressIndicator alloc] initWithFrame:self.view.frame isWatchList:NO];
			[self.view addSubview:mProgressIndicator];
			[mProgressIndicator start];
			NSArray *productArray = [[NSArray alloc] initWithObjects:product.productImagePath,product.productTitle,product.productPrice,product.productURL,nil];
			[self performSelector:@selector(showEmail:) withObject:productArray afterDelay:0.1];
			[productArray release];
		}
		else
		{
			UIAlertView *errorAlert=[[UIAlertView alloc]initWithTitle:@"Unable to connect" message:@"You need to do mail settings in the device you are using "delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[errorAlert show];
		}

	}
}

-(void)showEmail:(NSArray *)array
{
	NSString *productImagePath = [array objectAtIndex:0];
	NSString *productTitle = [array objectAtIndex:1];
	NSString *productPrice = [array objectAtIndex:2];
	NSString *productUrl = [array objectAtIndex:3];

	picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"FOSSIL"];	
	
	NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:productImagePath]];		
	UIImage *emailImage = [[UIImage alloc] initWithData:data];
	[data release];
	//Convert the image into data
	NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
	[emailImage release];
	
	//Create a base64 string representation of the data using NSData+Base64
	NSString *base64String = [imageData base64EncodedString];		
	// Fill out the email body text
	NSMutableString *emailBody = [[NSMutableString alloc] init];
	//[emailBody appendString:[NSString stringWithFormat:PREPARE_STRING,base64String,product.productTitle,[product.productPrice floatValue]]];	
	[emailBody appendString:[NSString stringWithFormat:PREPARE_STRING,base64String,productTitle,[productPrice intValue],productUrl]];	 
	
	[picker setMessageBody:emailBody isHTML:YES];		
	[self presentModalViewController:picker animated:YES];
	[picker release];
	picker=nil;
	[emailBody release];
	[mProgressIndicator stop];
	[mProgressIndicator removeFromSuperview];
	
}

-(IBAction) tryOnWatchClicked:(id) sender
{
	UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
	NSIndexPath *path = [mTableView indexPathForCell:cell];
	FLProduct *product = [mProductList objectAtIndex:path.row];
	NSArray *productArray = [[NSArray alloc] initWithObjects:product.productImagePath,product.productTitle,nil];
	[self.delegate performSelector:@selector(showTryOnWatch:) withObject:productArray afterDelay:0.5];
	[productArray release];
	[self dismiss];
	
}

#pragma mark -
#pragma mark Mail Composer Delegate
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void) mailComposeController:(MFMailComposeViewController*) controller didFinishWithResult:(MFMailComposeResult) result error:(NSError*) error 
{	
	[self dismissModalViewControllerAnimated:YES];
}

-(IBAction) dismiss
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
