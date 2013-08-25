//
//  Fence.m
//  DGeofence
//
//  Created by Darshan Sonde on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Fence.h"


@implementation Fence

@dynamic id_string;
@dynamic latitude;
@dynamic longitude;
@dynamic radius;
@dynamic accuracy;

@synthesize coordinate;
@synthesize title;
@synthesize circle;

-(void) setCoordinate:(CLLocationCoordinate2D)coord
{
    [self setValue:[NSNumber numberWithDouble:coord.latitude] forKey:@"latitude"];
    [self setValue:[NSNumber numberWithDouble:coord.longitude] forKey:@"longitude"];
    coordinate = coord;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"FenceChanged" object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"fence"]];
}
-(CLLocationCoordinate2D) coordinate
{
    return CLLocationCoordinate2DMake([self.latitude doubleValue], [self.longitude doubleValue]);
}

-(void) setTitle:(NSString *)titleText
{
    self.id_string = [titleText copy];
}
-(NSString*) title
{
    return self.id_string;
}


@end
