//
//  RDViewController.h
//  MainProjectR&D
//
//  Created by test on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KMLParser.h"
#import "Locations.h"
#import "InfoViewController.h"

@interface RDViewController : UIViewController<MKMapViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate>{
    KMLParser *kmlParser;
}
@property (weak, nonatomic) IBOutlet UIView *disclaimerView;
@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (nonatomic,strong)NSMutableArray *facilityDetailsArray;
- (IBAction)acceptDisclaimer:(id)sender;
- (IBAction)dontAcceptDisclaimer:(id)sender;
- (void)plotCrimePositions;
- (IBAction)handlePinch:(UIPinchGestureRecognizer *)recognizer;
- (void)formatAnnotationView:(MKAnnotationView *)pinView forMapView:(MKMapView *)aMapView;
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
@end
