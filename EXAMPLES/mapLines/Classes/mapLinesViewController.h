//
//  mapLinesViewController.h
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CSMapRouteLayerView.h"

//@class MapViewWithLines;

@interface mapLinesViewController : UIViewController {
	//MapViewWithLines* _mapView;
	MKMapView* _mapView;
	CSMapRouteLayerView* _routeView;
}

@property (nonatomic, retain) MKMapView* mapView;
@property (nonatomic, retain) CSMapRouteLayerView* routeView;

@end

