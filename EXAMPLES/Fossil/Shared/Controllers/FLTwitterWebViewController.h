//
//  DWebView.h
//  DTwitter
//
//  Created by Darshan on 01/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FLHandlePin<NSObject>
-(void) receivedPin:(NSString*)pin;
@end

@interface FLTwitterWebViewController : UIViewController<UIWebViewDelegate> {
	IBOutlet UIWebView *mWebView;
	NSURL *mUrl;
	id<FLHandlePin> mDelegate;
	UIWebViewNavigationType mLoadType;
}

-(id) initWithUrl:(NSURL*) url;
-(id) initWithUrl:(NSURL*) url andDelegate:(id) delegate;
-(NSString*) locatePin:(UIWebView*)webView;
@end
