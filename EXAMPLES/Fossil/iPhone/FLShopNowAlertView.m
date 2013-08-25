//
//  FLShopNowAlertView.m
//  Fossil
//
//  Created by Arundhati Jaishetty on 20/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLShopNowAlertView.h"
#import "FLCatalogWebViewController.h"
#import "FLViewWithBorder.h"

@implementation FLShopNowAlertView

@synthesize delegate = mDelegate;
@synthesize navDelegate = mNavigationDelegate;


- (id) initWithText:(NSString *) text watchPath:(NSString *) path
{
    if (self = [super init])
	{
		self.view.backgroundColor = [UIColor clearColor];
		
		//self.view.frame = CGRectMake(120.0, 120.0, FL_IPHONE_WIDTH/4, FL_IPHONE_HEIGHT/4);
		if (mPathString)
		{
			[mPathString release];
		}
		
		mPathString = [[NSString alloc] initWithString:path];
		
		if (mTitleString)
		{
			[mTitleString release];
		}
		
		if (FL_IS_IPAD)
		{
			CGRect customViewRect_ipad = CGRectMake(FL_IPAD_WIDTH/2-170 ,FL_IPAD_HEIGHT/3, FL_IPAD_WIDTH/3, FL_IPAD_HEIGHT/5);
			//CGRect customViewRect = self.view.frame;
			
			//
			mTitleString = [[NSString alloc] initWithString:text];
			
			mCustomView = [[FLViewWithBorder alloc] initWithFrame:customViewRect_ipad];
			
			UIButton *moreDetails = [[UIButton alloc] initWithFrame:CGRectMake(customViewRect_ipad.size.width/2 - 45, customViewRect_ipad.size.height/2-25/2, 90.0, 25.0)];
			
			[moreDetails setImage:[UIImage imageNamed:@"shop_now@2x.png"] forState:UIControlStateNormal];
			
			[moreDetails addTarget:self action:@selector(moreDetails) forControlEvents:UIControlEventTouchUpInside];
			
			[mCustomView addSubview:moreDetails];
			
			[moreDetails release];

		}
		else
		{
			
			CGRect customViewRect_iPhone = CGRectMake(FL_IPHONE_WIDTH/3-10, FL_IPHONE_HEIGHT/3+10, 180.0, 80);
		//CGRect customViewRect = self.view.frame;
			mTitleString = [[NSString alloc] initWithString:text];
			
			mCustomView = [[FLViewWithBorder alloc] initWithFrame:customViewRect_iPhone];
		
			UIButton *moreDetails = [[UIButton alloc] initWithFrame:CGRectMake(customViewRect_iPhone.size.width/2 - 90/2, customViewRect_iPhone.size.height/2-25/2, 90.0, 25.0)];
		
			[moreDetails setImage:[UIImage imageNamed:@"shop_now.png"] forState:UIControlStateNormal];
		
			[moreDetails addTarget:self action:@selector(moreDetails) forControlEvents:UIControlEventTouchUpInside];
		
			[mCustomView addSubview:moreDetails];
		
			[moreDetails release];

		}
	}
    return self;
}

- (void) moreDetails
{
	[self.delegate showInfo];
}


- (void) dismiss
{
	[self.view removeFromSuperview];
}

- (void) initialDelayEnded
{
	[self.view addSubview:mCustomView];
	[mCustomView release];
    mCustomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    mCustomView.alpha = 1.0;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:FL_ALERT_VIEW_ANIMATION_DELAY/1.5];
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationDidStopSelector:@selector(bounce1AnimationStopped)];
    mCustomView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
}
-(void)dealloc
{
	[mCustomView release];
}
@end
