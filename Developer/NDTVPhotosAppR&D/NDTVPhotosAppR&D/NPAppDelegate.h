//
//  NPAppDelegate.h
//  NDTVPhotosAppR&D
//
//  Created by test on 04/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NPViewController;

@interface NPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NPViewController *viewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@end
