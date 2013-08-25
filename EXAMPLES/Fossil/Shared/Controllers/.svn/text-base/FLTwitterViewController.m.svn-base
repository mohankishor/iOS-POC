    //
//  FLTwitterViewController.m
//  Fossil
//
//  Created by Darshan on 04/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLTwitterViewController.h"
#import "OAConsumer.h"
#import "OAMutableURLRequest.h"
#import "OAuthConsumer.h"
#import "FLTwitterWebViewController.h"

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation FLTwitterViewController

#define TW_CONSUMER_KEY @"07kqe8RIVZA5CI6Cgn1g"
#define TW_CONSUMER_SECRET @"IzRXRCJ17rQX2iAVncz892msjjX8nVdWB0KkDByHKY"
#define TW_REQUEST_TOKEN_URL @"http://api.twitter.com/oauth/request_token"
#define TW_AUTHORIZE_TOKEN_URL @"https://api.twitter.com/oauth/authorize"
#define TW_ACCESS_TOKEN_URL @"https://api.twitter.com/oauth/access_token"
#define TW_STATUS_UPDATE_URL @"http://api.twitter.com/1/statuses/update.json"

@synthesize consumer = mConsumer;
@synthesize fetcher = mFetcher;
@synthesize product = mProduct;

@synthesize requestToken = mRequestToken;
@synthesize accessToken = mAccessToken;


-(id) initWithProduct:(FLProduct*) product
{
	self = [super initWithNibName:@"FLTwitterViewController" bundle:nil];
	if(self) 
	{
		self.product = product;
	}
	return self;
}

-(void) dealloc
{
	self.consumer = nil;
	self.fetcher = nil;
	self.product = nil;
	self.accessToken = nil;
	self.requestToken = nil;

	
	[super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft||(interfaceOrientation==UIInterfaceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}


- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																		 target:self
																		 action:@selector(dismiss)];
	[self.navigationItem setRightBarButtonItem:right animated:YES];
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	[right release];
	mMessage.delegate = self;
	mMessage.text = [NSString stringWithFormat:@"check out this %@ for $%f! from fossil",
						self.product.productTitle,
						[self.product.productPrice floatValue],
						self.product.productURL];
	mPin.delegate = self;
	
	
	if(![self haveAccessToken])
	{
		mPin.hidden = NO;
	}
	
}

#pragma mark IBActions
-(IBAction) tweet
{
	if(mPin.hidden) 
	{
		//if pin is hidden then we have the access token in defaults, just tweet!
		[self sendTweet];
	}
	else
	{
		//need to start the oauth dance
		[self fetchRequestToken];
	}
}
-(IBAction) logout
{
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:[NSString stringWithFormat:@"OAUTH_%@_%@_KEY", FL_USER_DEFINES_PREFIX, FL_USER_DEFINES_PROVIDER]];
	[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:[NSString stringWithFormat:@"OAUTH_%@_%@_SECRET", FL_USER_DEFINES_PREFIX, FL_USER_DEFINES_PROVIDER]];
	[[NSUserDefaults standardUserDefaults] synchronize];
	mPin.hidden = NO;
}

#pragma mark -
#pragma mark request token methods

-(BOOL) haveAccessToken
{
	BOOL ret = NO;
	OAToken *token = [[OAToken alloc] initWithUserDefaultsUsingServiceProviderName:FL_USER_DEFINES_PROVIDER prefix:FL_USER_DEFINES_PREFIX];
	if(token) {
		self.accessToken = token;
		ret = YES;
	}
	[token release];
	return ret;
}

-(void) fetchRequestToken
{
	self.consumer = [[OAConsumer alloc] initWithKey:TW_CONSUMER_KEY
											 secret:TW_CONSUMER_SECRET];
	
    NSURL *url = [NSURL URLWithString:TW_REQUEST_TOKEN_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:self.consumer
                                                                      token:nil   // we don't have a Token yet
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
	
    [request setHTTPMethod:@"POST"];
	
    self.fetcher = [[OADataFetcher alloc] init];
	
    [self.fetcher fetchDataWithRequest:request
							  delegate:self
					 didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
					   didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
	[request release];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{	
	if (ticket.didSucceed) 
	{
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		self.requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		NSString *urlString = [NSString stringWithFormat:@"%@?oauth_token=%@",TW_AUTHORIZE_TOKEN_URL,self.requestToken.key];
		NSURL *url = [NSURL URLWithString:urlString];
		
		FLTwitterWebViewController *viewController= [[FLTwitterWebViewController alloc] initWithUrl:url andDelegate:self];
		[self.navigationController pushViewController:viewController animated:YES];
		[viewController release];
	}
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error 
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
													message:@"not able to connect to twitter!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

#pragma mark -
#pragma mark access token methods

-(void) fetchAccessToken
{	
	mRequestToken.pin = mPin.text;
	self.consumer = [[OAConsumer alloc] initWithKey:TW_CONSUMER_KEY
                                                    secret:TW_CONSUMER_SECRET];
	
    NSURL *url = [NSURL URLWithString:TW_ACCESS_TOKEN_URL];
	
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                   consumer:self.consumer
                                                                      token:self.requestToken  
                                                                      realm:nil   // our service provider doesn't specify a realm
                                                          signatureProvider:nil]; // use the default method, HMAC-SHA1
	
    [request setHTTPMethod:@"POST"];
	
    self.fetcher = [[OADataFetcher alloc] init];
	
    [self.fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                  didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
	[request release];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	if (ticket.didSucceed) 
	{
		NSString *responseBody = [[NSString alloc] initWithData:data
													   encoding:NSUTF8StringEncoding];
		self.accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
		
		[self.accessToken storeInUserDefaultsWithServiceProviderName:FL_USER_DEFINES_PROVIDER prefix:FL_USER_DEFINES_PREFIX];
		
		[self sendTweet];		
	}
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error 
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
													message:@"failed to authenticate with twitter!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}

#pragma mark -
#pragma mark tweet methods

-(void) sendTweet
{
	self.consumer = [[OAConsumer alloc] initWithKey:TW_CONSUMER_KEY
											 secret:TW_CONSUMER_SECRET];
	
	NSURL *url = [NSURL URLWithString:TW_STATUS_UPDATE_URL];
	
	OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
																   consumer:self.consumer
																	  token:self.accessToken
																	  realm:nil   // our service provider doesn't specify a realm
														  signatureProvider:nil]; // use the default method, HMAC-SHA1
	
	[request setHTTPMethod:@"POST"];
	
	NSString *message=[NSString stringWithFormat:@"status=%@",mMessage.text];
	[request setHTTPBody:[message dataUsingEncoding: NSUTF8StringEncoding]];
	
	self.fetcher = [[OADataFetcher alloc] init];
	
	[self.fetcher fetchDataWithRequest:request
						 delegate:self
				didFinishSelector:@selector(tweetTokenTicket:didFinishWithData:)
				  didFailSelector:@selector(tweetTokenTicket:didFailWithError:)];
	[request release];

}
-(void) receivedPin:(NSString *) pin
{
	mPin.text = pin;
	mPin.hidden = YES;
	[self.navigationController popToRootViewControllerAnimated:YES];
	[self fetchAccessToken];
}
- (void)tweetTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data 
{
	//TODO:process status from twitter to check if it failed.
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet Done"
													message:@"Status updated!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];

	NSLog(@"tweet done status from twitter= %@",[NSString stringWithUTF8String:[data bytes]]);
	[self dismiss];
}

- (void)tweetTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error 
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed"
													message:@"failed to tweet!"
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	[self dismiss];
	
}
	 
#pragma mark -
#pragma mark UITextFieldDelegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if(!FL_IS_IPAD)
	{
		CGRect textFieldRect =	[self.view.window convertRect:textField.bounds fromView:textField];
		CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
		
		CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
		CGFloat numerator =
		midline - viewRect.origin.y
		- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
		CGFloat denominator =
		(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
		* viewRect.size.height;
		CGFloat heightFraction = numerator / denominator;
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{
			heightFraction = 1.0;
		}
		mAnimatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
		
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y -= mAnimatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	}
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(!FL_IS_IPAD)
	{
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y += mAnimatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	}
	[textField resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark UITextViewDelegate methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if(!FL_IS_IPAD)
	{
		CGRect textFieldRect =
		[self.view.window convertRect:textView.bounds fromView:textView];
		CGRect viewRect =
		[self.view.window convertRect:self.view.bounds fromView:self.view];
		
		CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
		CGFloat numerator =
		midline - viewRect.origin.y
		- MINIMUM_SCROLL_FRACTION * viewRect.size.height;
		CGFloat denominator =
		(MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
		* viewRect.size.height;
		CGFloat heightFraction = numerator / denominator;
		if (heightFraction < 0.0)
		{
			heightFraction = 0.0;
		}
		else if (heightFraction > 1.0)
		{
			heightFraction = 1.0;
		}
		mAnimatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
		
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y -= mAnimatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	}
	return YES;
	
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	if(!FL_IS_IPAD)
	{
		CGRect viewFrame = self.view.frame;
		viewFrame.origin.y += mAnimatedDistance;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
		
		[self.view setFrame:viewFrame];
		
		[UIView commitAnimations];
	}
	return YES;
	
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (range.length==0) {
		if ([text isEqualToString:@"\n"]) {
			[textView resignFirstResponder];
			return NO;
		}
		if([textView.text length]>140) {
			return NO;
		}
	}
	
	return YES;
}

-(void) dismiss
{
	[self dismissModalViewControllerAnimated:YES];
}
@end