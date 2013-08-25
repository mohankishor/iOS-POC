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

@class Province;

@interface County :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSSet* CountyToProvince;

@end


@interface County (CoreDataGeneratedAccessors)
- (void)addCountyToProvinceObject:(Province *)value;
- (void)removeCountyToProvinceObject:(Province *)value;
- (void)addCountyToProvince:(NSSet *)value;
- (void)removeCountyToProvince:(NSSet *)value;

@end

