//
//  MapDirectionsViewController.h
//  MapRouteBetweenCities
//
//  Created by test on 21/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICGDirections.h"
#import "MapKit/MapKit.h"
#import "UICRouteOverlayMapView.h"
#import "WebViewAboutLocation.h"
@interface MapDirectionsViewController : UIViewController<MKMapViewDelegate,UICGDirectionsDelegate>
{
    NSString *startPoint;
	NSString *endPoint;
    MKMapView *routeMapView;
	UICRouteOverlayMapView *routeOverlayView;
	UICGDirections *directions;
}
@property (nonatomic, retain) NSString *startPoint;
@property (nonatomic, retain) NSString *endPoint;
- (void)update;
@end
