//
//  FLSqliteDataBaseManager.h
//  Fossil
//
//  Created by Sanath on 08/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "FLDataManagerProtocol.h"
#import <sqlite3.h>


@interface FLSqliteDataBaseManager : NSObject <FLDataManagerProtocol>
{
	
	sqlite3 *mDatabaseObj;
	int		mNumPages;//cache the number of pages for better perf
	int		mNumWatches;
	NSString *databaseName;
}
//---------------------
-(NSString*) watchImageId:(NSInteger) watchNumber;
-(id)initWithDb:(NSString*)dbname;
//----------------------
-(NSString *) pageImagePath:(NSInteger) pageNumber; 
-(NSInteger) pageImageId:(NSInteger) pageNumber;
-(NSInteger) noOfPages;
-(NSInteger) noOfProductsInPage:(NSInteger) pageNumber;
-(FLProduct *) productInPage:(NSInteger) pageNumber withIndex:(NSInteger) index;  
-(NSInteger) noOfWatches;
-(NSString *)watchImagePath:(NSInteger) index;  
-(FLProduct *)watchAtIndex:(NSInteger) index;
-(NSString *)productIdOfPage:(NSInteger) pageNumber withIndex:(NSInteger) pageIndex;
@end
