//
//  SimpleTableViewController.h
//  SimpleTable
//
//  Created by Adeem on 17/05/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	IBOutlet UITableView *tblSimpleTable;
	NSMutableArray *arryData;
}

//- (IBAction)AddButtonAction:(id)sender;
//- (IBAction)DeleteButtonAction:(id)sender;
- (IBAction) EditTable:(id)sender;
@end

