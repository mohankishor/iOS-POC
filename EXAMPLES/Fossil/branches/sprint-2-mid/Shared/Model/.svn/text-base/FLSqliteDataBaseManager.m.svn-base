//
//  FLSqliteDataBaseManager.m
//  Fossil
//
//  Created by Sanath on 08/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "FLSqliteDataBaseManager.h"
#import "FLProduct.h"

@interface  FLSqliteDataBaseManager ()

-(BOOL) isWatch:(int) productId;

@end

@implementation FLSqliteDataBaseManager

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"catalog" ofType:@"sqlite"];
		if (sqlite3_open([databasePath UTF8String], &mDatabaseObj) == SQLITE_OK) 
		{
			NSLog(@"database open");
		}
		else
		{
			NSLog(@"database did not opened");
		}
	}
	return self;
}

-(NSInteger) noOfPages
{
	NSInteger numberOfPages = 0;
	
	const char *sql = "SELECT COUNT(*) FROM page";
	
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
	{
		while (sqlite3_step(statement) == SQLITE_ROW) 
		{
			NSString *numberOfPagesString = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			numberOfPages = [numberOfPagesString intValue];
			[numberOfPagesString release];
		}
	}
	else 
	{
		NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
	}
	
	sqlite3_finalize(statement);
	
	return numberOfPages;
}

-(NSString *) pageImagePath:(NSInteger) pageNumber
{
	NSString *imagePath = nil;
	
	NSInteger numberOfPages = [self noOfPages];
	
	if (pageNumber <= numberOfPages && pageNumber >= 1) 
	{
		NSString *sqlStmt = [[NSString alloc] initWithFormat:@"SELECT image_url FROM image WHERE id = (SELECT image_id FROM page WHERE page_number = %i)",pageNumber];
		const char *sql = [sqlStmt UTF8String];
		[sqlStmt release];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
		{
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				imagePath = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			}
		}
		else 
		{
			NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
		}
		
		sqlite3_finalize(statement);
	}
	else 
	{
		NSLog(@"pageImagePath:invalid page number");
	}
	
	return imagePath;
}


-(NSInteger) pageImageId:(NSInteger) pageNumber
{
	NSInteger imageId = 0;
	
	NSInteger numberOfPages = [self noOfPages];
	
	if (pageNumber <= numberOfPages && pageNumber >= 1)
	{
		NSString *sqlStmt = [[NSString alloc] initWithFormat:@"SELECT image_id FROM page WHERE page_number = %i",pageNumber];
		const char *sql = [sqlStmt UTF8String];
		[sqlStmt release];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
		{
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				NSString *imageIdString = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				imageId = [imageIdString intValue];
				[imageIdString release];
			}
		}
		else 
		{
			NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
		}
		
		sqlite3_finalize(statement);
		
	}
	else 
	{
		NSLog(@"pageImageId:Invalid page number");
	}
	
	return imageId;
}


-(NSInteger) noOfProductsInPage:(NSInteger) pageNumber
{
	NSInteger numberOfProducts = 0;
	
	NSInteger numberOfPages = [self noOfPages];
	
	if (pageNumber <= numberOfPages && pageNumber >= 1) 
	{
		NSString *sqlStmt = [[NSString alloc] initWithFormat:@"SELECT COUNT(*) FROM page_product WHERE page_id = %i",pageNumber];
		const char *sql = [sqlStmt UTF8String];
		[sqlStmt release];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
		{
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				NSString *numberOfProductsString = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				numberOfProducts = [numberOfProductsString intValue];
				[numberOfProductsString release];
			}
		}
		else 
		{
			NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
		}
		
		sqlite3_finalize(statement);
	}
	else 
	{
		NSLog(@"noOfProductsInPage:Invalid page number");
	}
	
	return numberOfProducts;
}


-(FLProduct *) productInPage:(NSInteger) pageNumber withIndex:(NSInteger) index
{
	FLProduct *prodInPage = nil;
	
	NSInteger productNumber = [self noOfProductsInPage:pageNumber];
	
	if (index <= productNumber && index >= 1)
	{
		NSInteger previousProductNumber = 0;
		for (NSInteger totalPage = 1; totalPage < pageNumber; totalPage++) 
		{
			previousProductNumber += [self noOfProductsInPage:totalPage];
		}
		int productId = previousProductNumber + index;
		
		NSString *sqlStmt = [[NSString alloc] initWithFormat:@"SELECT product.title,product.price,product.product_url,product.sku,image.image_url FROM product,image WHERE product.id = %i and image.id = %i",productId,productId];
		const char *sql = [sqlStmt UTF8String];
		[sqlStmt release];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
		{
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				NSString *sku = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
				NSString *title = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSString *priceString = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				NSNumber *price = [[NSNumber alloc] initWithFloat:[priceString floatValue]];
				NSString *url = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
				NSString *imagePath = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
				BOOL watchPresent = [self isWatch:productId];
				if (prodInPage)
				{
					[prodInPage release];
				}
				prodInPage = [[FLProduct alloc] initWithTitle:title url:url price:price sku:sku imagepath:imagePath iswatch:watchPresent];
				[price release];
				[sku release];
				[title release];
				[priceString release];
				[url release];
				[imagePath release];
			}
		}
		else 
		{
			NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
		}
		
		sqlite3_finalize(statement);
	}
	else 
	{
		NSLog(@"productInPage:Index not found");
	}
	return [prodInPage autorelease];
}


-(BOOL) isWatch:(int) productId
{
	BOOL isPresent = NO;
	
	NSString *sqlStmt = [[NSString alloc] initWithFormat:@"select sku from watch where image_id=%i",productId];
	const char *sql = [sqlStmt UTF8String];
	[sqlStmt release];
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
	{
		while (sqlite3_step(statement) == SQLITE_ROW) 
		{
			isPresent = YES;
		}
	}
	else 
	{
		NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
	}
	
	sqlite3_finalize(statement);
	
	return isPresent;
}


-(NSInteger) noOfWatches
{
	NSInteger numberOfWatches = 0;
	
	const char *sql = "SELECT COUNT(*) FROM watch";
	
	sqlite3_stmt *statement;
	
	if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
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
		NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
	}
	
	sqlite3_finalize(statement);
	
	return numberOfWatches;
}



-(NSString *)watchImagePath:(NSInteger) index
{	
	NSLog(@"watchImagePath");

	NSString *imagePathForWatch = nil;
	
	NSInteger watchNumber = [self noOfWatches];
	
	if (index <= watchNumber  && index >= 1) 
	{
		NSLog(@"watcNumber %d",watchNumber);

		NSString *sqlStmt = [[NSString alloc] initWithFormat:@"select image_url from image where id  =  (select image_id from watch where id = %i)",index];
		const char *sql = [sqlStmt UTF8String];
		[sqlStmt release];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
		{
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				imagePathForWatch = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
			}
		}
		else 
		{
			NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
		}
		
		sqlite3_finalize(statement);
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
		NSString *sqlStmt = [[NSString alloc] initWithFormat:@"select watch.sku,image.image_url from watch,image where watch.id= %i and image.id = (select image_id from watch where id = %i)",index,index];
		const char *sql = [sqlStmt UTF8String];
		[sqlStmt release];
		
		sqlite3_stmt *statement;
		
		if (sqlite3_prepare_v2(mDatabaseObj, sql, -1, &statement, NULL) == SQLITE_OK) 
		{
			while (sqlite3_step(statement) == SQLITE_ROW) 
			{
				NSString *sku = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
				NSString *imagepath = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
				
				if (watchDetails)
				{
					[watchDetails release];
				}
				watchDetails = [[FLProduct alloc] initWithTitle:nil url:nil price:nil sku:sku imagepath:imagepath iswatch:YES];
				[sku release];
				[imagepath release];
			}
		}
		else 
		{
			NSLog(@"could not prepare statemnt: %s\n", sqlite3_errmsg(mDatabaseObj));
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
	sqlite3_close(mDatabaseObj);
	[super dealloc];
}

@end
