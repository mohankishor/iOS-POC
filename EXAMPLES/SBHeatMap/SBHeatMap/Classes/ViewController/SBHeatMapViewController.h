//
//  ViewController.h
//  GeoHeatMap
//
//  Created by Sanath K on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBHeatMapView;
@interface SBHeatMapViewController : UIViewController <UIScrollViewDelegate>
{
	UIScrollView *_scrollView;
	SBHeatMapView *_heatMapView;
}
@end
