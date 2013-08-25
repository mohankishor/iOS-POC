//
//  Locations.m
//  MainProjectR&D
//
//  Created by test on 05/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Locations.h"

@implementation Locations
@synthesize name = _name;
@synthesize address = _address;
@synthesize coordinate = _coordinate;
@synthesize dsn = _dsn;
- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate dsn:(NSString *)dsn {
    if ((self = [super init])) {
        _name = [name copy];
        _address = [address copy];
        _dsn = [dsn copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]]) 
        return @"Unknown";
    else
        return _name;
}

- (NSString *)subtitle {
    return _address;
}
@end
