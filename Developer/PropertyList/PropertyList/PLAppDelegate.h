//
//  PLAppDelegate.h
//  PropertyList
//
//  Created by test on 31/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLViewController.h"
@class PLViewController;

@interface PLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PLViewController *viewController;

@property (strong,nonatomic) UINavigationController *navigationController;

@end
