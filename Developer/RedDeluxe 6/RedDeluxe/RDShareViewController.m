//
//  RDShareViewController.m
//  SampleProject
//
//  Created by Srinivas on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDAppDelegate.h"
#import "RDShareViewController.h"

@interface RDShareViewController ()
- (NSDictionary*)parseURLParams:(NSString *)query;
@end

@implementation RDShareViewController
@synthesize initialTweetText = _initialTweetText;
@synthesize initialMailSubject = _initialMailSubject;
@synthesize initialMailBody = _initialMailBody;
@synthesize facebook = _facebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionStateChanged:) name:FBSessionStateChangedNotification object:nil];
}


- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
	[self setFacebook:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark Send Tweet

- (IBAction)sendTweet:(id)sender {
	
    if ([TWTweetComposeViewController canSendTweet])
    {
        TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
        [tweetSheet setWantsFullScreenLayout:YES];
		[tweetSheet setInitialText:_initialTweetText];
        [self presentModalViewController:tweetSheet animated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops!!!" 
                                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup" 
                                                           delegate:self 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
	
}

#pragma mark -
#pragma mark Send Mail

-(IBAction)sendMail:(id)sender
{
	
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail])
		{
			[self displayComposerSheet];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!!!" 
															message:@"In order to shar via email, you must have atleast one mail account set up. Please set up an account via Settings and try again" 
														   delegate:nil 
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles: nil];
			[alert show];
		}
	}
	// For devices running on OS iOS 3.0 and older
	else
	{
		[self launchMailAppOnDevice];
	}
}

#pragma mark Compose Mail

-(void)displayComposerSheet 
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = (id)self;
	
	[picker setSubject:_initialMailSubject];
	[picker setMessageBody:_initialMailBody isHTML:YES];
	[self presentModalViewController:picker animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Mail Workaround 

-(void)launchMailAppOnDevice
{
	NSString *recipients = [NSString stringWithFormat:@"mailto:&subject=%@",_initialMailSubject];
	NSString *body = [NSString stringWithFormat:@"&body=%@!",_initialMailBody];
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark -
#pragma mark Post on Facebook wall

//Make a post to the facebook wall
- (IBAction)postOnFacebook:(id)sender {
    
    if (FBSession.activeSession.isOpen) {
        self.facebook = [[Facebook alloc] initWithAppId:FBSession.activeSession.appID andDelegate:nil];
        self.facebook.accessToken = FBSession.activeSession.accessToken;
        self.facebook.expirationDate = FBSession.activeSession.expirationDate;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"Red Deluxe", @"name",
                                       @"By American Lung Association", @"caption",
                                       @"The Red Deluxe app from the American Lung Association gives you the ability to see what your lungs are collecting anywhere in the United States.", @"description",
                                       //@"https://developers.facebook.com/apps/361296147279798", @"link",
                                       @"http://www.eltalearning.com/wp-content/uploads/2012/07/state-of-the-air.jpg", @"picture",
                                       nil];
        // Invoke the dialog
        [self.facebook dialog:@"feed" andParams:params andDelegate:self];
    }
    else {
        RDAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate openSessionWithAllowLoginUI:NO];
        if (!FBSession.activeSession.isOpen){
            [appDelegate openSessionWithAllowLoginUI:YES];
        }
    }
}

// Respond to notifications on change in state of the facebook session
- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        if (nil == self.facebook) {
            if(self == [[[self navigationController] viewControllers] lastObject]){
                [self postOnFacebook:nil];
            }
        }
    } 
    else {
        self.facebook = nil;  
    }
}
// Handle the publish feed call back
- (void)dialogCompleteWithUrl:(NSURL *)url {
    NSDictionary *params = [self parseURLParams:[url query]];
	if ([params valueForKey:@"post_id"]){
        NSString *msg = [NSString stringWithFormat:@"Your post has been succesfully shared.Post ID: %@", [params valueForKey:@"post_id"]];
        [[[UIAlertView alloc] initWithTitle:@"Result" message:msg delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil] show];
	}

}

// Parse the URL parameters passed back on completion of facebook post dialog
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

@end
