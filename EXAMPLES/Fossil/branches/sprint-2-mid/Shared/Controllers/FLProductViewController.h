//
//  FLProductViewController.h
//  Fossil
//
//  Created by Shirish Gone on 16/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FLProductTableDataSource;
@interface FLProductViewController : UIViewController <UITableViewDelegate>
{

	UITableView		*mTableView;
	FLProductTableDataSource *mTableSource;
}

@property (nonatomic, retain)UITableView *tableView;
@end

@interface FLProductTableDataSource : NSObject<UITableViewDataSource>
{
	UITableViewCell *mCustomCell;
}

@property (nonatomic, retain) IBOutlet UITableViewCell *customCell;

-(IBAction)fbButtonClicked;
-(IBAction)twButtonClicked;
-(IBAction)buyNowClicked;
-(IBAction)emailClicked;

@end
