
#import "FLReachability.h" 

#ifndef FLCOMMON_H
#define FLCOMMON_H

#define FL_IS_IPAD (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad))

#define FL_IPAD_CELL_ROW_HEIGHT 232.0
#define FL_IPHONE_CELL_ROW_HEIGHT 108.0
#define FL_IPAD_PRODUCT_CELL_ROW_HEIGHT 210.0
#define FL_IPHONE_PRODUCT_CELL_ROW_HEIGHT 108.0

#define IMAGE_VIEW_WIDTH_HOME_SCREEN_IPAD 550.0
#define TABLE_VIEW_HEIGHT_HOME_SCREEN_IPAD 768.0
#define TABLE_VIEW_WIDTH_HOME_SCREEN_IPAD 454.0


#define IMAGE_VIEW_WIDTH_HOME_SCREEN 260.0
#define TABLE_VIEW_HEIGHT_HOME_SCREEN 320.0
#define TABLE_VIEW_WIDTH_HOME_SCREEN 200.0

#define FL_CATALOG_MENU_TABLE_CELL_IDENTIFIER @"FLMenuCell"
#define FL_CATALOG_GRID_VIEW_CELL_IDENTIFIER @"FossilCell" //xib has this property; make sure u change there also

#define FL_PRODUCT_VIEW_CELL_IDENTIFIER @"FLProductCell"
#define FL_PRODUCT_VIEW_CELL_IDENTIFIER_WATCH @"FLProductCellWatch"

#define FL_CATALOG_MENU_FONT_SIZE_IPAD 28.0
#define FL_CATALOG_MENU_FONT_SIZE_IPHONE 16.0

#define FL_COVER_OFFSET 1

#define FL_IPAD_HEIGHT 768.0
#define FL_IPHONE_HEIGHT 320.0
#define FL_IPAD_NAVBAR_HEIGHT 50.0

#define FL_IPAD_WIDTH 1024.0
#define FL_IPHONE_WIDTH 480.0

#define FL_IMAGE_LONG_PRESS_DELAY 0.2
#define FL_IMAGE_SINGLE_TAP_DELAY 0.3

#define FL_ALERT_VIEW_ANIMATION_DELAY 0.3

#define FL_HAS_CAMERA (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))


#define FL_SHOW_TRY_ON 0

#define FL_USER_DEFINES_PROVIDER @"FOSSIL"
#define FL_USER_DEFINES_PREFIX @"FLAPP1"

#define FL_WEB_TITLE @"Fossil.com"
#define FL_NOT_REACHABLE (([[FLReachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable))
#define FL_IF_CONNECTED() if(FL_NOT_REACHABLE) { UIAlertView *errorView = [[UIAlertView alloc] initWithTitle: @"No Network Connection" message: @"Internet connection required for this feature" delegate: self cancelButtonTitle: @"OK" otherButtonTitles: nil];  [errorView show];[errorView release];} else

#define FL_LOAD_WATCH_SPIN_IMAGE (!FL_IS_IPAD)

#define FL_APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#endif




