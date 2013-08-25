//
//  FLBaseViewController.h
//  Fossil
//
//  Created by Ganesh Nayak on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPopoverController.h"

@interface FLBaseViewController : UIViewController
{
	BOOL                          mBarsHidden;
	UINavigationBar           *mNavigationBar;
	UIToolbar                       *mToolBar;
	id                              mDelegate;
	UIButton                 *mRightNavButton;
	FLPopoverController *mFLPopoverController;
	NSTimer                            *timer;
	UIBarButtonItem             *mCountbutton;
}


@property BOOL barsHidden;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIToolbar *toolBar;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) UIButton *rightNavBarButtonItem;
@property (nonatomic, assign) FLPopoverController *flPopoverController;



- (void) handleToolBarAction:(id) sender;

- (void) barsVisible:(BOOL) aBool;

- (void) createToolbarItems:(id)aPage;

- (void) toggleBars;

@end
