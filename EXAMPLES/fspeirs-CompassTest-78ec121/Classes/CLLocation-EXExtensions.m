//
//  CLLocation-EXExtensions.m
//  FlickrExportTouch
//
//  Created by Fraser Speirs on 15/05/2008.
//  Copyright 2008 Connected Flow, Ltd.. All rights reserved.
//

#import "CLLocation-EXExtensions.h"
#import <math.h>

@implementation CLLocation (EXExtensions)
- (NSString *)latitudeString {
	return [self latitudeStringWithSpaces: YES];
}

- (NSString *)latitudeStringWithSpaces:(BOOL)useSpaces {
	return [NSString stringWithFormat: @"%.2f%@%@", 
			fabs(self.coordinate.latitude),
			useSpaces ? @" " : @"",
			(self.coordinate.latitude > 0) ? @"N" : @"S"];
}

- (NSString *)longitudeString {
	return [self longitudeStringWithSpaces: YES];
}

- (NSString *)longitudeStringWithSpaces:(BOOL)useSpaces {
		return [NSString stringWithFormat: @"%.2f%@%@", 
				fabs(self.coordinate.longitude), 
				useSpaces ? @" " : @"",
				(self.coordinate.longitude > 0) ? @"E" : @"W"];
}

- (NSString *)shortDescription {
	return [NSString stringWithFormat: @"%.1f%@,%.1f%@",
			fabs(self.coordinate.latitude), (self.coordinate.latitude > 0) ? @"N" : @"S",
			fabs(self.coordinate.longitude), (self.coordinate.longitude > 0) ? @"E" : @"W"];
}

- (NSURL *)googleMapsURL {
	return [NSURL URLWithString: [NSString stringWithFormat: @"http://maps.google.com/?q=%.4f,%.4f&ll=%.4f,%.4f", self.coordinate.latitude, self.coordinate.longitude, self.coordinate.latitude, self.coordinate.longitude]];
}

- (NSComparisonResult)compareByTimestamp:(CLLocation *)otherLocation {
	if(![otherLocation isKindOfClass: [CLLocation class]])
		 return NSOrderedSame;
	return [self.timestamp compare: otherLocation.timestamp];
}
@end
