//
//  PhotoAppAppDelegate.h
//  PhotoApp
//
//  Created by Brandon Trebitowski on 7/28/09.
//  Copyright RightSprite 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoAppViewController;

@interface PhotoAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow * window;
	
    PhotoAppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PhotoAppViewController *viewController;

@end

