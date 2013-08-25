//
//  RDInfoViewController.m
//  RedDeluxe
//
//  Created by Pradeep Rajkumar on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDInfoViewController.h"

@implementation RDInfoViewController
@synthesize mainBGView;
@synthesize closeModelShareView;
@synthesize shareAppIcon;
@synthesize BackgroundImageView;
@synthesize shareTheAppView;
@synthesize shareButtonsView;
@synthesize shareTheAppBackGroundView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:208/255.0 green:26/255.0 blue:44/255.0 alpha:0.5];
}

 - (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO];
	self.navigationController.navigationBar.tintColor = [UIColor redColor];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	NSLog(@"%f",self.view.frame.origin.y);
//	[self.view setFrame:CGRectMake(0, -40, 320, 480)];
}

- (void)viewDidUnload
{
    [self setShareTheAppView:nil];
    [self setShareButtonsView:nil];
    [self setShareTheAppBackGroundView:nil];
    [self setCloseModelShareView:nil];
    [self setShareAppIcon:nil];
    [self setBackgroundImageView:nil];
    [self setMainBGView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)shareTheApp:(id)sender {
    self.shareTheAppBackGroundView.alpha = 0.55;
    self.shareTheAppBackGroundView.opaque = NO;
    self.shareTheAppBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:shareTheAppBackGroundView];
    [self.view addSubview:shareButtonsView];
    [self.view addSubview:closeModelShareView];
    [self.view bringSubviewToFront:closeModelShareView];

}
- (IBAction)shareTheAppFromIcon:(id)sender {
    self.shareTheAppBackGroundView.alpha = 0.55;
    self.shareTheAppBackGroundView.opaque = NO;
    self.shareTheAppBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:shareTheAppBackGroundView];
    [self.view bringSubviewToFront:shareButtonsView];
    [self.view bringSubviewToFront:closeModelShareView];
}

- (IBAction)closeShareView:(id)sender {
    [self.view bringSubviewToFront:mainBGView];
    [self.view bringSubviewToFront:shareAppIcon];
    [self.view bringSubviewToFront:shareTheAppView];
}
- (IBAction)sendTweet:(id)sender {
	super.initialTweetText = [[NSString alloc] initWithFormat:@"The Red Deluxe app gives you the ability to see what your lungs are collecting anywhere in US. To get air and health updates, go to APP_URL"];
    [super sendTweet:nil];
}

- (IBAction)postOnFacebook:(id)sender {
    [super postOnFacebook:nil];
}

- (IBAction)sendMail:(id)sender {
	super.initialMailSubject = [[NSString alloc] initWithFormat:@"How's the air you're breathing?"];
	super.initialMailBody = [[NSString alloc] initWithFormat:@"The Red Deluxe app from the American Lung Association gives you the ability to see what your lungs are collecting anywhere in the United States. To get air and health updates, go to APP_URL"];
    [super sendMail:nil];
}

@end
