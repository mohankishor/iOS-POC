//
//  TweetDescription.m
//  TwitFrog
//
//  Created by test on 08/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetDescription.h"

@implementation TweetDescription
@synthesize screenImageView;
@synthesize tweetTextView;
@synthesize tweetMessage = _tweetMessage;
@synthesize imageContents = _imageContents;
@synthesize userName = _userName;
@synthesize userNameLabel;
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
    self.title = @"Tweet Information";
    self.tweetTextView.text = _tweetMessage;
    self.screenImageView.image = [UIImage imageWithData:_imageContents];
    self.userNameLabel.text = _userName;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setTweetTextView:nil];
    [self setScreenImageView:nil];
    [self setUserNameLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (UIInterfaceOrientationLandscapeLeft == interfaceOrientation);
}

- (IBAction)composeTweet:(UIButton *)sender {
    ComposeTweet *composeTweet = [[ComposeTweet alloc]initWithNibName:@"ComposeTweet" bundle:nil];
    composeTweet.userName = _userName;
    [self.navigationController pushViewController:composeTweet animated:YES];
}
@end
