//
//  MRAppDelegate.h
//  MapRouteBetweenCities
//
//  Created by test on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MRViewController;

@interface MRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MRViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
