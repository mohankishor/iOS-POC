//
//  FLCatalogWebViewController.m
//  Fossil
//
//  Created by Ganesh Nayak on 22/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCatalogWebViewController.h"


@implementation FLCatalogWebViewController

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

// Implement loadView to create a view hierarchy programmatically, without using a nib.

/*
- (void) loadView
{

}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void) viewDidLoad
{
    [super viewDidLoad];
	
	NSLog(@"mURLAddress !!!!!!%@",mURLAddress);

	CGFloat width = [self viewWidth];
	CGFloat height = [self viewHeight];
	
	CGRect webViewRect = CGRectMake(0.0, 0.0, width, height);
	
	mWebView = [[UIWebView alloc] initWithFrame:webViewRect];	
	[self.view addSubview:mWebView];
	
	NSString *urlAddress = mURLAddress;
	
	//Create a URL object.
	NSURL *url = [NSURL URLWithString:urlAddress];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
	
	//Load the request in the UIWebView.
	[mWebView loadRequest:requestObj];
	
}

//- (void) viewWillAppear:(BOOL)animated
//{
//	[super viewWillAppear:animated];
//	
//	printf("szdvsadvsdv\n");
//
//}

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

- (void) viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void) dealloc
{
	self.webView = nil;
	self.urlAddress = nil;
	
    [super dealloc];
}


@end
