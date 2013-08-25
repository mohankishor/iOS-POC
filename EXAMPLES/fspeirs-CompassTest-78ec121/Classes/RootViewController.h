//
//  RootViewController.h
//  CompassTest
//
//  Created by Fraser Speirs on 18/06/2009.
//  Copyright Connected Flow 2009. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UITableViewController <CLLocationManagerDelegate> {
	CLLocationManager *manager;
	
	CLLocation *mostRecentLocation;
	CLHeading *mostRecentHeading;
	
	BOOL locationEnabled;
	BOOL headingEnabled;
	
	UISwitch *locationSwitch;
	UISwitch *headingSwitch;
}
@property (readwrite, retain) CLLocation *mostRecentLocation;
@property (readwrite, retain) CLHeading *mostRecentHeading;
@end
