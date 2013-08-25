//
//  RDViewController.m
//  MainProjectR&D
//
//  Created by test on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDViewController.h"

@implementation RDViewController
@synthesize disclaimerView;
@synthesize map;
@synthesize mapView;
@synthesize facilityDetailsArray;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchRecognizer.delegate = self;
    [self.map addGestureRecognizer:pinchRecognizer];
    self.navigationController.navigationBarHidden = YES;
    BOOL disclaimerAccepted = [[NSUserDefaults standardUserDefaults] boolForKey:@"disclaimerAccepted"];
    NSLog(@"%d",disclaimerAccepted);
    if (!disclaimerAccepted) {
        self.disclaimerView.hidden = NO;
        self.mapView.hidden = YES;
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        self.disclaimerView.hidden = YES;
        self.mapView.hidden = NO;
        kmlParser = [[KMLParser alloc] init];
        self.facilityDetailsArray = [[NSMutableArray alloc]init];
        self.facilityDetailsArray = [kmlParser parseKML];
        NSLog(@"%@",self.facilityDetailsArray);
        self.map.delegate = self;
        [self plotCrimePositions];   
    }
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setMap:nil];
    [self setDisclaimerView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (IBAction)acceptDisclaimer:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"disclaimerAccepted"];
    self.disclaimerView.hidden = YES;
    self.mapView.hidden = NO;
    kmlParser = [[KMLParser alloc] init];
    self.facilityDetailsArray = [[NSMutableArray alloc]init];
    self.facilityDetailsArray = [kmlParser parseKML];
    NSLog(@"%@",self.facilityDetailsArray);
    self.map.delegate = self;
    [self plotCrimePositions];   
}

- (IBAction)dontAcceptDisclaimer:(id)sender {
    UIAlertView *deleteAlert = [[UIAlertView alloc]initWithTitle:@"Quit Application" message:@"You have choosed to quit the application" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
    deleteAlert.delegate = self;
    [deleteAlert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        exit(0);
    }
}
- (void)plotCrimePositions {
    
    for (id<MKAnnotation> annotation in self.map.annotations) {
        [self.map removeAnnotation:annotation];
    }
    for (int count = 0;count < [self.facilityDetailsArray count];count = count + 5) {
        NSString * longitude = [self.facilityDetailsArray objectAtIndex:count+3];
        NSString * latitude = [self.facilityDetailsArray objectAtIndex:count+4];
        NSString * crimeDescription =[self.facilityDetailsArray objectAtIndex:count];
        NSString * address = [self.facilityDetailsArray objectAtIndex:count+1];
        NSString *dsn = [self.facilityDetailsArray objectAtIndex:count+2];
        NSLog(@"%@ %@ %@ %@",latitude,longitude,crimeDescription,address);
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude.doubleValue;
        coordinate.longitude = longitude.doubleValue;  
        Locations *annotation = [[Locations alloc] initWithName:crimeDescription address:address coordinate:coordinate dsn:dsn] ;
        [self.map addAnnotation:annotation];    
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation
{
    static NSString *identifier = @"MyLocation";   
    if ([annotation isKindOfClass:[Locations class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image=[UIImage imageNamed:@"map_element_4.png"];//here we use a nice image instead of the default pins
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    
    return nil;    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AirQualityAlerts"]) {
	   InfoViewController *infoViewController = [segue destinationViewController];
    }
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    Locations *annView = view.annotation;
    NSLog(@"%@",annView.name);
    NSLog(@"%@",annView.address);
    NSLog(@"%@",annView.dsn);
    NSLog(@"%f %f",annView.coordinate.latitude,annView.coordinate.longitude);
   [self performSegueWithIdentifier:@"InfoSegue" sender:self];
}
#pragma mark -
#pragma mark UIPinchGestureRecognizer

- (void)handlePinchGesture:(UIPinchGestureRecognizer *)pinchRecognizer {
    if (pinchRecognizer.state != UIGestureRecognizerStateChanged) {
        return;
    }
    NSLog(@"In Pinch:%f",pinchRecognizer.scale);
    MKMapView *aMapView = (MKMapView *)pinchRecognizer.view;
    
    for (id <MKAnnotation>annotation in aMapView.annotations) {
        // if it's the user location, just return nil.
        if ([annotation isKindOfClass:[MKUserLocation class]])
            return;
        
        // handle our custom annotations
        
        if ([annotation isKindOfClass:[MKPointAnnotation class]])
        {
            // try to retrieve an existing pin view first
            MKAnnotationView *pinView = [aMapView viewForAnnotation:annotation];
            //Format the pin view
            [self formatAnnotationView:pinView forMapView:aMapView];
        }
    }    
}
//- (void)formatAnnotationView:(MKAnnotationView *)pinView forMapView:(MKMapView *)aMapView {
//    if (pinView)
//    {
//        double zoomLevel = [aMapView zoomLevel];
//        double scale = -1 * sqrt((double)(1 - pow((zoomLevel/20.0), 2.0))) + 1.1; // This is a circular scale function where at zoom level 0 scale is 0.1 and at zoom level 20 scale is 1.1
//        
//        // Option #1
//        pinView.transform = CGAffineTransformMakeScale(scale, scale);
//        
//        // Option #2
//        UIImage *pinImage = [UIImage imageNamed:@"map_element_4.png"];
//        pinView.image = [self resizedImage:CGSizeMake(pinImage.size.width * scale, pinImage.size.height * scale) interpolationQuality:kCGInterpolationHigh];
//    }
//}
//- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
//    	    BOOL drawTransposed = NO;
//    	    return [self resizedImage:newSize
//                    	                    transform:nil
//                    	               drawTransposed:drawTransposed
//                    	         interpolationQuality:quality];
//    	}
//- (UIImage *)resizedImage:(CGSize)newSize
//	                transform:(CGAffineTransform)transform
//	           drawTransposed:(BOOL)transpose
//	     interpolationQuality:(CGInterpolationQuality)quality {
//	    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
//	    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
//	    CGImageRef imageRef = self.CGImage;
//    	   
//    	    // Build a context that's the same dimensions as the new size
//    	    CGContextRef bitmap = CGBitmapContextCreate(NULL,newRect.size.width,                                                                                              newRect.size.height,CGImageGetBitsPerComponent(imageRef),0,CGImageGetColorSpace(imageRef), CGImageGetBitmapInfo(imageRef));
//    	   
//    	    // Rotate and/or flip the image if required by its orientation
//    	    CGContextConcatCTM(bitmap, transform);
//    	   
//    	    // Set the quality level to use when rescaling
//    	    CGContextSetInterpolationQuality(bitmap, quality);
//    	   
//    	    // Draw into the context; this scales the image
//    	    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
//    	   
//    	    // Get the resized image from the context and a UIImage
//    	    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
//    	    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
//    	   
//    	    // Clean up
//    	    CGContextRelease(bitmap);
//        CGImageRelease(newImageRef);
//    	   
//    	    return newImage;
//    	}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
@end
