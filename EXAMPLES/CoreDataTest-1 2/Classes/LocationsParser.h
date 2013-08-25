//
//  Created by Björn Sållarp on 2009-06-14.
//  NO Copyright 2009 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//

#import <Foundation/Foundation.h>
#import	"CoreDataHelper.h"
#import "County.h"
#import "Province.h"
#import "City.h"

@interface LocationsParser : NSObject {
	NSMutableString *contentsOfCurrentProperty;
	NSManagedObjectContext *managedObjectContext;
	County *currentCounty;
	Province *currentProvince;
}

@property (retain, nonatomic) NSManagedObjectContext *managedObjectContext;

-(id) initWithContext: (NSManagedObjectContext *) managedObjContext;
-(BOOL)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;
-(void) emptyDataContext;
@end
