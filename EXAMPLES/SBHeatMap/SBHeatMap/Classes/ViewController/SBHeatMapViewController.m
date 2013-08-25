//
//  ViewController.m
//  GeoHeatMap
//
//  Created by Sanath K on 27/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBHeatMapViewController.h"
#import "SBHeatMapView.h"

#define kSBHeatMapViewFrame CGRectMake(0.0, 0.0, 1024.0, 748.0)

@implementation SBHeatMapViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:kSBHeatMapViewFrame];
	scrollView.delegate = self;
	scrollView.maximumZoomScale = 10.0;
	scrollView.minimumZoomScale = 1.0;
	[self.view addSubview:scrollView];
	
	//Check CountryNameAndCodes.rtf file in Resources folder to get Iso 2 Country Code
	_heatMapView = [[SBHeatMapView alloc] initWithFrame:kSBHeatMapViewFrame andCountryColorInfo:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor],@"IN", nil]];
	[scrollView addSubview:_heatMapView];
	scrollView.contentSize = _heatMapView.frame.size;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _heatMapView;
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
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

@end
