//
//  tabbarSAmpleAppDelegate.h
//  tabbarSAmple
//
//  Created by Reshma Nayak on 08/10/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tabbarSAmpleViewController;

@interface tabbarSAmpleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    tabbarSAmpleViewController *viewController;
	IBOutlet UITabBarController *rootController;
}
@property(nonatomic,retain)UITabBarController *rootController;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet tabbarSAmpleViewController *viewController;

@end

