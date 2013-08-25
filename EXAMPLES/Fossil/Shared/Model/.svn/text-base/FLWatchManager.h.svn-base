//
//  FLSqliteDataBaseManager.h
//  Fossil
//
//  Created by Sanath on 08/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "FLProduct.h"

@interface FLWatchManager : NSObject 
{
	sqlite3 *mDb;
	sqlite3 *mWatchDb;
	int 	mNumFirstDbWatches;
	int		mNumWatches;
}
-(id)initWithDb:(NSString*)dbname andWatchDb:(NSString*)watchdb;

-(NSInteger) noOfWatches;
-(NSString *)watchImagePath:(NSInteger) index;  
-(FLProduct *)watchAtIndex:(NSInteger) index;
@end
