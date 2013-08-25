//
//  FLTwitterViewController.h
//  Fossil
//
//  Created by Darshan on 04/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLProduct.h"
#import "OAuthConsumer.h"
#import "FLTwitterWebViewController.h" //for protocol

@interface FLTwitterViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,FLHandlePin> {
	OAConsumer *mConsumer;
	OADataFetcher *mFetcher;
	OAToken *mRequestToken;
	OAToken *mAccessToken;
	FLProduct *mProduct;
	
	CGFloat mAnimatedDistance;
	IBOutlet UITextView *mMessage;
	IBOutlet UITextField *mPin;
	IBOutlet UIButton *mButton;
}

@property (nonatomic,retain) FLProduct *product;
@property (nonatomic,retain) OAConsumer* consumer;
@property (nonatomic,retain) OADataFetcher* fetcher;
@property (nonatomic,retain) OAToken *requestToken;
@property (nonatomic,retain) OAToken *accessToken;

-(id) initWithProduct:(FLProduct*) product;

-(IBAction) tweet;
-(IBAction) logout;

-(BOOL) haveAccessToken;
-(void) fetchRequestToken;
-(void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
-(void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

-(void) fetchAccessToken;
-(void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
-(void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

-(void)sendTweet;
-(void)receivedPin:(NSString *) pin;//delegate method
-(void)tweetTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
-(void)tweetTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

-(void)textFieldDidBeginEditing:(UITextField *)textField;
-(void)textFieldDidEndEditing:(UITextField *)textField;
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;

-(BOOL)textViewShouldEndEditing:(UITextView *)textView;
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView;
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

-(void) dismiss;
@end
