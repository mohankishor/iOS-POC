//
//  View_ControllerViewController.h
//  View_Controller
//
//  Created by Anand Kumar Y N on 11/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface View_ControllerViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
	NSArray *colorNames;
	UITableView *table;
}

@property(nonatomic,retain)NSArray *colorNames;

@end

