//
//  RDShareViewController.h
//  SampleProject
//
//  Created by Srinivas on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <MessageUI/MessageUI.h>
#import <CoreLocation/CoreLocation.h>
#import "Facebook.h"

@interface RDShareViewController : UIViewController <FBDialogDelegate>{
	NSString *initialTweetText;
	NSString *initialMailSubject;
	NSString *initalMailBody;
}

@property (strong, nonatomic) NSString *initialTweetText;
@property (strong, nonatomic) NSString *initialMailSubject;
@property (strong, nonatomic) NSString *initialMailBody;
@property (strong, nonatomic) Facebook *facebook;

- (IBAction)sendTweet:(id)sender;
- (IBAction)sendMail:(id)sender;
- (void)displayComposerSheet;
- (void)launchMailAppOnDevice;
- (IBAction)postOnFacebook:(id)sender;

@end
