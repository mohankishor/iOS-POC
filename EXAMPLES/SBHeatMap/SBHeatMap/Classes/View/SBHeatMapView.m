//
//  MapView.m
//  GeoHeatMap
//
//  Created by Sanath K on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBHeatMapView.h"
#import "SBHeatMapKmlParser.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define kRValue 6378.1
#define keValue 2.718281828
#define kLongitude0 0
#define kXExtents M_PI
#define kYExtents 2*DEGREES_TO_RADIANS(67)

/*
 Alternate method
 */
//y extents from 80 degree south to 84 degree north
//#define kYMinLatValue 2.436246 //(log10f(fabs((1+sin(DEGREES_TO_RADIANS(80)))/cos(DEGREES_TO_RADIANS(80))))/log10f(keValue))
//#define kYMaxLatValue 2.948700 //(log10f(fabs((1+sin(DEGREES_TO_RADIANS(84)))/cos(DEGREES_TO_RADIANS(84))))/log10f(keValue))

#define kDefaultCountryColor [UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:240.0/255.0 alpha:1.0]
#define kDefaultOceanColor [UIColor colorWithRed:165.0/255.0 green:191.0/255.0 blue:221.0/255.0 alpha:1.0]

@interface SBHeatMapView ()
{
	NSDictionary *_countryBoundaryDict;
	NSDictionary *_countryColorDict;
}
- (CGPoint)convertToXYCoordinatesForLongitude:(CGFloat)longitude andLatitude:(CGFloat)latitude;
@end
	
@implementation SBHeatMapView

- (id)initWithFrame:(CGRect)frame andCountryColorInfo:(NSDictionary *)colorInfoDict
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = kDefaultOceanColor;
		SBHeatMapKmlParser *kmlParser = [[SBHeatMapKmlParser alloc] init];
		_countryBoundaryDict = [kmlParser parseGoogleEarthKmlDoc];
		_countryColorDict = [NSDictionary dictionaryWithDictionary:colorInfoDict];
    }
    return self;
}

#pragma mark - Converts Longitude and Latitude to X and Y coordinates using Mercator projection

- (CGPoint)convertToXYCoordinatesForLongitude:(CGFloat)longitude andLatitude:(CGFloat)latitude
{
	CGFloat latScaleFactor = self.frame.size.height/(2*kYExtents);
	CGFloat lonScaleFactor = self.frame.size.width/(2*kXExtents);
	CGFloat xLonValue =(DEGREES_TO_RADIANS(longitude) - DEGREES_TO_RADIANS(kLongitude0));
	CGFloat yLatValue =(log10f(fabs((1+sin(DEGREES_TO_RADIANS(latitude)))/cos(DEGREES_TO_RADIANS(latitude))))/log10f(keValue));
	xLonValue = (xLonValue+kXExtents)*lonScaleFactor;
	yLatValue = (yLatValue+kYExtents)*latScaleFactor;
	
	/*
	 Alternate method
	 */
	//xLonValue= ((xLonValue + M_PI)/(2*M_PI))*self.frame.size.width;
	//yLatValue = ((yLatValue+kYMinLatValue)/(kYMinLatValue + kYMaxLatValue))*self.frame.size.height;
	return CGPointMake(xLonValue, yLatValue);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	id key = nil;
	NSEnumerator *enumerator = [_countryBoundaryDict keyEnumerator];
	CGContextRef c = UIGraphicsGetCurrentContext();
	CGContextBeginPath(c);
	CGContextTranslateCTM(c, 0, self.frame.size.height);
	CGContextScaleCTM(c, 1.0, -1.0);
	
	while (key = [enumerator nextObject]) {
		NSArray *countryBoundaryArray = [_countryBoundaryDict objectForKey:key];
		
		for (int arrayCount = 0; arrayCount < [countryBoundaryArray count]; arrayCount++) {
			NSString *coordinatesString= [[NSString alloc] initWithString:[countryBoundaryArray objectAtIndex:arrayCount]];		
			NSArray *coordinatesArray = [coordinatesString componentsSeparatedByString:@" "];
			NSMutableArray *latitudeArray = [[NSMutableArray alloc] init];
			NSMutableArray *longitudeArray = [[NSMutableArray alloc] init];
			
			for (int k = 0; k < [coordinatesArray count]; k++) {
				[longitudeArray addObject:[(NSArray *)[(NSString *)[coordinatesArray objectAtIndex:k] componentsSeparatedByString:@","] objectAtIndex:0]];
				[latitudeArray addObject:[(NSArray *)[(NSString *)[coordinatesArray objectAtIndex:k] componentsSeparatedByString:@","] objectAtIndex:1]];
			}
			
			CGPoint mapViewCoordinates1 = [self convertToXYCoordinatesForLongitude:[[longitudeArray objectAtIndex:0] floatValue] andLatitude:[[latitudeArray objectAtIndex:0] floatValue]];
			CGContextMoveToPoint(c, mapViewCoordinates1.x, mapViewCoordinates1.y);

			for (int i = 0; i < [latitudeArray count]-1; i++) {
				CGPoint mapViewCoordinates2 = [self convertToXYCoordinatesForLongitude:[[longitudeArray objectAtIndex:i] floatValue] andLatitude:[[latitudeArray objectAtIndex:i] floatValue]];
				CGContextAddLineToPoint(c, mapViewCoordinates2.x, mapViewCoordinates2.y);
			}
			
			if ([[_countryColorDict allKeys] containsObject:key]) {
				CGContextSetFillColorWithColor(c, ((UIColor *)[_countryColorDict objectForKey:key]).CGColor);
			}
			else {
				CGContextSetFillColorWithColor(c, kDefaultCountryColor.CGColor);
			}
			CGContextFillPath(c);
		}
	}
}

@end
