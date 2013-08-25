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

@interface City :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSNumber * Inhabitants;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * Phone;
@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) Province * CityToProvince;

@end



