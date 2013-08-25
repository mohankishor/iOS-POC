//
//  CustomCellTableViewViewController.h
//  CustomCellTableView
//
//  Created by Anand Kumar Y N on 26/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellForTable.h"
#import "Employee.h"

@interface CustomCellTableViewViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
	
	UITextField *mInput;
	NSMutableArray *mNameArray;
	UITableView *mTable1;
}

@end

