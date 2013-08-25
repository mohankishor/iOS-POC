//
//  MBDatabase.h
//  Media Browser
//
//  Created by Sandeep GS on 28/07/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class FMDatabase;

@interface MBDatabase : NSObject 
{
	FMDatabase					*mDatabase;
	NSString					*mDatabaseName;					// used for storing metadata info in a database
	NSString					*mDatabasePath;
}

	// Instance methods
- (void) initDatabase;
- (void) openDatabase;
- (void) startTransaction;
- (void) endTransaction;
- (void) resetDatabase;
- (void) insertPhotoInfoToDatabase:(NSMutableDictionary*)photoDetails;
- (id) executeSQLQuery:(NSString *)query;
@end
