//
//  City.h
//  CoreDataTest
//
//  Created by Björn Sållarp on 2009-06-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Province;

@interface City :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) Province * CityToProvince;

@end



