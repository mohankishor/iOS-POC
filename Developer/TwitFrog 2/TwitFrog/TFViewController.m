//
//  TFViewController.m
//  TwitFrog
//
//  Created by test on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TFViewController.h"

@implementation TFViewController
@synthesize tableView = _tableView;
@synthesize composeTweetButton,managedObjectContext,eventArray;
@synthesize activityIndicatorView,dataSource = _dataSource;
@synthesize tweetCount = _tweetCount,isInternetConnected = _isInternetConnected;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"TwitFrog";
    _tableView.dataSource = self;
    _tableView.delegate = self;
    id appDelegate = (id)[[UIApplication sharedApplication] delegate]; 
    self.managedObjectContext = [appDelegate managedObjectContext];
    [_tableView setHidden:YES];
    [self.activityIndicatorView startAnimating];
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request permission from the user to access the available Twitter accounts
    [store requestAccessToAccountsWithType:twitterAccountType
                     withCompletionHandler:^(BOOL granted, NSError *error) {
                         if (!granted) {
                             // The user rejected your request 
                             NSLog(@"User rejected access to the account.");
                         } 
                         else {
                             // Grab the available accounts
                             NSArray *twitterAccounts = 
                             [store accountsWithAccountType:twitterAccountType];
                             
                             if ([twitterAccounts count] > 0) {
                                 // Use the first account for simplicity 
                                 ACAccount *account = [twitterAccounts objectAtIndex:0];
                                 
                                 
                                 // Now make an authenticated request to our endpoint
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                 [params setObject:@"1" forKey:@"include_entities"];
                                 
                                 //  The endpoint that we wish to call
                                 NSURL *url = 
                                 [NSURL 
                                  URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"];
                                 
                                 //  Build the request with our parameter 
                                 TWRequest *request = 
                                 [[TWRequest alloc] initWithURL:url 
                                                     parameters:params 
                                                  requestMethod:TWRequestMethodGET];
                                 // Attach the account object to this request
                                 [request setAccount:account];
                                 
                                 [request performRequestWithHandler:
                                  ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                      if (!responseData) {
                                          // inspect the contents of error 
                                          NSLog(@"%@", error);
                                          _isInternetConnected = NO;
                                          UIAlertView *internetNotConnectedAlert = [[UIAlertView alloc]initWithTitle:@"Internet Connectivity" message:@"You are not connected to the internet.Fetch tweets stored Offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                          [internetNotConnectedAlert show];
                                          dispatch_queue_t queue = dispatch_queue_create("com.mobiletuts.task", NULL);
                                          dispatch_queue_t main = dispatch_get_main_queue();
                                          
                                          dispatch_async(queue, ^{ 
                                              UIButton *fetchOfflineTweetsButton;
                                              [self fetchOfflineTweets:fetchOfflineTweetsButton];
                                              
                                              dispatch_async(main, ^{
                                                  [_tableView reloadData];
                                              });
                                          });
                                          
                                          dispatch_release(queue);
                                          
                                          
                                          
                                          [_tableView setHidden:NO];
                                          [self.activityIndicatorView stopAnimating];                                               } 
                                      else {
                                          NSError *jsonError;
                                          self.dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves                                        error:&jsonError];            
                                          if (self.dataSource) {
                                              [_tableView reloadData];
                                              _isInternetConnected = YES;
                                              [_tableView setHidden:NO];
                                              [self.activityIndicatorView stopAnimating];  
                                              dispatch_queue_t queue = dispatch_queue_create("com.mobiletuts.task", NULL);
                                              dispatch_queue_t main = dispatch_get_main_queue();
                                              
                                              dispatch_async(queue, ^{ 
                                                  for (NSInteger temporaryCount=0; temporaryCount<_tweetCount; temporaryCount++) {
                                                      NSDictionary *tweet = [self.dataSource objectAtIndex:temporaryCount];
                                                      Tweets *tweetOffline = (Tweets *)[NSEntityDescription insertNewObjectForEntityForName:@"Tweets" inManagedObjectContext:managedObjectContext];
                                                      [tweetOffline setUsername:[[tweet objectForKey:@"user"]objectForKey:@"screen_name"]];
                                                      [tweetOffline setTweetmessage:[tweet objectForKey:@"text"]];
                                                      NSURL *imageURL = [NSURL URLWithString:[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]];
                                                      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                                                      [tweetOffline setImage:imageData];
                                                      NSError *error = nil;
                                                      [managedObjectContext save:&error];
                                                  }                                                  
                                                  dispatch_async(main, ^{
                                                      
                                                  });
                                              });
                                              dispatch_release(queue);
                                          } 
                                          else { 
                                              // inspect the contents of jsonError
                                              NSLog(@"%@", jsonError);
                                          }
                                      }
                                      
                                  }];
                                 
                             } // if ([twitterAccounts count] > 0)
                             else
                             {
                                 // [self.dataSource addObject:@"Please provide your login credentials in the account settings of your device"];
                                 //[_tableView reloadData];
                                 UIAlertView *accountAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your twitter login Credentials at the account settings of your phone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                 [accountAlert show];
                                 [_tableView setHidden:NO];
                                 [self.activityIndicatorView stopAnimating];    
                             }
                             
                         } // if (granted) 
                     }];
    if (_refreshHeaderView == nil) {
        
        EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        view.delegate = self;
        [self.tableView addSubview:view];
        _refreshHeaderView = view;
    }
    
    //  update the last update date
    [_refreshHeaderView refreshLastUpdatedDate];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidUnload
{
    [self setComposeTweetButton:nil];
    [self setActivityIndicatorView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    _tweetCount = self.dataSource.count;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell Identifier";
    
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (!self.isInternetConnected) {
        Tweets *tw = [self.dataSource objectAtIndex:indexPath.row];
        cell.textLabel.text = [tw tweetmessage];
        cell.imageView.image = [UIImage imageWithData:[tw image]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
    NSDictionary *tweet = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [tweet objectForKey:@"text"];
    cell.imageView.image = [UIImage imageNamed:@"placeholder"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    
    dispatch_queue_t queue = dispatch_queue_create("com.mobiletuts.task", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        NSURL *imageURL = [NSURL URLWithString:[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(main, ^{
            cell.imageView.image = [UIImage imageWithData:imageData];
        });
    });
    
    dispatch_release(queue);
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isInternetConnected) {
        TweetDescription *tweetDescription = [[TweetDescription alloc]initWithNibName:@"TweetDescription" bundle:nil];
        
        Tweets *tweet = [self.dataSource objectAtIndex:indexPath.row];
        
        tweetDescription.tweetMessage = [tweet tweetmessage];
        
        tweetDescription.userName = [tweet username];
        
        tweetDescription.imageContents = [tweet image];
        
        [self.navigationController pushViewController:tweetDescription animated:YES];
    }
    else
    {
        TweetDescription *tweetDescription = [[TweetDescription alloc]initWithNibName:@"TweetDescription" bundle:nil];
        
        NSDictionary *tweet = [self.dataSource objectAtIndex:indexPath.row];
        
        tweetDescription.tweetMessage = [tweet objectForKey:@"text"];
        
        tweetDescription.userName = [[tweet objectForKey:@"user"]objectForKey:@"screen_name"];
        
        NSURL *imageURL = [NSURL URLWithString:[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]];
        
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        tweetDescription.imageContents = imageData;
        
        [self.navigationController pushViewController:tweetDescription animated:YES];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (UIInterfaceOrientationLandscapeLeft == interfaceOrientation);
}
- (IBAction)composeTweet:(UIButton *)sender 
{
    ComposeTweet *composeTweet = [[ComposeTweet alloc]initWithNibName:@"ComposeTweet" bundle:nil];
    [self.navigationController pushViewController:composeTweet animated:YES];
}

- (IBAction)requestTimeLine:(id)sender {
    [_tableView setHidden:YES];
    [self.activityIndicatorView startAnimating];
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request permission from the user to access the available Twitter accounts
    [store requestAccessToAccountsWithType:twitterAccountType
                     withCompletionHandler:^(BOOL granted, NSError *error) {
                         if (!granted) {
                             // The user rejected your request 
                             NSLog(@"User rejected access to the account.");
                         } 
                         else {
                             // Grab the available accounts
                             NSArray *twitterAccounts = 
                             [store accountsWithAccountType:twitterAccountType];
                             
                             if ([twitterAccounts count] > 0) {
                                 // Use the first account for simplicity 
                                 ACAccount *account = [twitterAccounts objectAtIndex:0];
                                 
                                 
                                 // Now make an authenticated request to our endpoint
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                 [params setObject:@"1" forKey:@"include_entities"];
                                 
                                 //  The endpoint that we wish to call
                                 NSURL *url = 
                                 [NSURL 
                                  URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"];
                                 
                                 //  Build the request with our parameter 
                                 TWRequest *request = 
                                 [[TWRequest alloc] initWithURL:url 
                                                     parameters:params 
                                                  requestMethod:TWRequestMethodGET];
                                 // Attach the account object to this request
                                 [request setAccount:account];
                                 
                                 [request performRequestWithHandler:
                                  ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                      if (!responseData) {
                                          // inspect the contents of error 
                                          NSLog(@"%@", error);
                                          _isInternetConnected = NO;
                                          UIAlertView *internetNotConnectedAlert = [[UIAlertView alloc]initWithTitle:@"Internet Connectivity" message:@"You are not connected to the internet.Fetch tweets stored Offline" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                          [internetNotConnectedAlert show];
                                          dispatch_queue_t queue = dispatch_queue_create("com.mobiletuts.task", NULL);
                                          dispatch_queue_t main = dispatch_get_main_queue();
                                          
                                          dispatch_async(queue, ^{ UIButton *fetchOfflineTweetsButton;
                                              [self fetchOfflineTweets:fetchOfflineTweetsButton];
                                               
                                              dispatch_async(main, ^{
                                                  [_tableView reloadData];
                                               });
                                          });
                                          
                                          dispatch_release(queue);
                                             

                                                 
                                          [_tableView setHidden:NO];
                                          [self.activityIndicatorView stopAnimating];   
                                    } 
                                      else {
                                          NSError *jsonError;
                                          self.dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves                                        error:&jsonError];            
                                          if (self.dataSource) {
                                              [_tableView reloadData];
                                              _isInternetConnected = YES;
                                              dispatch_queue_t queue = dispatch_queue_create("com.mobiletuts.task", NULL);
                                              dispatch_queue_t main = dispatch_get_main_queue();
                                              
                                              dispatch_async(queue, ^{ 
                                                  for (NSInteger temporaryCount=0; temporaryCount<_tweetCount; temporaryCount++) {
                                                      NSDictionary *tweet = [self.dataSource objectAtIndex:temporaryCount];
                                                      Tweets *tweetOffline = (Tweets *)[NSEntityDescription insertNewObjectForEntityForName:@"Tweets" inManagedObjectContext:managedObjectContext];
                                                      [tweetOffline setUsername:[[tweet objectForKey:@"user"]objectForKey:@"screen_name"]];
                                                      [tweetOffline setTweetmessage:[tweet objectForKey:@"text"]];
                                                      NSURL *imageURL = [NSURL URLWithString:[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"]];
                                                      NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
                                                      [tweetOffline setImage:imageData];
                                                      NSError *error = nil;
                                                      [managedObjectContext save:&error];
                                                  }                
                                                  dispatch_async(main, ^{
                                                      
                                                  });
                                              });
                                              dispatch_release(queue);
                                              [_tableView setHidden:NO];
                                              [self.activityIndicatorView stopAnimating];   
                                         } 
                                          else { 
                                              // inspect the contents of jsonError
                                              NSLog(@"%@", jsonError);
                                          }
                                      }
                                      
                                  }];
                                 
                             } // if ([twitterAccounts count] > 0)
                             else
                             {
                                 // [self.dataSource addObject:@"Please provide your login credentials in the account settings of your device"];
                                 //[_tableView reloadData];
                                 UIAlertView *accountAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your twitter login Credentials at the account settings of your phone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                 [accountAlert show];
                                 [_tableView setHidden:NO];
                                 [self.activityIndicatorView stopAnimating];  
                                 [self.activityIndicatorView setHidden:YES];
                             }
                             
                         } // if (granted) 
                     }];
    
}

- (IBAction)requestMentions:(id)sender {
    [_tableView setHidden:YES];
    [self.activityIndicatorView startAnimating];
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            if (accounts.count) {
                ACAccount *twitterAccount = [accounts objectAtIndex:0];
                
                NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/mentions.json"];
                
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                [parameters setObject:twitterAccount.username forKey:@"screen_name"];
                [parameters setObject:@"20" forKey:@"count"];
                [parameters setObject:@"1" forKey:@"include_entities"];
                TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:parameters requestMethod:TWRequestMethodGET];
                [request setAccount:twitterAccount];
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (responseData) {
                        NSError *error = nil;
                        self.dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&error];
                        if (self.dataSource) {
                            [_tableView reloadData];
                            [_tableView setHidden:NO];
                            [self.activityIndicatorView stopAnimating];
                            
                        } else {
                            NSLog(@"Error %@ with user info %@.", error, error.userInfo);
                        }
                    }
                }];
            }
            
        } else {
            NSLog(@"The user does not grant us permission to access its Twitter account(s).");
        }
    }];

}
#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    //  Request permission from the user to access the available Twitter accounts
    [store requestAccessToAccountsWithType:twitterAccountType
                     withCompletionHandler:^(BOOL granted, NSError *error) {
                         if (!granted) {
                             // The user rejected your request 
                             NSLog(@"User rejected access to the account.");
                         } 
                         else {
                             // Grab the available accounts
                             NSArray *twitterAccounts = 
                             [store accountsWithAccountType:twitterAccountType];
                             
                             if ([twitterAccounts count] > 0) {
                                 // Use the first account for simplicity 
                                 ACAccount *account = [twitterAccounts objectAtIndex:0];
                                 
                                 
                                 // Now make an authenticated request to our endpoint
                                 NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                                 [params setObject:@"1" forKey:@"include_entities"];
                                 
                                 //  The endpoint that we wish to call
                                 NSURL *url = 
                                 [NSURL 
                                  URLWithString:@"http://api.twitter.com/1/statuses/home_timeline.json"];
                                 
                                 //  Build the request with our parameter 
                                 TWRequest *request = 
                                 [[TWRequest alloc] initWithURL:url 
                                                     parameters:params 
                                                  requestMethod:TWRequestMethodGET];
                                 
                                 // Attach the account object to this request
                                 [request setAccount:account];
                                 
                                 [request performRequestWithHandler:
                                  ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                                      if (!responseData) {
                                          // inspect the contents of error 
                                          NSLog(@"%@", error);
                                      } 
                                      else {
                                          NSError *jsonError;
                                          self.dataSource = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves                                        error:&jsonError];            
                                          if (self.dataSource) {
                                               [_tableView reloadData];
                                            } 
                                          else { 
                                              // inspect the contents of jsonError
                                              NSLog(@"%@", jsonError);
                                          }
                                      }
                                  }];
                                 
                             } // if ([twitterAccounts count] > 0)
                             else
                             {
                                 // [self.dataSource addObject:@"Please provide your login credentials in the account settings of your device"];
                                 //[_tableView reloadData];
                                 UIAlertView *accountAlert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Please enter your twitter login Credentials at the account settings of your phone" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                 [accountAlert show];
                                 [_tableView setHidden:NO];
                                 [self.activityIndicatorView stopAnimating];    
                             }

                         } // if (granted) 
                     }];

	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	
	//  model should call this when its done loading
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}

- (IBAction)fetchOfflineTweets:(UIButton *)sender {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tweets" inManagedObjectContext:managedObjectContext];
	
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
	
	// Define how we will sort the records
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"username" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
	
	[request setSortDescriptors:sortDescriptors];
	
	// Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
	
	if (!mutableFetchResults) {
		// Handle the error.
		// This is a serious error and should advise the user to restart the application
	}
	
	// Save our fetched data to an array
	[self setEventArray: mutableFetchResults];
    self.dataSource = self.eventArray;
   // [self.activityIndicatorView stopAnimating];
   // [_tableView reloadData];
    
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
