//
//  FLBaseViewController.h
//  Fossil
//
//  Created by Ganesh Nayak on 13/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLPopoverController.h"
#import "FLCatalogProductViewController.h"

#define TB_HOME_INDEX 0
#define TB_GRID_INDEX 4
#define TB_NEXT_INDEX 6
#define TB_PREV_INDEX 2
#define TB_BAG_INDEX 8

#define TB_WATCH_NEXT_INDEX 6
#define TB_WATCH_LABEL_INDEX 4
#define TB_WATCH_PREV_INDEX 2

@interface FLBaseViewController : UIViewController
{
	FLPopoverController *mPopoverController;
@private
	NSTimer *mTimer;

}

-(void) createNavigationBarItems;//called in loadView
-(void) createNavigationRightItem;
-(void) createNavigationLeftItem;
-(void) createToolbarItems;
-(void) configureBars;

-(void) toggleBars;//calls toggleNavigationBar  and toggleToolbar after configuring bars
-(void) toggleNavigationBar;//derived classes should override this class
-(void) toggleToolbar;//derived classes should override this class
-(void) forceHideBars;//called when view swithcing is required

- (void) handleMenuActions:(int) index;

-(void) showInfo;//shop now
-(void) showNext;
-(void) showPrevious;
-(void) showBag;
-(void) showHome;
-(void) showGrid;

-(void) showPopover;

-(void) setButtonEnabled:(BOOL)enabled atIndex:(int) index;

@end
