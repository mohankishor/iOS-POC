//
//  NSAppDelegate.m
//  NewsstandTry
//
//  Created by test on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSAppDelegate.h"
#import "NSViewController.h"
#import <NewsstandKit/NewsstandKit.h>
@implementation NSAppDelegate

@synthesize window = _window;
@synthesize store;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NKDontThrottleNewsstandContentNotifications"];
    
    NSLog(@"LAUNCH OPTIONS = %@",launchOptions);
    
    // initialize the Store view controller - required for all Newsstand functionality
    self.store = [[NSViewController alloc] initWithNibName:nil bundle:nil];
    nav = [[UINavigationController alloc] initWithRootViewController:store];
    
    //[[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    // check if the application will run in background after being called by a push notification
    NSDictionary *payload = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    //if(payload && [payload objectForKey:@"content-available"]) {
    if(payload) {
        // schedule for issue downloading in background
        // in this tutorial we hard-code background download of magazine-2, but normally the magazine to be downloaded
        // has to be provided in the push notification custom payload
        NKIssue *issue4 = [[NKLibrary sharedLibrary] issueWithName:@"Magazine-2"];
        if(issue4) {
            NSURL *downloadURL = [NSURL URLWithString:@"http://www.viggiosoft.com/media/data/blog/newsstand/magazine-2.pdf"];
            NSURLRequest *req = [NSURLRequest requestWithURL:downloadURL];
            NKAssetDownload *assetDownload = [issue4 addAssetWithRequest:req];
            [assetDownload downloadWithDelegate:store];
        }
        
    }
    
    
    // setup the window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:nav.view];
    [self.window makeKeyAndVisible];
    
    // when the app is relaunched, it is better to restore pending downloading assets as abandoned downloadings will be cancelled
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    for(NKAssetDownload *asset in [nkLib downloadingAssets]) {
        NSLog(@"Asset to downlaod: %@",asset);
        [asset downloadWithDelegate:store];            
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
