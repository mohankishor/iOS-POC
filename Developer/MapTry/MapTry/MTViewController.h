//
//  MTViewController.h
//  MapTry
//
//  Created by test on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"

@class DisplayMap;

@interface MTViewController : UIViewController<MKMapViewDelegate>
{
    __weak IBOutlet MKMapView *mapView;
}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
