//
//  TabBarSaveStateIBAppDelegate.m
//  TabBarSaveStateIB
//
//  Created by Ellen Miner on 2/27/09.
//  Copyright RaddOnline 2009. All rights reserved.
//

#import "TabBarSaveStateIBAppDelegate.h"


@implementation TabBarSaveStateIBAppDelegate

@synthesize window;
@synthesize tabBarController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [self setTabOrderIfSaved];
    // Add the tab bar controller's current view as a subview of the window
    [window addSubview:tabBarController.view];
}


/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
}
*/

/*
// Optional UITabBarControllerDelegate method
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
}
*/

- (void)setTabOrderIfSaved {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *savedOrder = [defaults arrayForKey:@"savedTabOrder"];
	NSMutableArray *orderedTabs = [NSMutableArray arrayWithCapacity:6];
	if ([savedOrder count] > 0 ) {
		for (int i = 0; i < [savedOrder count]; i++){
			for (UIViewController *aController in tabBarController.viewControllers) {
				if ([aController.tabBarItem.title isEqualToString:[savedOrder objectAtIndex:i]]) {
					[orderedTabs addObject:aController];
				}
			}
		}
		tabBarController.viewControllers = orderedTabs;
		NSLog(@"Display order:%@",orderedTabs);
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	NSMutableArray *savedOrder = [NSMutableArray arrayWithCapacity:6];
	NSArray *tabOrderToSave = tabBarController.viewControllers;
	
	for (UIViewController *aViewController in tabOrderToSave) {
		[savedOrder addObject:aViewController.tabBarItem.title];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:savedOrder forKey:@"savedTabOrder"];
}



- (void)dealloc {
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end

