//
//  Created by Björn Sållarp on 2009-06-14.
//  NO Copyright 2009 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <CoreData/CoreData.h>

@class City;
@class County;

@interface Province :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSSet* ProvinceToCity;
@property (nonatomic, retain) County * ProvinceToCounty;

@end


@interface Province (CoreDataGeneratedAccessors)
- (void)addProvinceToCityObject:(City *)value;
- (void)removeProvinceToCityObject:(City *)value;
- (void)addProvinceToCity:(NSSet *)value;
- (void)removeProvinceToCity:(NSSet *)value;

@end

