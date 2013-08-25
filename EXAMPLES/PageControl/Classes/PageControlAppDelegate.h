#import <UIKit/UIKit.h>

@class PageControlViewController;

@interface PageControlAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    PageControlViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet PageControlViewController *viewController;

@end

