//
//  FLCustomAlertView.m
//  Fossil
//
//  Created by Ganesh Nayak on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCustomAlertView.h"
#import "FLViewWithBorder.h"

@implementation FLCustomAlertView

- (id) initWithText:(NSString *) text
{
    if (self = [super init])
	{
		self.view.backgroundColor = [UIColor clearColor];
		
		self.view.frame = CGRectMake(0.0, 0.0, FL_IPHONE_WIDTH, FL_IPHONE_HEIGHT);
		
		CGRect customViewRect = CGRectMake(120.0, 120.0, 236.0, 86.0);

		mCustomView = [[FLViewWithBorder alloc] initWithFrame:customViewRect];
		
		UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, 236.0, 25.0)];
		
		infoLabel.backgroundColor = [UIColor clearColor];
		
		[infoLabel setText:@"Allie White Chronograph"];
		
		[infoLabel setTextAlignment:UITextAlignmentCenter];
		
		[infoLabel setTextColor:[UIColor blackColor]];
		
		[mCustomView addSubview:infoLabel];
		
		[infoLabel release];
		
		
		UIButton *moreDetails = [[UIButton alloc] initWithFrame:CGRectMake(20.0, 45.0, 90.0, 25.0)];
		
		[moreDetails setImage:[UIImage imageNamed:@"button_buyNow.png"] forState:UIControlStateNormal];
		
		[moreDetails addTarget:self action:@selector(moreDetails) forControlEvents:UIControlEventTouchUpInside];
		
		[mCustomView addSubview:moreDetails];
		
		[moreDetails release];
		 
		UIButton *triItOn = [[UIButton alloc] initWithFrame:CGRectMake(124.0, 45.0, 90.0, 25.0)];

		[triItOn setImage:[UIImage imageNamed:@"button_tryon.png"] forState:UIControlStateNormal];

		[triItOn addTarget:self action:@selector(moreDetails) forControlEvents:UIControlEventTouchUpInside];

		[mCustomView addSubview:triItOn];
		
		[triItOn release];
	}
    return self;
}

- (void) moreDetails
{
	[self.view removeFromSuperview];
	NSLog(@"Hello");
}

- (void) initialDelayEnded
{
	[self.view addSubview:mCustomView];
    mCustomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    mCustomView.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:FL_ALERT_VIEW_ANIMATION_DELAY/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    mCustomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
}

- (void) bounce1AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:FL_ALERT_VIEW_ANIMATION_DELAY/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounce2AnimationStopped)];
    mCustomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void) bounce2AnimationStopped
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:FL_ALERT_VIEW_ANIMATION_DELAY/2];
    mCustomView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

//- (void) setAlertText:(NSString *) text
//{
//	alertTextLabel.text = text;
//}
//
//- (NSString *) alertText
//{
//	return alertTextLabel.text;
//}

- (void) dealloc
{
	[mCustomView release];
    [super dealloc];
}

@end
