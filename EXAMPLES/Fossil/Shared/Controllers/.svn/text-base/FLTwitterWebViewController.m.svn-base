//
//  DWebView.m
//  DTwitter
//
//  Created by Darshan on 01/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLTwitterWebViewController.h"


@implementation FLTwitterWebViewController

-(id) initWithUrl:(NSURL*) url
{
	return [self initWithUrl:url andDelegate:nil];
}
-(id) initWithUrl:(NSURL*) url andDelegate:(id) delegate
{
	self = [super initWithNibName:@"FLTwitterWebViewController" bundle:nil];
	if(self)
	{
		mUrl = [url retain];
		mDelegate = [delegate retain];
	}
	return self;
}
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	NSURLRequest *request = [NSURLRequest requestWithURL:mUrl];
	mWebView.dataDetectorTypes = UIDataDetectorTypeNone;
	mWebView.delegate = self;
	[mWebView loadRequest:request];
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mUrl release];
	[mDelegate release];
    [super dealloc];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	NSLog(@"navigation type = %d",navigationType);
	mLoadType = navigationType;
	return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	NSLog(@"ended finishload");
	if(mLoadType == UIWebViewNavigationTypeFormSubmitted || (mLoadType == UIWebViewNavigationTypeFormResubmitted))
	{
		NSString *pin=[self locatePin:webView];
		if(pin) {
			[mDelegate receivedPin:pin];
		}
	}
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
	NSLog(@"ended did start");
}

-(NSString*) locatePin:(UIWebView*)webView
{
NSString			*js = @"var d = document.getElementById('oauth-pin'); if (d == null) d = document.getElementById('oauth_pin'); if (d) d = d.innerHTML; if (d == null) {var r = new RegExp('\\\\s[0-9]+\\\\s'); d = r.exec(document.body.innerHTML); if (d.length > 0) d = d[0];} d.replace(/^\\s*/, '').replace(/\\s*$/, ''); d;";
NSString			*pin = [webView stringByEvaluatingJavaScriptFromString: js];

//	if (pin.length > 0) return pin;

NSString			*html = [webView stringByEvaluatingJavaScriptFromString: @"document.body.innerText"];

if (html.length == 0) return nil;

const char			*rawHTML = (const char *) [html UTF8String];
int					length = strlen(rawHTML), chunkLength = 0;

for (int i = 0; i < length; i++) {
	if (rawHTML[i] < '0' || rawHTML[i] > '9') {
		if (chunkLength == 7) {
			char				*buffer = (char *) malloc(chunkLength + 1);
			
			memmove(buffer, &rawHTML[i - chunkLength], chunkLength);
			buffer[chunkLength] = 0;
			
			pin = [NSString stringWithUTF8String: buffer];
			free(buffer);
			return pin;
		}
		chunkLength = 0;
	} else
		chunkLength++;
}

return nil;
}

@end
