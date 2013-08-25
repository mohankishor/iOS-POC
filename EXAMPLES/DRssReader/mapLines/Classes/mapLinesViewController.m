//
//  mapLinesViewController.m
//  mapLines
//
//  Created by Craig on 4/12/09.
//  Copyright Craig Spitzkoff 2009. All rights reserved.
//

#import "mapLinesViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "CSMapRouteLayerView.h"

@implementation mapLinesViewController
@synthesize routeView = _routeView;
@synthesize mapView   = _mapView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//
	// load the points from our local resource
	//
	NSString* filePath = [[NSBundle mainBundle] pathForResource:@"route" ofType:@"csv"];
	NSString* fileContents = [NSString stringWithContentsOfFile:filePath];
	NSArray* pointStrings = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	
	NSMutableArray* points = [[NSMutableArray alloc] initWithCapacity:pointStrings.count];
	
	for(int idx = 0; idx < pointStrings.count; idx++)
	{
		// break the string down even further to latitude and longitude fields. 
		NSString* currentPointString = [pointStrings objectAtIndex:idx];
		NSArray* latLonArr = [currentPointString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
		
		CLLocationDegrees latitude  = [[latLonArr objectAtIndex:0] doubleValue];
		CLLocationDegrees longitude = [[latLonArr objectAtIndex:1] doubleValue];
		
		CLLocation* currentLocation = [[[CLLocation alloc] initWithLatitude:latitude longitude:longitude] autorelease];
		[points addObject:currentLocation];
	}
	

	//
	// Create our map view and add it as as subview. 
	//
	_mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[self.view addSubview:_mapView];
	
	// create our route layer view, and initialize it with the map on which it will be rendered. 
	_routeView = [[CSMapRouteLayerView alloc] initWithRoute:points mapView:_mapView];
	
	[points release];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	self.mapView   = nil;
	self.routeView = nil;
}


- (void)dealloc {	
    [super dealloc];
}

@end
