//
//  TabBarSaveStateIBAppDelegate.h
//  TabBarSaveStateIB
//
//  Created by Ellen Miner on 2/27/09.
//  Copyright RaddOnline 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarSaveStateIBAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
}
- (void)setTabOrderIfSaved;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
