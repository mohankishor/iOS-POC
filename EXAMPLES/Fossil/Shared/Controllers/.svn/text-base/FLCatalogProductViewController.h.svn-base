//
//  FLProductViewController.h
//  Fossil
//
//  Created by Shirish Gone on 16/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "FBLoginManager.h"
#import "FLProgressIndicator.h"
#import "FLTwitterShareViewController.h"

@class FLCatalogProductTableDataSource;

@interface FLCatalogProductViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>
{
	UITableView		 *mTableView;	
	NSInteger		 mPageNumber;
	NSMutableArray *mProductList;
	UITableViewCell *mCustomCell;
	id				   mDelegate;
	UIActivityIndicatorView  *mIndicator;
	FBLoginManager*    mFBloginmanager;
	FLTwitterShareViewController *mTwitterShareController;
	FLProgressIndicator *mProgressIndicator;
	MFMailComposeViewController *picker;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *customCell;
@property (nonatomic, assign) id delegate;

-(id)initWithPageNumber:(int)page;
-(id)initWithProducts;
-(void) populateAllProducts;

-(void) populateProducts;

- (IBAction) facebookButtonClicked:(id) sender;
- (IBAction) twitterButtonClicked:(id) sender;
- (IBAction) buyNowClicked:(id) sender;
- (IBAction) emailClicked:(id) sender;
- (IBAction) tryOnWatchClicked:(id) sender;
- (IBAction) dismiss;

@end
