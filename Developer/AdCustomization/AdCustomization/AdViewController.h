//
//  AdViewController.h
//  AdCustomization
//
//  Created by test on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CloudMadeLBA/CMAdBannerView.h"
#import "MapKit/MapKit.h"
@interface AdViewController : UIViewController<CMADBannerViewProtocol>
{
    MKMapView *mapView;
    CMAdBannerView *bannerView;
}
@end
