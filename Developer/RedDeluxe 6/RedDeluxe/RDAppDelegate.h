//
//  RDAppDelegate.h
//  RedDeluxe
//
//  Created by Test on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Facebook.h"

@interface RDAppDelegate : UIResponder <UIApplicationDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocationCoordinate2D userCoordinates;
    
}
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic) CLLocationCoordinate2D userCoordinates;

extern NSString *const FBSessionStateChangedNotification;
@property (strong, nonatomic) UIWindow *window;

- (BOOL) openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;

@end
