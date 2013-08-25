//
//  DDataManager.h
//  DGeofence
//
//  Created by Darshan Sonde on 26/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DDataManager : NSObject

+ (DDataManager *) sharedInstance;

- (void)saveContext;
- (NSManagedObjectContext *) managedObjectContext;

-(void) removeAllCachedData;//deletes the sql file. use carefully

@end
