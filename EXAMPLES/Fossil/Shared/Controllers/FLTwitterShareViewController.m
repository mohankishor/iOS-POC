    //
//  FLTwitterShareViewController.m
//  Fossil
//
//  Created by Sanath on 13/10/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "FLTwitterShareViewController.h"
#import "XAuthTwitterEngine.h"
#import "UIAlertView+Helper.h"

#define MAX_CHAR_LENGTH 140

@implementation FLTwitterShareViewController

@synthesize twitterEngine = mTwitterEngine,tweetPassword = mTweetPassword,tweetUsername = mTweetUsername, product = mProduct;



-(id) initWithProduct:(FLProduct*) product
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	if (self = [super init]) 
	{
		self.product = product;
	}
	
	NSString *productUrl = self.product.productURL;
	NSString *encodedUrl = [productUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *completeUrl = [[NSString alloc] initWithFormat:@"http://tinyurl.com/api-create.php?url=%@",encodedUrl];
	NSURL *url = [[NSURL alloc] initWithString:completeUrl];
	[completeUrl release];
	NSError *error;
	
	mDataLink = [[NSString alloc] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
	
	XAuthTwitterEngine *twitterEngine = [[XAuthTwitterEngine alloc] initXAuthWithDelegate:self];
	self.twitterEngine = twitterEngine;
	[twitterEngine release];
	self.twitterEngine.consumerKey = kOAuthConsumerKey;
	self.twitterEngine.consumerSecret = kOAuthConsumerSecret;
	
	UIImageView *twitterLogo = [[UIImageView alloc] init];
	UIImageView *twitterSecondLogo = [[UIImageView alloc] init];
	
	mLogout = [[UIButton alloc] init];
	mTweetMessage = [[UITextView alloc] init];
	mTweetUsername = [[UITextField alloc]init];
	mTweetPassword = [[UITextField alloc]init];
	mUsernameLabel = [[UILabel alloc]init];
	mPasswordLabel = [[UILabel alloc] init];
	
	[mLogout setFrame:CGRectMake(200, 10, 50, 10)];
	[twitterSecondLogo setFrame:CGRectMake(10, 3, 32, 32)];

	if (FL_IS_IPAD)
	{
		//label = [[UILabel alloc] initWithFrame:CGRectMake(210, 95, 50, 20)];
		[mTweetMessage setFrame:CGRectMake(25, 30, 234, 65)];
		[mTweetUsername setFrame:CGRectMake(115, 50, 145, 25)];
		[mTweetPassword setFrame:CGRectMake(115, 85, 145, 25)];
		[mUsernameLabel setFrame:CGRectMake(5, 50, 100, 20)];
		[mPasswordLabel setFrame:CGRectMake(5, 85, 100, 20)];
		[twitterLogo setFrame:CGRectMake(35, 7, 38, 38)];
	}
	else
	{
		//label = [[UILabel alloc] initWithFrame:CGRectMake(210, 75, 50, 20)];
		[mTweetMessage setFrame:CGRectMake(25, 30, 234, 45)];
		[mTweetUsername setFrame:CGRectMake(115, 30, 145, 25)];
		[mTweetPassword setFrame:CGRectMake(115, 65, 145, 25)];
		[mUsernameLabel setFrame:CGRectMake(5, 32, 100, 20)];
		[mPasswordLabel setFrame:CGRectMake(5, 67, 100, 20)];
		[twitterLogo setFrame:CGRectMake(35, 0, 38, 38)];
	}
	
	[mLogout setBackgroundColor:[UIColor clearColor]];
	mLogout.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
	[mLogout setTitle:@"Log out" forState:UIControlStateNormal];
	[mLogout setShowsTouchWhenHighlighted:YES];
	[mLogout addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
	
	mTweetMessage.editable = YES;
	
	UIImageView *textBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fb_message_bg.png"]];
	
	if ([mDataLink isEqualToString:@"Error"]||mDataLink == nil)
	{
		mTweetMessage.text = [NSString stringWithFormat:@"Check out this %@ for $%d ! from fossil at http://www.fossil.com",
							  self.product.productTitle,
							  [self.product.productPrice intValue]];
	}
	else
	{
		mTweetMessage.text = [NSString stringWithFormat:@"Check out this %@ for $%d ! from fossil at %@",
							  self.product.productTitle,
							  [self.product.productPrice intValue],
							  mDataLink];
		
	}
		
	textBackground.frame = mTweetMessage.frame;
	
	mTweetPassword.secureTextEntry = YES;
	
	mUsernameLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	mPasswordLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	mUsernameLabel.textColor = [UIColor whiteColor];
	mPasswordLabel.textColor = [UIColor whiteColor];
	
	mTweetMessage.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
	
	mUsernameLabel.text = @"Username:";
	mPasswordLabel.text =@"Password:";
	mUsernameLabel.textAlignment = UITextAlignmentRight;
	mPasswordLabel.textAlignment = UITextAlignmentRight;
	
	
	mTweetUsername.borderStyle = UITextBorderStyleRoundedRect;
	mTweetPassword.borderStyle = UITextBorderStyleRoundedRect;
	
	mTweetMessage.delegate = self;
	mTweetUsername.delegate = self;
	mTweetPassword.delegate = self;
	
	mLoginAlert = [[UIAlertView alloc] initWithTitle:@"Login to Twitter" message:@"\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Log in",nil];
	
	[mLoginAlert addSubview:mTweetUsername];
	[mLoginAlert addSubview:mTweetPassword];
	[mLoginAlert addSubview:mUsernameLabel];
	[mLoginAlert addSubview:mPasswordLabel];
	twitterLogo.image = [UIImage imageNamed:@"Twitter_logo.png"];
	[mLoginAlert addSubview:twitterLogo];
	[twitterLogo release];
	
	//int maxCharlength = 140 - ([mTweetMessage.text length]);
//	label.text = [[NSString alloc] initWithFormat:@"%d",maxCharlength];
//	label.font = [UIFont fontWithName:@"Arial" size:12.0];
//	label.textAlignment = UITextAlignmentRight;
//	[label setTextColor:[UIColor whiteColor]];
//	[label setBackgroundColor:[UIColor clearColor]];
	
	
	mSendAlert = [[UIAlertView alloc] initWithTitle:nil message:@"\n\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Send",nil];
	[mSendAlert	addSubview:textBackground];
	[mSendAlert addSubview:mTweetMessage];
	[mSendAlert bringSubviewToFront:mTweetMessage];
	[mSendAlert addSubview:mLogout];
	//[mSendAlert addSubview:label];
	[textBackground release];
	
	if (FL_IS_IPAD)
	{
		CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0, 90);
		[mLoginAlert setTransform:moveUp];
		[mSendAlert setTransform:moveUp];
	}
	
	twitterSecondLogo.image = [UIImage imageNamed:@"twitter-logo-twit.png"];
	[mSendAlert addSubview:twitterSecondLogo];
	[twitterSecondLogo release];
	
	if ([self.twitterEngine isAuthorized] == YES)
	{
		[mSendAlert show];
	}
	else
	{
		[mLoginAlert show];
		[self.tweetUsername becomeFirstResponder];
	}
	[pool release];
	return self;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([mTweetUsername isFirstResponder])
	{
		[mTweetUsername resignFirstResponder];
		[mTweetPassword becomeFirstResponder];
	}
	else
	{
		[mTweetPassword resignFirstResponder];
		[mTweetUsername becomeFirstResponder];
	}

	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if (textView.text.length >= MAX_CHAR_LENGTH && range.length == 0)
	{
		return NO;
	}
	else
	{
		//NSLog(@"mTweetMessage--|%d|",[textView.text length]);
//		int maxCharlength = 140 - ([mTweetMessage.text length]-1);
//		NSLog(@"max--|%d|",maxCharlength);
//		NSString *maxlengthString = [[NSString alloc] initWithFormat:@"%d",maxCharlength];
//		label.text = maxlengthString;
//		[maxlengthString release];
		return YES;
	}
}

-(IBAction)logout:(id)sender
{
	[self.twitterEngine clearAccessToken];
	[NSUserDefaults resetStandardUserDefaults];
	
	self.tweetUsername.text = @"";
	self.tweetPassword.text = @"";

	[mSendAlert dismissWithClickedButtonIndex:0 animated:YES];
	[mLoginAlert show];
	
	if (FL_IS_IPAD)
	{
		CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0, 90);
		[mLoginAlert setTransform:moveUp];
	}
	
	[mTweetUsername becomeFirstResponder];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  
{  
	if (alertView == mLoginAlert)
	{
		NSString *title = [alertView buttonTitleAtIndex:buttonIndex];  
		
		if([title isEqualToString:@"Log in"])  
		{  
			NSString *username = @"";
			NSString *password = @"";
			username = self.tweetUsername.text;
			password = self.tweetPassword.text;
			[self.twitterEngine exchangeAccessTokenForUsername:username password:password];
			mLoginProgressAlert = [[UIAlertView alloc] initWithTitle:@"Logging in..." message:@"Please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
			UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			activityIndicator.center = CGPointMake(138, 90);
			[activityIndicator startAnimating];
			[mLoginProgressAlert addSubview:activityIndicator];	
			[activityIndicator release];
			[mLoginProgressAlert show];
		}
		else if([title isEqualToString:@"Cancel"])
		{
			[mLoginAlert dismissWithClickedButtonIndex:0 animated:YES];
			
			if (mSendAlert)
			{
				[mSendAlert dismissWithClickedButtonIndex:0 animated:YES];
			}
		}
	} 
	else if(alertView == mSendAlert)
	{
		NSString *title = [alertView buttonTitleAtIndex:buttonIndex];  
		
		if([title isEqualToString:@"Send"])  
		{  
			NSLog(@"send");
			mSendProgressAlert = [[UIAlertView alloc] initWithTitle:@"Sending..." message:@"Please wait..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
			UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			activityIndicator.center = CGPointMake(138, 90);
			[activityIndicator startAnimating];
			[mSendProgressAlert addSubview:activityIndicator];
			[activityIndicator release];
			[mSendProgressAlert show];
			NSString *tweetText = mTweetMessage.text;
			[self.twitterEngine sendUpdate:tweetText];
		} 
		
		else if([title isEqualToString:@"Cancel"])
		{
			[mSendAlert dismissWithClickedButtonIndex:0 animated:YES];
		}
	}
}


#pragma mark -
#pragma mark XAuthTwitterEngineDelegate methods

- (void) storeCachedTwitterXAuthAccessTokenString: (NSString *)tokenString forUsername:(NSString *)username
{	
	[[NSUserDefaults standardUserDefaults] setObject:tokenString forKey:kCachedXAuthAccessTokenStringKey];
	[mSendAlert show];
	[mLoginProgressAlert dismissWithClickedButtonIndex:0 animated:NO];

}

- (NSString *) cachedTwitterXAuthAccessTokenStringForUsername: (NSString *)username;
{
	NSString *accessTokenString = [[NSUserDefaults standardUserDefaults] objectForKey:kCachedXAuthAccessTokenStringKey];
	return accessTokenString;
}


- (void) twitterXAuthConnectionDidFailWithError: (NSError *)error;
{	
	UIAlertViewQuick(@"Authentication error", @"Please check your username and password and try again.", @"OK");
	[mLoginProgressAlert dismissWithClickedButtonIndex:0 animated:NO];

}


#pragma mark -
#pragma mark MGTwitterEngineDelegate methods

- (void)requestSucceeded:(NSString *)connectionIdentifier
{	
	UIAlertViewQuick(@"Tweet sent!", @"The tweet was successfully sent!", @"OK");
	[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];

}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error
{
	if ([[error domain] isEqualToString: @"HTTP"])
	{
		switch ([error code]) {
				
			case 401:
			{
				UIAlertViewQuick(@"Oops!", @"Your username and password could not be verified. Double check that you entered them correctly and try again.", @"OK");	
				[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];
				break;				
			}
				
			case 502:
			{
				UIAlertViewQuick(@"Fail whale!", @"Looks like Twitter is down or being updated. Please wait a few seconds and try again.", @"OK");	
				[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];
				break;				
			}
				
			case 503:
			{
				UIAlertViewQuick(@"Hold your taps!", @"Looks like Twitter is overloaded. Please wait a few seconds and try again.", @"OK");	
				[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];
				break;								
			}
			case 403:
				
				UIAlertViewQuick(@"Hold your taps!", @"Error! You may have already tweeted this!", @"OK");	
				[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];
				break;

			default:
			{
				NSString *errorMessage = [[NSString alloc] initWithFormat: @"%@", [error localizedDescription]];
				UIAlertViewQuick(@"Twitter error!", errorMessage, @"OK");	
				[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];
				[errorMessage release];
				break;				
			}
		}
		
	}
	else 
	{
		switch ([error code]) {
				
			case -1009:
			{
				UIAlertViewQuick(@"You're offline!", @"Sorry, it looks like you lost your Internet connection. Please reconnect and try again.", @"OK");	
				[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];
				break;				
			}
				
			case -1200:
			{
				UIAlertViewQuick(@"Secure connection failed", @"I couldn't connect to Twitter. This is most likely a temporary issue, please try again.", @"OK");	
				[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];
				break;								
			}
				
			default:
			{		
				NSString *errorMessage = [[NSString alloc] initWithFormat:@"%@ xx %d: %@", [error domain], [error code], [error localizedDescription]];
				UIAlertViewQuick(@"Network Error!", errorMessage , @"OK");
				[mSendProgressAlert dismissWithClickedButtonIndex:0 animated:NO];
				[errorMessage release];
			}
		}
	}
	
}


 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
 

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
}


- (void)dealloc
{
	self.twitterEngine = nil;
	self.tweetPassword = nil;
	self.tweetUsername =nil;
	[mUsernameLabel release];
	[mPasswordLabel release];
	[mTweetMessage release];
	[mSendProgressAlert release];
	[mLoginProgressAlert release];
	[mLoginAlert release];
	[mSendAlert release];
	[mDataLink release];
	[mLogout release];
    [super dealloc];
}

@end
