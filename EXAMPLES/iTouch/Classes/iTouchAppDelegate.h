//
//  iTouchAppDelegate.h
//  iTouch
//
//  Created by Anand Kumar Y N on 19/08/10.
//  Copyright Sourcebits Technologies 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iTouchViewController;

@interface iTouchAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iTouchViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iTouchViewController *viewController;

@end

