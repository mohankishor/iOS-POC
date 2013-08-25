//
//  FLTwitterShareViewController.h
//  Fossil
//
//  Created by Sanath on 13/10/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "XAuthTwitterEngineDelegate.h"
#import "OAToken.h"
#import "FLProduct.h"

#define kOAuthConsumerKey		@"bfx5RrVLcJoRbYFPNVZyw"		// Replace these with bfx5RrVLcJoRbYFPNVZyw
#define	kOAuthConsumerSecret	@"SQcrT7UNbrY7NqL1NkZQJRLIBSdX57yGfyjoxMYRoQ"		// and consumer secret with SQcrT7UNbrY7NqL1NkZQJRLIBSdX57yGfyjoxMYRoQ 

#define kCachedXAuthAccessTokenStringKey	@"cachedXAuthAccessTokenKey"

@class XAuthTwitterEngine;

@interface FLTwitterShareViewController: UIViewController<XAuthTwitterEngineDelegate,UITextFieldDelegate, UITextViewDelegate,UIAlertViewDelegate>
{
	XAuthTwitterEngine				*mTwitterEngine;
	UITextView						*mTweetMessage;
	UITextField						*mTweetPassword;
	UITextField						*mTweetUsername;
	UILabel							*mUsernameLabel;
	UILabel							*mPasswordLabel;
	UIButton						*mLogout;
	UIAlertView						*mLoginAlert;
	UIAlertView						*mSendAlert;
	FLProduct						*mProduct;
	NSString						*mDataLink;
	UIAlertView						*mLoginProgressAlert;
	UIAlertView						*mSendProgressAlert;
	UILabel							*label;
	int maxCharlength;
}


@property (nonatomic, retain) UITextField *tweetPassword, *tweetUsername;
@property (nonatomic, retain) XAuthTwitterEngine *twitterEngine;
@property (nonatomic,retain) FLProduct *product;

@end
