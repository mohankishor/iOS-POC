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

@implementation FLRootNavigationController

@end

@implementation  UINavigationController (RootNavigation)

-(void) gotoCatalogMenuViewController
{
	[self popToRootViewControllerAnimated:YES];
}

-(void) gotoCatalogGridViewController
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
-(void) gotoCatalogProductViewControllerWithPage:(int) page
{
	FLCatalogProductViewController *viewController= [[FLCatalogProductViewController alloc] initWithPageNumber:page];
	viewController.modalPresentationStyle = UIModalPresentationPageSheet;
		
	[self presentModalViewController:viewController animated:YES];
	[viewController release];
}

-(void) catalogPageViewControllerDismissed
{
		//	self.modalPresentationStyle =
	NSLog(@"catalog page view controller dismissed");
	
	
}
-(void) gotoCatalogWatchListViewController
{
	FLWatchListViewController *viewController= [[FLWatchListViewController alloc] init];
	[self pushViewController:viewController animated:YES];
	[viewController release];
	
}
@end
