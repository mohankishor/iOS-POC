//
//  Created by Björn Sållarp on 2009-06-14.
//  NO Copyright 2009 MightyLittle Industries. NO rights reserved.
// 
//  Use this code any way you like. If you do like it, please
//  link to my blog and/or write a friendly comment. Thank you!
//
//  Read my blog @ http://blog.sallarp.com
//
#import "County.h"
#import	"CoreDataHelper.h"
#import "DetailsViewController.h"
#import "City.h"

@interface RootViewController : UITableViewController {
	NSManagedObjectContext *managedObjectContext;
	NSMutableArray *entityArray;
	NSString *entityName;
	NSPredicate *entitySearchPredicate;
}
-(void) loadLocations;

@property (nonatomic, retain) NSPredicate *entitySearchPredicate;
@property (nonatomic, retain) NSString *entityName;
@property (nonatomic, retain) NSMutableArray *entityArray;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
