//
//  RDMapKit.m
//  RedDeluxe
//
//  Created by Test on 31/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDMapKit.h"

@implementation RDMapKit
{
    //CLLocationManager *locationManager;
    __block int zipcode;
}
@synthesize locationManager;
@synthesize currentLocation;
@synthesize myGeocoder;

#pragma mark - MapKit lifecycle
//
/*
- (CLLocationManager *)locationManager {
	
    if (locationManager != nil) {
		return locationManager;
	}
	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:(id)self];
	
	return locationManager;
}
*/
/*
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //We received the new location 
    NSLog(@"Latitude = %f", newLocation.coordinate.latitude);
    NSLog(@"Longitude = %f", newLocation.coordinate.longitude);
}
*/
-(float)findCurrentLongitude
{
    RDAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.userCoordinates.longitude;
}

- (float) findCurrentLatitude
{
    RDAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.userCoordinates.latitude;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    /* Failed to receive user's location */
}

/*
-(void)findAddresstoCorrespondinglocation
{
    NSString *str = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",[self findCurrentLatitude],[self findCurrentLongitude]];
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    [request setRequestMethod:@"GET";
    [request setDelegate:self];
    [request setDidFinishSelector: @selector(mapAddressResponse:);
    [request setDidFailSelector: @selector(mapAddressResponseFailed:);
    [networkQueue addOperation: request];
    [networkQueue go];
    
}
*/
-(int)findCurrentZip
{
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:[self findCurrentLatitude]
                                                          longitude:[self findCurrentLongitude]];
    self.myGeocoder = [[CLGeocoder alloc] init];
    
//    dispatch_queue_t queue = dispatch_queue_create("FetchingObservedXML", NULL);
//    dispatch_queue_t main = dispatch_get_main_queue();
//    
//    dispatch_async(main, ^{ 
//        
    [self.myGeocoder 
     reverseGeocodeLocation:userLocation
     completionHandler: (id)^(NSArray *placemarks, NSError *error) {
         if (error == nil && [placemarks count] > 0)
         {
             NSLog(@"Placemarks: %@",placemarks);
             
              CLPlacemark *placemark = [placemarks objectAtIndex:0];
             /* We received the results */
             NSLog(@"Country = %@", placemark.country);
             NSLog(@"Postal Code = %@", placemark.postalCode);
             zipcode = (int)placemark.postalCode;
             NSLog(@"Locality = %@", placemark.locality);
             NSLog(@"Country%@",[placemarks lastObject]);
             //return ;
         }
         else if (error == nil && [placemarks count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             
         }
         return zipcode;
    }];
//        dispatch_async(main, (id)^{
//            return zipcode;
//        });
//    });
    
    return zipcode;
}

@end
