//
//  Province.h
//  CoreDataTest
//
//  Created by Björn Sållarp on 2009-06-10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Province :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSManagedObject * ProvinceToCity;
@property (nonatomic, retain) NSManagedObject * ProvinceToCounty;

@end



