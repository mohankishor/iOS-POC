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
		 
@end
