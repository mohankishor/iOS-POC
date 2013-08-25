//
//  TFViewController.h
//  TwitFrog
//
//  Created by test on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeTweet.h"
#import "Accounts/ACAccount.h"
#import "Accounts/ACAccountStore.h"
#import "Accounts/ACAccountType.h"
#import "TweetDescription.h"
#import "EGORefreshTableHeaderView.h"
#import "Tweets.h"
@interface TFViewController : UIViewController<EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *dataSource;
   UITableView *tableView;
    __weak UIActivityIndicatorView *_activityIndicatorView;
    EGORefreshTableHeaderView *_refreshHeaderView;
	BOOL _reloading;
    NSManagedObjectContext *managedObjectContext;
	NSMutableArray *eventArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isInternetConnected;
@property (weak, nonatomic) IBOutlet UIButton *composeTweetButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong)NSMutableArray *dataSource;
- (IBAction)composeTweet:(UIButton *)sender;
- (IBAction)requestTimeLine:(id)sender;
- (IBAction)requestMentions:(id)sender;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;
- (IBAction)fetchOfflineTweets:(UIButton *)sender;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *eventArray;
@property NSInteger tweetCount;
@end
