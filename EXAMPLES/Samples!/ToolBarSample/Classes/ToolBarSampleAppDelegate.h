//
//  ToolBarSampleAppDelegate.h
//  ToolBarSample
//
//  Created by Reshma Nayak on 27/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ToolBarSampleViewController;

@interface ToolBarSampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ToolBarSampleViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ToolBarSampleViewController *viewController;

@end

