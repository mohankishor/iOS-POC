//
//  View_ControllerAppDelegate.h
//  View_Controller
//
//  Created by Anand Kumar Y N on 11/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class View_ControllerViewController;

@interface View_ControllerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    View_ControllerViewController *viewController;
	UINavigationController *navigationController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet View_ControllerViewController *viewController;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

