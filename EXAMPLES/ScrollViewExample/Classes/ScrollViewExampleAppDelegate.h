//
//  ScrollViewExampleAppDelegate.h
//  ScrollViewExample
//
//  Created by Chakra on 31/03/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ScrollViewExampleViewController;

@interface ScrollViewExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ScrollViewExampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ScrollViewExampleViewController *viewController;

@end

