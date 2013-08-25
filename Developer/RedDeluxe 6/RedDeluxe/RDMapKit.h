//
//  RDMapKit.h
//  RedDeluxe
//
//  Created by Test on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#include <CoreLocation/CLLocationManagerDelegate.h>
#include <CoreLocation/CLError.h>
#include <CoreLocation/CLLocationManager.h>
//#import "CLGeocoder/CLGeocoder.h"
#import "RDAppDelegate.h"

@interface RDMapKit : NSObject<CLLocationManagerDelegate>

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (nonatomic,retain) CLLocation *currentLocation;
@property (nonatomic, strong) CLGeocoder *myGeocoder;
//@property (nonatomic) int zipcode;
-(int)findCurrentZip;

@end
