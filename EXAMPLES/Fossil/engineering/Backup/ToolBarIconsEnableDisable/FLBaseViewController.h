//
//  FLBaseViewController.h
//  Fossil
//
//  Created by Ganesh Nayak on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FLBaseViewController : UIViewController
{
	BOOL mBarsHidden;
	UINavigationBar *mNavigationBar;
	UIToolbar *mToolBar;
}


@property BOOL barsHidden;
@property (nonatomic, retain) UINavigationBar *navigationBar;
@property (nonatomic, retain) UIToolbar *toolBar;





-(void) handleToolBarAction:(id) sender;

- (void) barsVisible:(BOOL) aBool;

@end
