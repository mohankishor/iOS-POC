//
//  MBDatabase.m
//  Media Browser
//
//  Created by Sandeep GS on 28/07/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBDatabase.h"
#import "FMDatabase.h"
#import "FMResultSet.h"


@implementation MBDatabase
- (id) init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}

- (void) initDatabase
{
	BOOL success;
	mDatabaseName = @"PhotoDatabase.db";
	NSString *dbPath = [NSString stringWithFormat:@"%@/Library/Application Support/Media Browser",NSHomeDirectory()];
	[[NSFileManager defaultManager] createDirectoryAtPath:dbPath withIntermediateDirectories:YES attributes:nil error:nil];	
	mDatabasePath = [[dbPath stringByAppendingPathComponent:mDatabaseName]retain];		
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
		// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:mDatabasePath];
	
		// If the database already exists then return without doing anything
	if(success) {
//		NSLog(@"Database exist");
//		return;	
	}
	
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mDatabaseName];
	[fileManager copyItemAtPath:databasePathFromApp toPath:mDatabasePath error:nil];	
	if(![[NSFileManager defaultManager] fileExistsAtPath:mDatabasePath]){
		NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mDatabaseName];
		[[NSFileManager defaultManager] copyItemAtPath:databasePathFromApp toPath:mDatabasePath error:nil];	
	}		
	mDatabase = [[FMDatabase databaseWithPath:mDatabasePath]retain];
	if (![mDatabase open]) {
//		NSLog(@"Could not open database");
	}	
}

- (void) openDatabase
{
	[mDatabase open];		
}

- (void) startTransaction
{
	[mDatabase open];	
	[mDatabase beginTransaction];	
}

- (void) insertPhotoInfoToDatabase:(NSMutableDictionary*)photoDetails
{
	[mDatabase executeUpdate:@"insert into PHOTO_DETAILS values (?, ?, ?, ?, ?, ?)",
	 [photoDetails objectForKey:@"Filepath"],
	 [photoDetails objectForKey:@"Filename"],
	 [photoDetails objectForKey:@"Filetype"],
	 [photoDetails objectForKey:@"Size"],
	 [photoDetails objectForKey:@"CreationDate"],
	 [photoDetails objectForKey:@"ModifiedDate"],
	 nil];		
}

- (id) executeSQLQuery:(NSString *)query
{
	FMResultSet *result = [mDatabase executeQuery:query];

	NSString *filePath = @"";
	NSString *fileType = @"";
	NSString *fileName = @"";
	NSString *toPath = [NSString stringWithFormat:@"%@/Filtered Photos",NSTemporaryDirectory()];
	if (![[NSFileManager defaultManager] fileExistsAtPath:toPath]){
		[[NSFileManager defaultManager] createDirectoryAtPath:toPath withIntermediateDirectories:YES attributes:nil error:nil];		
	}	

	NSMutableArray	*mSearchResult = [[NSMutableArray alloc]init];
	
	while ([result next]) {
		NSMutableDictionary *photoDict = [[NSMutableDictionary alloc]init];
		filePath = [result stringForColumn:@"Filepath"];
		fileType = [result stringForColumn:@"Kind"];
		fileName = [result stringForColumn:@"Filename"];
		
		[photoDict setObject:filePath forKey:@"PhotoFullPath"];
		[photoDict setObject:fileName forKey:@"PhotoTitle"];
		[photoDict setObject:toPath forKey:@"PhotoDestPath"];
		[photoDict setObject:[filePath stringByDeletingLastPathComponent] forKey:@"PhotoRootPath"];
		[photoDict setObject:fileType forKey:@"PhotoType"];
		[mSearchResult addObject:photoDict];
		[photoDict release];
	}
	return [mSearchResult autorelease];
}

- (void) resetDatabase
{
	[mDatabase executeUpdate:@"delete from PHOTO_DETAILS"];	
}

- (void) endTransaction
{
	[mDatabase commit];
	[mDatabase close];
}

- (void) dealloc
{
	if (mDatabaseName) {
		[mDatabaseName release];
		mDatabaseName = nil;
	}
	if (mDatabasePath) {
		[mDatabasePath release];
		mDatabasePath = nil;
	}	
	mDatabase = nil;
	[super dealloc];
}

@end
