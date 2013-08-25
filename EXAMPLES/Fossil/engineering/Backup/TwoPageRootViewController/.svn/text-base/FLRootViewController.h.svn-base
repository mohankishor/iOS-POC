//
//  FLRootViewController.h
//  Fossil
//
//  Created by Ganesh Nayak on 06/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPopoverController.h"

@interface FLRootViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
	UIImageView                 *mLaunchImage;
	UIToolbar           *mTopTransluscentView;
	UIToolbar        *mBottomTransluscentView;
	NSMutableArray          *mHomeScreenItems;
	UITableView            *mCatalogTableView;
	BOOL	                  mScreenIsTapped;
	FLPopoverController *mFLPopoverController;
	UIButton	     *mFossilToolbarLogoImage;
}

@property BOOL screenIsTapped;
@property (nonatomic, retain) IBOutlet UIView *launchImage;
@property (nonatomic, retain) NSMutableArray *homeScreenItems;
@property (nonatomic, retain) UIButton *fossilToolbarLogoImage;
@property (nonatomic, retain) IBOutlet UITableView *catalogTableView;
@property (nonatomic, retain) IBOutlet UIToolbar *topTransluscentView;
@property (nonatomic, retain) FLPopoverController *flPopoverController;
@property (nonatomic, retain) IBOutlet UIToolbar *bottomTransluscentView;

- (IBAction) gotoHome:(id) sender;

- (IBAction) animateTransluscentView:(id) sender;

- (void) showUtilityPopover;

@end
