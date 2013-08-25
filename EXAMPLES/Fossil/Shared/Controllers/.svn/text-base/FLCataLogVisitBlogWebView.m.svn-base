//
//  FLCataLogVisitBlogWebView.m
//  Fossil
//
//  Created by Arundhati Jaishetty on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCataLogVisitBlogWebView.h"


@implementation FLCataLogVisitBlogWebView

@synthesize webView = mWebView;
@synthesize urlAddress = mURLAddress;

- (CGFloat) viewHeight
{
	CGFloat height;
	
	if (FL_IS_IPAD)
	{
		height = FL_IPAD_HEIGHT;
	}
	else
	{
		height = FL_IPHONE_HEIGHT;
	}
	return height;
}

- (CGFloat) viewWidth
{
	CGFloat width;
	
	if (FL_IS_IPAD)
	{
		width = FL_IPAD_WIDTH;
	}
	else
	{
		width = FL_IPHONE_WIDTH;
	}
	return width;
}

- (id) initWithUrl: (NSString *) urlString
{
	if (self == [super init])
	{
		NSLog(@"init web View");
		self.urlAddress = urlString;
		mWebView.delegate=self;
	}
	return self;
}

-(void) toggleBars
{
	//doesnt toggle
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
	
	if (mProgressIndicator)
	{
		[mProgressIndicator release];
	}
	
	mProgressIndicator = [[FLProgressIndicator alloc] initWithFrame:self.view.frame isWatchList:NO];
	
	CGFloat width = [self viewWidth];
	CGFloat height = [self viewHeight];
	
	CGRect webViewRect = CGRectMake(0.0, 0.0, width, height);
	
	
	
	mWebView = [[UIWebView alloc] initWithFrame:webViewRect];	
	
	mWebView.delegate = self;
	mWebView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
	[self.view addSubview:mWebView];
	
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:[self.urlAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	mWebView.delegate=self;
	[mWebView loadRequest:requestObj];
	[mWebView setScalesPageToFit:YES];

	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	self.title = FL_WEB_TITLE;
}

- (void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];	
	
}

-(void) createNavigationLeftItem
{
	
	CGRect rect;
	if(FL_IS_IPAD)
	{
		mNavTopLeftImage = [UIImage imageNamed:@"button_back@2x.png"];
		rect = CGRectMake(0,0,60.0,34.0);
	}
	
	else
	{
		mNavTopLeftImage = [UIImage imageNamed:@"button_back.png"];
		rect = CGRectMake(0,0,40.0,25.0);
	}
	UIButton *customView=[[UIButton alloc] initWithFrame:rect];
	[customView	setBackgroundImage:mNavTopLeftImage forState:UIControlStateNormal];
	[customView addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *logo = [[UIBarButtonItem alloc] initWithCustomView:customView];
	self.navigationItem.leftBarButtonItem = logo;
	
	[customView release];
	[logo release];	
}

-(void) back
{
	[self forceHideBars];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSLog(@"webViewDidFinishLoad");
	
	[mProgressIndicator stop];
	[mProgressIndicator removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"webViewDidStartLoad%@",self.urlAddress);
	[self.view addSubview:mProgressIndicator];
	[mProgressIndicator start];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return ( interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidUnload
{
    [super viewDidUnload];
	// Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void) dealloc
{
	self.webView = nil;
	self.urlAddress = nil;
	[mProgressIndicator release];
    [super dealloc];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
	NSLog(@"%@",protectionSpace);
	return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NSLog(@"Challenge");
	NSLog(@"%@",challenge.protectionSpace.host);
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}


@end
