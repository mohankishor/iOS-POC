//
//  FLCatalogWebViewController.h
//  Fossil
//
//  Created by Ganesh Nayak on 22/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBaseViewController.h"
#import "FLProgressIndicator.h"

@interface FLCatalogWebViewController : FLBaseViewController <UIWebViewDelegate>
{
	UIWebView					  *mWebView;
	NSString					  *mURLAddress;
	FLProgressIndicator			  *mProgressIndicator;
	NSURLConnection				  *mConnection;
	NSURLRequest		          *mRequest;
	NSURL				          *mUrl;
	UIImage				          *mNavTopLeftImage;
	int							  mRetryCount;
}


@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *urlAddress;

- (id) initWithUrl: (NSString *) urlString;
-(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
-(void) back;
@end

