//
//  ComposeTweet.m
//  TwitFrog
//
//  Created by test on 07/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ComposeTweet.h"

@implementation ComposeTweet
@synthesize composeTweetTextView;
@synthesize userName = _userName;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Compose Tweets";
    if (_userName) {
        self.composeTweetTextView.text = [NSString stringWithFormat:@"%@%@",@"@",_userName];
    }
    self.composeTweetTextView.delegate = self;
   // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setComposeTweetTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
   return (UIInterfaceOrientationLandscapeLeft == interfaceOrientation);
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
        [textView resignFirstResponder];
    return YES;
}

- (IBAction)composeTweet:(UIButton *)sender {
    if([TWTweetComposeViewController canSendTweet])
    {
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
            if(granted == YES)
            {
                NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
                if ([arrayOfAccounts count] > 0) {
                    
                    ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
                    TWRequest *postRequest = [[TWRequest alloc] initWithURL:([NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]) parameters:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:self.composeTweetTextView.text,nil] forKeys:[NSArray arrayWithObjects:@"",nil]] requestMethod:TWRequestMethodPOST];
                    [postRequest setAccount:acct];
                    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                        NSLog(@"Twitter Response, Http response %i", [urlResponse statusCode]);
                    }];
                }
            }
        }];    
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
