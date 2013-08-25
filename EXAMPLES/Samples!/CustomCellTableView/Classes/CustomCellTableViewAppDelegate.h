//
//  CustomCellTableViewAppDelegate.h
//  CustomCellTableView
//
//  Created by Anand Kumar Y N on 26/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCellTableViewViewController;

@interface CustomCellTableViewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    CustomCellTableViewViewController *viewController;
	UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet CustomCellTableViewViewController *viewController;
@property (nonatomic, retain) UINavigationController *navigationController;

@end

