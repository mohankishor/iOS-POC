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
	[mWebView setScalesPageToFit:YES];
	[self.view addSubview:mWebView];
	

	//Create a URL object.
	NSURL *url = [NSURL URLWithString:[self.urlAddress stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
	
	//URL Requst Object
	NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		
	//Load the request in the UIWebView.
	mWebView.delegate=self;
	[mWebView loadRequest:requestObj];
	
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"Error--%@",error);
	[mProgressIndicator stop];
	
	if (error != NULL) 
	{
		if(mRetryCount < 2)
		{
			[self alertView:nil clickedButtonAtIndex:0];
			mRetryCount++;
		}
        else
		{
			mRetryCount = 0;
			UIAlertView *errorAlert = [[UIAlertView alloc]
								   initWithTitle:@"Error"
								   message: @" Error Loading"
								   delegate:self
								   cancelButtonTitle:@"Retry "
								   
								   otherButtonTitles:@"Cancel",nil];
		
			[errorAlert show];
			[errorAlert release];
		}
	}
	[mProgressIndicator removeFromSuperview];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"webViewDidStartLoad%@",self.urlAddress);
	[self.view addSubview:mProgressIndicator];
	[mProgressIndicator start];
	
}

- (void) handleMenuActions:(int) index
{
	//if(!FL_HAS_CAMERA && (index>=3))
	//{
	//	index ++;//RANDMON num. required as "try on" method is dynamic.
	//}
	switch (index)
	{
			
		case 1:
		{
			FL_IF_CONNECTED()
			{
				NSString *urlAddressString =@"http://www.fossil.com/video?stop_mobi=yes";
				
				NSURL *url = [NSURL URLWithString:[urlAddressString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
				
				NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
				
				[mWebView loadRequest:requestObj];
				
			}
		}
			break;
			
		case 2:
		{
			FL_IF_CONNECTED()
			{
				NSString *urlAddressString=@"http://mobile.usablenet.com/mt/www.fossil.com/webapp/wcs/stores/servlet/StoreLocatorResultsView?storeId=12052&langId=-1&catalogId=10052&loc=10013&x=14&y=14";
				NSURL *url = [NSURL URLWithString:[urlAddressString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
				
				NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
				
				[mWebView loadRequest:requestObj];
				
			}
		}
			break;
			
		case 3:
		{
			[self.navigationController gotoCatalogWatchListViewController];
		}
				break;
			
		case  4:
		{
			FL_IF_CONNECTED() 
			{
				
				NSString *urlAddressString = @"http://blog.fossil.com";
				NSURL *url = [NSURL URLWithString:[urlAddressString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
				
				NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
				
				[mWebView loadRequest:requestObj];
				
			}
		}
			break;
		case  5:
		{
			FL_IF_CONNECTED()
			{
				NSString *urlAddressString;
				if(! FL_IS_IPAD)
				{
					urlAddressString = @"http://m.fossil.com";
				}
				else
				{
					urlAddressString = @"http://www.fossil.com";
				}
				NSURL *url = [NSURL URLWithString:[urlAddressString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
				
				NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
				
				[mWebView loadRequest:requestObj];
				
			}
		}
			break;
			
		default:
			[super handleMenuActions:index];
			break;
			
	}
	[mPopoverController dismissPopoverIfVisible];
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

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"Challenge");
	NSLog(@"%@",challenge.protectionSpace.host);
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
		//if ([trustedHosts containsObject:challenge.protectionSpace.host])
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	     [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
	//--------------------------------
	//NSLog(@"didReceiveAuthenticationChallenge %@ %zd", [[challenge protectionSpace] authenticationMethod], (ssize_t) [challenge previousFailureCount]);
//	
//    NSURLCredential *   credential = nil;
//    NSURLProtectionSpace *  protectionSpace;
//    SecTrustRef             trust;
//    int                        err;
//	
//    /* Setup */
//    protectionSpace = [challenge protectionSpace];
//    trust = [protectionSpace serverTrust];
//    credential = [NSURLCredential credentialForTrust:trust];
//	
//    /* Set up the array of certs we will authenticate against and create cred */
//    NSMutableArray * certs = [[NSMutableArray alloc] init];
//    credential = [NSURLCredential credentialForTrust:trust];
//	[certs addObject:self.urlAddress];
//    /* Build up the trust anchor using our root cert */    
//	
//    err = SecTrustSetAnchorCertificates(trust, (CFArrayRef) certs);
//	NSLog(@"Error:%d",err);
//    SecTrustResultType trustResult = 0;
//    if (err != noErr) {
//        err = SecTrustEvaluate(trust, &trustResult);
//		NSLog(@"Error1:%d",err);
//    }
//	
//    [certs release];
//	
//    BOOL trusted = (err == noErr) && ((trustResult ==  kSecTrustResultInvalid) || (trustResult == kSecTrustResultConfirm));
//	
//    // Return based on whether we decided to trust or not
//	
//    if (trusted)
//        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
//    else {
//        NSLog(@"Trust evaluation failed for service root certificate");
//        [[challenge sender] cancelAuthenticationChallenge:challenge];
//    }
	
	
}
//Uncomment  this delegate once you uncomment the alertview in  didFailLoadWithError delegate method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"button============================================%d",buttonIndex);
	
	if(buttonIndex==0)
	{
		NSLog(@"continue-------------------->%d",buttonIndex);
		NSLog(@"in delegate::::::::::::%@",self.urlAddress);
		NSString *urlAddress1 = self.urlAddress;		
		//Create a URL object.
		mUrl = [[NSURL alloc] initWithString:urlAddress1];
		
		//URL Requst Object
		mRequest = [[NSURLRequest alloc] initWithURL:mUrl];
		// Connect to url
		mConnection = [[NSURLConnection alloc] initWithRequest:mRequest delegate:self];
		
		//Load the request in the UIWebView.
		[mWebView loadRequest:mRequest];
		[mRequest release];
		[mUrl release];
		[mConnection release];
	}
	else if(buttonIndex==1)
	{
		[self back];
	}
}


	//	-(void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
//	{
//		[webData setLength: 0];
//	}
//	-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//	{
//		[webData appendData:data];
//	}
//	-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//	{
//		NSLog(@"ERROR with theConenction");
//		[connection release];
//		[webData release];
//	}
//	-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//	{
//		NSLog(@"DONE. Received Bytes: %d", [webData length]);
//		NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
//		NSLog(@"%@",theXML);
//		[theXML release];
//		
//		
//		[connection release];
//		[webData release];
//	}
	
@end
