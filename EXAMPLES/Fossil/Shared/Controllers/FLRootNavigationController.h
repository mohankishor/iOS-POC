//
//  FLRootNavigationController.h
//  Fossil
//
//  Created by Ganesh Nayak on 06/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLProgressIndicator.h"

@interface FLRootNavigationController : UINavigationController
{
	
}

@end

@interface UINavigationController (RootNavigation)

	FLProgressIndicator *mProgressIndicator;

- (void) gotoCatalogMenuViewController;

- (void) gotoCatalogGridViewController;

- (void) gotoGridFromTryOnWatch;

- (void) gotoCatalogPageViewControllerWithPage:(int) page;

-(void) gotoCatalogProductViewControllerWithPage:(int) page;

-(void) catalogPageViewControllerDismissed;

-(void) catalogPageViewControllerDismissed;

-(void) gotoCatalogWatchListViewController;

-(void) gotoCatalogWatchListViewFromWebView;

-(void) gotoCatalogProductViewControllerWithGrid;

-(void) gotoCatalogPageFromMenu;

-(void) gotoCatalogWebViewControllerFromWatchList;

-(void) gotoCatalogBag;

-(void) gotoWatchCatalogViewController;

@end