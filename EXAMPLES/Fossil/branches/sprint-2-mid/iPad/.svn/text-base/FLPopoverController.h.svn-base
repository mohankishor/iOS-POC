//
//  FLPopoverController.h
//  Fossil
//
//  Created by Ganesh Nayak on 08/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FLPopoverController : UIViewController  <UITableViewDelegate, UITableViewDataSource>
{
	NSMutableArray               *mHomeScreenItems;
	UITableView                 *mCatalogTableView;
	UIPopoverController *mUtilityPopoverController;
	id	                                 mDelegate;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSMutableArray *homeScreenItems;
@property (nonatomic, retain) IBOutlet UITableView *catalogTableView;

- (UIPopoverController *) showUtilityPopover;

@end
