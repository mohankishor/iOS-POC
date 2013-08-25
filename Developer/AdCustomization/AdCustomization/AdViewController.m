//
//  AdViewController.m
//  AdCustomization
//
//  Created by test on 17/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AdViewController.h"

@implementation AdViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height)];
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    [self.view addSubview: mapView];
    mapView.showsUserLocation = YES;
    // Remember to release mapView in the DidUnload method [mapView release];
    // Adding the sub view for the banner needs to be done last so it is on top of the map
    bannerView = [[CMAdBannerView alloc]
                                   initWithDelegate:self];
    bannerView.alpha = 1.0;
    //bannerView.tag = 1;
    [self.view addSubview:bannerView];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
-(NSString*) bannerViewApiKey
{
    return @"6419af4658374120bdf680809e44cee1";
}
#pragma mark Obtaining current location

- (CLLocationCoordinate2D) currentLocation
{
    return [[[mapView userLocation] location] coordinate];
}

#pragma mark CMAdBannerView Delegate optional methods

-(CLLocationCoordinate2D) bannerViewEnableLocation
{
    return [self currentLocation];
    
}


-(UIColor*) bannerViewPrimaryGradientColor
{
    return [UIColor blueColor];
}

-(UIColor*) bannerViewSecondaryGradientColor
{
    return [UIColor grayColor];
}

-(void) bannerViewDidLoadAd
{
       
}

-(void) bannerViewDidFailToLoad
{
}

-(BOOL) bannerViewActionShouldBegin
{
    return YES;
}

-(void) bannerViewActionDidFinish
{
    [self dismissModalViewControllerAnimated:YES];
}
@end
