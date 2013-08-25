//
//  TabBarSaveStateAppDelegate.m
//  TabBarSaveState
//
//  Created by Ellen Miner on 2/27/09.
//  Copyright RaddOnline 2009. All rights reserved.
//

#import "TabBarSaveStateAppDelegate.h"

@implementation TabBarSaveStateAppDelegate

@synthesize window;
@synthesize tabController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	tabController = [[UITabBarController alloc] init];
	tabController.delegate = self;
	
	//Add some tabs to the controller...
	AllTabsViewController *firstTabController = [[AllTabsViewController alloc] initWithNibName: @"AllTabsView" bundle: nil];
	firstTabController.title = @"Tab One";
	
	AllTabsViewController *secondTabController = [[AllTabsViewController alloc] initWithNibName: @"AllTabsView" bundle: nil];
	secondTabController.title = @"Tab Two";
	
	AllTabsViewController *thirdTabController = [[AllTabsViewController alloc] initWithNibName: @"AllTabsView" bundle: nil];
	thirdTabController.title = @"Tab Three";
	
	AllTabsViewController *fourthTabController = [[AllTabsViewController alloc] initWithNibName: @"AllTabsView" bundle: nil];
	fourthTabController.title = @"Tab Four";
	
	AllTabsViewController *fifthTabController = [[AllTabsViewController alloc] initWithNibName: @"AllTabsView" bundle: nil];
	fifthTabController.title = @"Tab Five";
	
	AllTabsViewController *sixthTabController = [[AllTabsViewController alloc] initWithNibName: @"AllTabsView" bundle: nil];
	sixthTabController.title = @"Tab Six";
	
	tabController.viewControllers = [NSArray arrayWithObjects:firstTabController, secondTabController, thirdTabController, fourthTabController, fifthTabController, sixthTabController, nil];

	[self setTabOrderIfSaved];
	
	[firstTabController release];
	[secondTabController release];
	[thirdTabController release];
	[fourthTabController release];
	[fifthTabController release];
	[sixthTabController release];
	
	[window addSubview:tabController.view];
	
    // Override point for customization after application launch
    [window makeKeyAndVisible];
}

- (void)setTabOrderIfSaved {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSArray *savedOrder = [defaults arrayForKey:@"savedTabOrder"];
	NSMutableArray *orderedTabs = [NSMutableArray arrayWithCapacity:6];
	
	if ([savedOrder count] > 0 ) {
		for (int i = 0; i < [savedOrder count]; i++){
			for (UIViewController *aController in tabController.viewControllers) {
				if ([aController.title isEqualToString:[savedOrder objectAtIndex:i]]) {
					[orderedTabs addObject:aController];
				}
			}
		}
		tabController.viewControllers = orderedTabs;
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	
	NSMutableArray *savedOrder = [NSMutableArray arrayWithCapacity:6];
	NSArray *tabOrderToSave = tabController.viewControllers;
	for (UIViewController *aViewController in tabOrderToSave) {
		[savedOrder addObject:aViewController.title];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:savedOrder forKey:@"savedTabOrder"];
}


- (void)dealloc {
    [window release];
	[tabController release];
    [super dealloc];
}


@end
