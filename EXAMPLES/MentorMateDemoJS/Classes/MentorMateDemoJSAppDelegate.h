//
//  MentorMateDemoJSAppDelegate.h
//  MentorMateDemoJS
//
//  Created by Iordan Iordanov on 2/26/10.
//  Copyright MentorMate 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MentorMateDemoJSViewController;

@interface MentorMateDemoJSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MentorMateDemoJSViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MentorMateDemoJSViewController *viewController;

@end

