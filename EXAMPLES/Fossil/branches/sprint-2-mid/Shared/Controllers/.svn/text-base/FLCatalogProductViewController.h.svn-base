//
//  FLProductViewController.h
//  Fossil
//
//  Created by Shirish Gone on 16/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLCatalogProductTableDataSource;
@interface FLCatalogProductViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	UITableView		*mTableView;	
	NSInteger		 mPageNumber;
	NSMutableArray *mProductList;
	UITableViewCell *mCustomCell;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITableViewCell *customCell;

-(id)initWithPageNumber:(int)page;
-(void) populateProducts;

-(IBAction)facebookButtonClicked:(id) sender;
-(IBAction)twitterButtonClicked:(id) sender;
-(IBAction)buyNowClicked:(id) sender;
-(IBAction)emailClicked:(id) sender;
-(IBAction)tryOnWatchClicked:(id) sender;
-(IBAction) dismiss;

@end
