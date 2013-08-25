//
//  NSAppDelegate.h
//  NewsstandTry
//
//  Created by test on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NSViewController;
@interface NSAppDelegate : UIResponder <UIApplicationDelegate>{
    UINavigationController *nav;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSViewController *store;

@end
