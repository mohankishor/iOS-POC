//
//  FLCustomAlertView.m
//  Fossil
//
//  Created by Ganesh Nayak on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCustomAlertView.h"
#import "FLViewWithBorder.h"
#import "FLCatalogWebViewController.h"
#import "FLProduct.h"
#import "FLDataManager.h"
#import "FLWatchListScrollView.h"
#import "FLCameraViewController.h"


@implementation FLCustomAlertView
@synthesize delegate = mDelegate;
@synthesize navDelegate = mNavigationDelegate;


- (id) initWithText:(NSString *) text watchPath:(NSString *) path watchUrl:(NSString *) url
{
    if (self = [super init])
	{
		self.view.backgroundColor = [UIColor clearColor];
		CGRect customViewRect;
		if (FL_IS_IPAD)
		{
			self.view.frame = CGRectMake(0.0, 0.0, FL_IPAD_WIDTH, FL_IPAD_HEIGHT);
			customViewRect = CGRectMake(362.0, 294.0, 300.0, 140.0);

		}
		else
		{
			self.view.frame = CGRectMake(0.0, 0.0, FL_IPHONE_WIDTH, FL_IPHONE_HEIGHT);
			customViewRect = CGRectMake(120.0, 120.0, 236.0, 86.0);

		}
		
		mPathString = [[NSString alloc] initWithString:path];
		
		mTitleString = [[NSString alloc] initWithString:text];
		
		mUrlString = [[NSString alloc] initWithString:url];
		
		mCustomView = [[FLViewWithBorder alloc] initWithFrame:customViewRect];
				
		UIButton *moreDetails = [[UIButton alloc] init];
		
		if (FL_HAS_CAMERA)
		{
			[moreDetails setFrame:CGRectMake(20.0, 30.0, 90.0, 25.0)];
			
			[moreDetails setImage:[UIImage imageNamed:@"button_buyNow.png"] forState:UIControlStateNormal];
			
			[moreDetails addTarget:self action:@selector(moreDetails) forControlEvents:UIControlEventTouchUpInside];
			
			[mCustomView addSubview:moreDetails];
			
			
			UIButton *triItOn = [[UIButton alloc] initWithFrame:CGRectMake(124.0, 30.0, 90.0, 25.0)];
			
			[triItOn setImage:[UIImage imageNamed:@"button_tryon.png"] forState:UIControlStateNormal];
			
			[triItOn addTarget:self action:@selector(tryOnWatch) forControlEvents:UIControlEventTouchUpInside];
			
			[mCustomView addSubview:triItOn];
			
			[triItOn release];
		}
		else
		{
			if (FL_IS_IPAD)
			{
				[moreDetails setFrame:CGRectMake(105.0, 57.5, 90.0, 25.0)];
			}
			else
			{
				[moreDetails setFrame:CGRectMake(70.0, 30.0, 90.0, 25.0)];
			}
			
			[moreDetails setImage:[UIImage imageNamed:@"button_buyNow.png"] forState:UIControlStateNormal];
			
			[moreDetails addTarget:self action:@selector(moreDetails) forControlEvents:UIControlEventTouchUpInside];
			
			[mCustomView addSubview:moreDetails];

		}
		
		[moreDetails release];
		
	}
	return self;
}

- (void) moreDetails
{
	[self.delegate toggleBars];	
	[mCustomView removeFromSuperview];
//	FLCatalogWebViewController *webViewController = [[FLCatalogWebViewController alloc] initWithUrl:mUrlString];
//	[self.navDelegate pushViewController:webViewController animated:YES];
//
//	[webViewController release];
	NSString *urlAddress =  [mUrlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlAddress]];

}


-(void) tryOnWatch
{
	[mCustomView removeFromSuperview];
	
	if (mProgressIndicator)
	{
		[mProgressIndicator release];
	}
	mProgressIndicator = [[FLProgressIndicator alloc] initWithFrame:self.view.frame isWatchList:YES];
	[self.view addSubview:mProgressIndicator];
	[mProgressIndicator start];
	[self performSelector:@selector(showTryItOn) withObject:nil afterDelay:0.1];
	
}

- (void) showTryItOn
{
	NSMutableString *newWatchUrl = [[NSMutableString alloc] init];
	[newWatchUrl appendString:mPathString];
	[newWatchUrl appendString:@"?clipPathE=Path%201&fmt=png-alpha"];
	NSLog(@"append %@",newWatchUrl);
	NSData *urlData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:newWatchUrl]];
	[newWatchUrl release];
	
	if (urlData != nil)
	{
		FLCameraViewController *tryOnWatchListViewController = [[FLCameraViewController alloc] initWithData:urlData watchTitle:mTitleString];
		[urlData release];
		[self.navDelegate pushViewController:tryOnWatchListViewController animated:YES];
		[mProgressIndicator stop];
		[mProgressIndicator removeFromSuperview];
		[tryOnWatchListViewController release];
	}
	else
	{
		[mProgressIndicator stop];
		[mProgressIndicator removeFromSuperview];
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading the image" message:@"Please try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errorAlert show];
		[errorAlert release];
	}	
	[self.delegate toggleBars];	

}

- (void) dismiss
{
	[self.view removeFromSuperview];
}

- (void) initialDelayEnded
{
	[self.view addSubview:mCustomView];
    mCustomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    mCustomView.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:FL_ALERT_VIEW_ANIMATION_DELAY/1.5];
    [UIView setAnimationDelegate:self];
	mCustomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
}

- (void) dealloc
{
	[mTitleString release];
	[mPathString release];
	[mCustomView release];
    [super dealloc];
}

@end
