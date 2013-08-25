//
//  TabBarSaveStateAppDelegate.h
//  TabBarSaveState
//
//  Created by Ellen Miner on 2/27/09.
//  Copyright RaddOnline 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllTabsViewController.h"

@interface TabBarSaveStateAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
	UITabBarController *tabController;
}
- (void)setTabOrderIfSaved;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UITabBarController *tabController;
@end

