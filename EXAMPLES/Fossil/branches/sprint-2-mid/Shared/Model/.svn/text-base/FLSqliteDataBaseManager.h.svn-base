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
}

-(NSString *) pageImagePath:(NSInteger) pageNumber; 
-(NSInteger) pageImageId:(NSInteger) pageNumber;
-(NSInteger) noOfPages;
-(NSInteger) noOfProductsInPage:(NSInteger) pageNumber;
-(FLProduct *) productInPage:(NSInteger) pageNumber withIndex:(NSInteger) index;  
-(NSInteger) noOfWatches;
-(NSString *)watchImagePath:(NSInteger) index;  
-(FLProduct *)watchAtIndex:(NSInteger) index;   
@end
