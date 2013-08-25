//
//  FLCatalogWebViewController.h
//  Fossil
//
//  Created by Ganesh Nayak on 22/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLBaseViewController.h"

@interface FLCatalogWebViewController : FLBaseViewController
{
	UIWebView	 *mWebView;
	NSString  *mURLAddress;
}


@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *urlAddress;

@end
