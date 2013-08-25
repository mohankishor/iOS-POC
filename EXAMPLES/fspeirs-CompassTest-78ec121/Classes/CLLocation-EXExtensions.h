//
//  CLLocation-EXExtensions.h
//  FlickrExportTouch
//
//  Created by Fraser Speirs on 15/05/2008.
//  Copyright 2008 Connected Flow, Ltd.. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CLLocation (EXExtensions)
- (NSString *)latitudeString;
- (NSString *)longitudeString;
- (NSString *)latitudeStringWithSpaces:(BOOL)useSpaces;
- (NSString *)longitudeStringWithSpaces:(BOOL)useSpaces;
- (NSString *)shortDescription;
- (NSURL *)googleMapsURL;
- (NSComparisonResult)compareByTimestamp:(CLLocation *)otherLocation;
@end
