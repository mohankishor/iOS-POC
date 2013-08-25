//
//  FLCatalogMenuViewController.h
//  Fossil
//
//  Created by Darshan on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface FLCatalogMenuViewController : FLBaseViewController 
{
	UIImageView					*mCoverImageView;
	UIImageView					*mLogoImageView;
	UITableView					*mTableView;
	UISwipeGestureRecognizer	*mSwipeRecognizer;
	UITapGestureRecognizer		*mTapRecognizer;
	AppDelegate					*mAppDelegate;
}

@property (nonatomic, retain) IBOutlet UIImageView* coverImageView;
@property (nonatomic, retain) IBOutlet UIImageView* logoImageView;
@property (nonatomic, retain) IBOutlet UITableView* tableView;

- (IBAction)playVideo:(id)sender;
@end
