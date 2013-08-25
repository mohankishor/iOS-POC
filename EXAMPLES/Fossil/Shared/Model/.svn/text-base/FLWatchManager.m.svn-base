//
//  FLSqliteDataBaseManager.m
//  Fossil
//
//  Created by Sanath on 08/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "FLWatchManager.h"
#import "FLProduct.h"

@interface  FLWatchManager ()

-(BOOL) isWatch:(int) productId;

@end

@implementation FLWatchManager

-(id)initWithDb:(NSString*)dbname andWatchDb:(NSString*) watchdb
{
	self = [super init];

	if (self != nil) 
	{
		NSString *databasePath = [[NSBundle mainBundle] pathForResource:dbname ofType:@"sqlite"];
		if (sqlite3_open([databasePath UTF8String], &mDb) == SQLITE_OK) 
		{
			NSLog(@"first database open");
		}
		else
		{
			NSLog(@"database did not opened");
		}
		databasePath = [[NSBundle mainBundle] pathForResource:watchdb ofType:@"sqlite"];
		if (sqlite3_open([databasePath UTF8String], &mWatchDb) == SQLITE_OK) 
		{
			NSLog(@"watch database open");
		}
		else
		{
			NSLog(@"watch database did not opened");
		}
	}
	return self;
}



-(NSInteger) noOfWatches
{
	if(mNumWatches)
	{
		return mNumWatches;
	}
	NSInteger numberOfWatches = 0;
	
	const char *sql = "SELECT COUNT(*) FROM watch";
	
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(mDb, sql, -1, &statement, NULL) == SQLITE_OK) 
	{
		while (sqlite3_step(statement) == SQLITE_ROW) 
		{
			NSString *numberOfWatchesString = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			numberOfWatches = [numberOfWatchesString intValue];
			[numberOfWatchesString release];
		}
	}
	else 
	{
		NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDb));
	}
	
	sqlite3_finalize(statement);
	
	mNumWatches = numberOfWatches;
	mNumFirstDbWatches = numberOfWatches;

	if(sqlite3_prepare_v2(mWatchDb, sql, -1, &statement, NULL) == SQLITE_OK)
	{
		while(sqlite3_step(statement) == SQLITE_ROW)
		{
			NSString *numberOfWatchesString = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			numberOfWatches = [numberOfWatchesString intValue];
			[numberOfWatchesString release];
		}
	}
	else
	{
		NSLog(@"could not prepare watch statment:%s\n",sqlite3_errmsg(mWatchDb));
		numberOfWatches = 0;
	}
	mNumWatches += numberOfWatches;
	return mNumWatches;
}



-(NSString *) watchImagePath:(NSInteger) index
{	
	NSLog(@"watchImagePath");
	
	NSString *imagePathForWatch = nil;
	
	NSInteger watchNumber = [self noOfWatches];
	
	if (index >= 1) 
	{
		if(index <= mNumFirstDbWatches)
		{
			NSLog(@"watcNumber %d",watchNumber);
			
			NSString *sqlStmt = [[NSString alloc] initWithFormat:@"select image_url from image where id  =  (select image_id from watch where id = %i)",index];
			const char *sql = [sqlStmt UTF8String];
			[sqlStmt release];
			
			sqlite3_stmt *statement;
			
			if (sqlite3_prepare_v2(mDb, sql, -1, &statement, NULL) == SQLITE_OK) 
			{
				while (sqlite3_step(statement) == SQLITE_ROW) 
				{
					imagePathForWatch = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				}
			}
			else 
			{
				NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDb));
			}
			
			sqlite3_finalize(statement);
		}
		else if(index <= watchNumber)
		{
			//check in the watch db
			NSLog(@"watcNumber %d",watchNumber);
			index -= mNumFirstDbWatches;
			
			NSString *sqlStmt = [[NSString alloc] initWithFormat:@"select image_url from image where id  =  (select image_id from watch where id = %i)",index];
			const char *sql = [sqlStmt UTF8String];
			[sqlStmt release];
			
			sqlite3_stmt *statement;
			
			if (sqlite3_prepare_v2(mWatchDb, sql, -1, &statement, NULL) == SQLITE_OK) 
			{
				while (sqlite3_step(statement) == SQLITE_ROW) 
				{
					imagePathForWatch = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				}
			}
			else 
			{
				NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mWatchDb));
			}
			
			sqlite3_finalize(statement);
		}
	}
	else 
	{
		NSLog(@"watchImagePath:index not found");
	}
	NSLog(@"image path :%@",imagePathForWatch);
	
	return imagePathForWatch;
	
}


-(FLProduct *)watchAtIndex:(NSInteger) index
{
	FLProduct *watchDetails = nil;
	
	NSInteger watchNumber = [self noOfWatches];
	
	if (index <= watchNumber  && index >= 1) 
	{
		sqlite3 *databaseObj;
		if(index > mNumFirstDbWatches)
		{
			index -= mNumFirstDbWatches;
			databaseObj = mWatchDb;
		}else
		{
			databaseObj = mDb;
		}

		NSString *sqlStmt = [[NSString alloc] initWithFormat:@"select watch.sku,image.image_url,product.title,product.product_url from watch,image,product where watch.id= %i and image.id = (select image_id from watch where id = %i) and product.id = (select image_id from watch where id = %i)",index,index,index];
		const char *sql = [sqlStmt UTF8String];
		[sqlStmt release];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(databaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
		{
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				NSString *sku = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSString *imagePath = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				NSString *watchTitle = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				NSString *watchUrlSuffix = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				NSString *watchUrl=nil;
				if(FL_IS_IPAD)
				{
					watchUrl=[[NSString alloc] initWithFormat:@"http://www.fossil.com%@",watchUrlSuffix];
				} 
				else
				{
					watchUrl=[[NSString alloc] initWithFormat:@"http://m.fossil.com/mt/www.fossil.com%@",watchUrlSuffix];
				}
				if (watchDetails)
				{
					[watchDetails release];
				}
				watchDetails = [[FLProduct alloc] initWithTitle:watchTitle url:watchUrl price:nil sku:sku imagepath:imagePath iswatch:YES];
				[sku release];
				[imagePath release];
				[watchTitle release];
				[watchUrl release];
				[watchUrlSuffix release];
			}
		}
		else 
		{
			NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(databaseObj));
		}
		
		sqlite3_finalize(statement);
	}
	else 
	{
		NSLog(@"watchAtIndex:index not found");
	}
	
	return [watchDetails autorelease];	
}


- (void) dealloc
{
	sqlite3_close(mDb);
	sqlite3_close(mWatchDb);
	[super dealloc];
}

@end
