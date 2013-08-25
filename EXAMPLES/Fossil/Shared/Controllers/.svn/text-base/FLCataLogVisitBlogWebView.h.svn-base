//
//  FLCataLogVisitBlogWebView.h
//  Fossil
//
//  Created by Arundhati Jaishetty on 28/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FLBaseViewController.h"
#import "FLProgressIndicator.h"

@interface FLCataLogVisitBlogWebView : FLBaseViewController <UIWebViewDelegate>
{
	UIWebView					  *mWebView;
	NSString					  *mURLAddress;
	FLProgressIndicator			  *mProgressIndicator;
	NSURLConnection				  *mConnection;
	NSURLRequest		          *mRequest;
	NSURL				          *mUrl;
	UIImage				          *mNavTopLeftImage;
}


@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *urlAddress;

- (id) initWithUrl: (NSString *) urlString;
-(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
-(void) back;
@end
