//
//  RDGetInformedViewController.m
//  RedDeluxe
//
//  Created by Pradeep Rajkumar on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDGetInformedViewController.h"

@implementation RDGetInformedViewController
@synthesize signUpView;
@synthesize webLoadingActivityIndicator;
@synthesize requestObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:208/255.0 green:26/255.0 blue:44/255.0 alpha:0.5];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Web View
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
	[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

	[self.webLoadingActivityIndicator stopAnimating];
	self.webLoadingActivityIndicator.hidden = YES;

}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	[[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
	[self.webLoadingActivityIndicator startAnimating];
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0,0,120,25)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,120,25)];  
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];    
    titleLabel.text = @"Get Informed";
    [titleView addSubview:titleLabel];
    UIBarButtonItem *titleBarItem = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.navigationItem.rightBarButtonItem = titleBarItem; 
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
	dispatch_queue_t queue = dispatch_queue_create("FetchingWebSiteContent", NULL);
    dispatch_queue_t main = dispatch_get_main_queue();
    dispatch_async(queue, ^{     
           dispatch_async(main, ^{
			   NSString *fullURL = @"http://www.lung.org/get-involved/my-lung/index.html";
			   NSURL *url = [NSURL URLWithString:fullURL];
			   requestObj = [NSURLRequest requestWithURL:url];
			   [signUpView loadRequest:requestObj];
				
        });
    });
    dispatch_release(queue);
	
}


- (void)viewDidUnload
{
    [self setSignUpView:nil];
    [self setWebLoadingActivityIndicator:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
