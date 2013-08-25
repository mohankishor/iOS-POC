//
//  BGMoreViewController.h
//  TabBarSaveStateIB
//
//  Created by Sambasivarao D on 29/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGEditTabBarControllersVC.h"

@interface BGMoreViewController : UIViewController {
	IBOutlet	UIBarButtonItem *editItem;
	IBOutlet	UIBarButtonItem *doneItem;
	BGEditTabBarControllersVC *editViewController;
}

-(IBAction) editButtonClicked;
-(IBAction) doneButtonClicked;

@end
