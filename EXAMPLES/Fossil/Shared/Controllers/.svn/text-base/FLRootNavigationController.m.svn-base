//
//  FLRootNavigationController.m
//  Fossil
//
//  Created by Ganesh Nayak on 06/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLRootNavigationController.h"
#import "FLCatalogMenuViewController.h"
#import "FLCatalogGridViewController.h"
#import "FLCatalogPageViewController.h"
#import "FLCatalogProductViewController.h"
#import "FLWatchListViewController.h"
#import "FLCameraViewController.h"
#import "FLCatalogWebViewController.h"

@implementation FLRootNavigationController

-(void) viewDidLoad
{
	[super viewDidLoad];
	self.navigationBar.tintColor =  [UIColor colorWithRed:0.2 green:0.09 blue:0.0 alpha:1.0];
	self.navigationBar.barStyle = UIBarStyleBlackOpaque;
	self.navigationBar.translucent = NO;
	if(FL_IS_IPAD)
	{
		self.navigationBarHidden = NO;
	}
	else
	{
		self.navigationBarHidden = YES;
	}
	self.navigationController.delegate =self;
	self.toolbar.tintColor = [UIColor colorWithRed:0.4 green:0.27 blue:0.16 alpha:1.0];
	self.toolbar.translucent = YES;
}
@end

@implementation  UINavigationController (RootNavigation)

-(void) gotoCatalogMenuViewController
{
	[self popToRootViewControllerAnimated:YES];
	
	
}

-(void) gotoCatalogGridViewController
{
	NSLog(@"Called gotoCatalogGridViewController");
	[self popToRootViewControllerAnimated:NO];
	
	FLCatalogGridViewController *grid = [[FLCatalogGridViewController alloc] initWithNibName:@"FLCatalogGridViewController" bundle:nil];
	[self pushViewController:grid animated:YES];
	[grid release];
}
/*
//--------------------------------------------------------------------------------------
-(void) gotoWatchCatalogViewController
{
	[self popViewControllerAnimated:NO];
	FLWatchCatalogViewController *watchGrid =[[FLWatchCatalogViewController alloc]init] ;//]WithNibName:@"FLWatchCatalogViewController" bundle:nil];
	[self pushViewController:watchGrid animated:YES];
	[watchGrid release];
}
//--------------------------------------------------------------------------------------*/
-(void) gotoGridFromTryOnWatch
{
	[self popToRootViewControllerAnimated:NO];
	
	FLCatalogGridViewController *grid = [[FLCatalogGridViewController alloc] initWithNibName:@"FLCatalogGridViewController" bundle:nil];
	[self pushViewController:grid animated:YES];
	[grid release];
}


-(void) popToCatalogGridViewController
{
	[self popViewControllerAnimated:YES];
}
- (void) gotoCatalogPageViewControllerWithPage:(int) page
{
	//should only be called from grid view
	FLCatalogPageViewController *viewController= [[FLCatalogPageViewController alloc] initWithPageNumber:page];
	[self pushViewController:viewController animated:YES];
	[viewController release];
}

-(void) gotoCatalogPageFromMenu
{
	FLCatalogGridViewController *gridViewController=[[FLCatalogGridViewController alloc]init];
	[self pushViewController:gridViewController animated:NO];
	[gridViewController release];
	
	FLCatalogPageViewController *viewController= [[FLCatalogPageViewController alloc] initWithPageNumber:0];
	[self pushViewController:viewController animated:YES];
	[viewController release];
}
-(void) gotoCatalogProductViewControllerWithPage:(int) page
{
	FLCatalogProductViewController *viewController= [[FLCatalogProductViewController alloc] initWithPageNumber:page];
	viewController.delegate = self;
	viewController.modalPresentationStyle = UIModalPresentationPageSheet;
		
	[self presentModalViewController:viewController animated:YES];
	[viewController release];
	viewController=nil;
	
}

-(void) gotoCatalogProductViewControllerWithGrid
{
	FLCatalogProductViewController *gridController= [[FLCatalogProductViewController alloc] initWithProducts];
	gridController.delegate = self;
	gridController.modalPresentationStyle = UIModalPresentationPageSheet;
	
	[self presentModalViewController:gridController animated:YES];
	[gridController release];
}

-(void) catalogPageViewControllerDismissed
{
		//	self.modalPresentationStyle =
	NSLog(@"catalog page view controller dismissed");
}


-(void) gotoCatalogWatchListViewController
{
	[self popToRootViewControllerAnimated:NO];
	FLWatchListViewController *viewController= [[FLWatchListViewController alloc] init];
	[self pushViewController:viewController animated:YES];
	[viewController release];	
}

-(void) gotoCatalogWebViewControllerFromWatchList;
{
	[self popViewControllerAnimated:YES];
}

-(void) gotoCatalogWatchListViewFromWebView
{
	[self popViewControllerAnimated:YES];
}
-(void) gotoCatalogBag
{
	FL_IF_CONNECTED()
	{
		NSString *urlAddress;
		if (FL_IS_IPAD)
		{
			urlAddress = @"https://www.fossil.com/webapp/wcs/stores/servlet/OrderItemDisplay?langId=-1&storeId=12052&catalogId=10052";
		}
		else
		{
			urlAddress = @"https://m.fossil.com/mt/www.fossil.com/webapp/wcs/stores/servlet/OrderItemDisplay?langId=-1&storeId=12052&catalogId=10052";
		}
		
		//FLCatalogWebViewController *webViewController = [[FLCatalogWebViewController alloc] initWithUrl:urlAddress];
//		[self pushViewController:webViewController animated:YES];
//		[webViewController release];
		[[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlAddress]];

	}	
}
-(void) showTryOnWatch:(NSArray *)array
{
	NSLog(@"navigation controller %@",self.topViewController);
	mProgressIndicator = [[FLProgressIndicator alloc] initWithFrame:self.view.frame isWatchList:NO];
	[self.topViewController.view addSubview:mProgressIndicator];
	[mProgressIndicator start];
	NSString *productImagePath = [[NSString alloc] initWithString:[array objectAtIndex:0]];
	NSString *productTitle = [[NSString alloc] initWithString:[array objectAtIndex:1]];
	NSArray *productArray = [[NSArray alloc] initWithObjects:productImagePath,productTitle,nil];
	[self performSelector:@selector(tryItOn:) withObject:productArray afterDelay:0.1];
	[productImagePath release];
	[productTitle release];
	[productArray release];
}

-(void)tryItOn:(NSArray *)array
{
	NSString *prodImagePath = [array objectAtIndex:0];
	NSString *prodTitle = [array objectAtIndex:1];
	
	NSMutableString *newWatchUrl = [[NSMutableString alloc] init];
	[newWatchUrl appendString:prodImagePath];
	[newWatchUrl appendString:@"?clipPathE=Path%201&fmt=png-alpha"];
	NSLog(@"append %@",newWatchUrl);
	NSData *urlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:newWatchUrl]];
	[newWatchUrl release];
	
	if (urlData != nil)
	{
		FLCameraViewController *tryOnWatchListViewController = [[FLCameraViewController alloc] initWithData:urlData watchTitle:prodTitle];
		[urlData release];
		[self pushViewController:tryOnWatchListViewController animated:YES];
		[tryOnWatchListViewController release];
	}
	else
	{
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading the image" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}
	[mProgressIndicator stop];
	[mProgressIndicator removeFromSuperview];
}

-(void) showBuyNow:(NSArray *)array
{
	NSString *productUrl = [array objectAtIndex:0];
	NSString *urlAddress =  [productUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//	FLCatalogWebViewController *webViewController = [[FLCatalogWebViewController alloc] initWithUrl:productUrl];
//	[self pushViewController:webViewController animated:YES];
//	[webViewController release];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlAddress]];
}

- (void) dealloc
{
	[mProgressIndicator release];
	[super dealloc];
}

@end
