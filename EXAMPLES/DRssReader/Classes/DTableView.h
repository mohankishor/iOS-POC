//
//  DTableView.h
//  DRssReader
//
//  Created by Darshan on 15/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DTableView : UIViewController <UITableViewDelegate>{
	IBOutlet UITableView *mTableView;
	NSManagedObjectContext *mContext;
	NSFetchedResultsController *mFetchedResultsController;
	NSPersistentStoreCoordinator *mCoordinator;
}

@property(nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic,retain) NSPersistentStoreCoordinator *coordinator;

@end
