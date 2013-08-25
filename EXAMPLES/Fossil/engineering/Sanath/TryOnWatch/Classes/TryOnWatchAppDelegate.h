//
//  TryOnWatchAppDelegate.h
//  TryOnWatch
//
//  Created by Sanath on 20/09/10.
//  Copyright Sourcebits Technologies Pvt Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TryOnWatchViewController;

@interface TryOnWatchAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TryOnWatchViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TryOnWatchViewController *viewController;

@end

