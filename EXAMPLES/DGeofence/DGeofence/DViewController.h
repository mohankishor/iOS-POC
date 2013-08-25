//
//  DViewController.h
//  DGeofence
//
//  Created by Darshan Sonde on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAddViewController.h"



@interface DViewController : UIViewController<DAddProtocol,UIActionSheetDelegate,CLLocationManagerDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
-(CLLocationManager*) locationManager;
- (IBAction)fetchPerks:(id)sender;
@end
