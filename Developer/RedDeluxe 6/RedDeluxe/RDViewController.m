//
//  RDViewController.m
//  RedDeluxe
//
//  Created by Pradeep Rajkumar on 27/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RDViewController.h"
@implementation RDViewController
{
    UIImageView *splashView;
}

@synthesize shareTheApp;
@synthesize getInformedViewController;
@synthesize speakUpViewController;
@synthesize infoViewController;
@synthesize airQualityAlertsViewController;
@synthesize shareButtonsView;
@synthesize shareTheAppBackGroundView;
@synthesize mainBackgroundView;
@synthesize closeModelShareView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	// Blank Comment 
}

- (UIImage *)makeImageOfSize:(CGSize)size withImage:(UIImage *)image
{
    //Image Compresser Code
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    if(newThumbnail == nil)
    { 
        NSLog(@"could not scale image");
    }
    return newThumbnail;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:208/255.0 green:26/255.0 blue:44/255.0 alpha:0.5];
    [self.navigationController setNavigationBarHidden:YES];
    
}


- (void)viewDidUnload
{
    [self setShareTheApp:nil];
    [self setMainBackgroundView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)presentInfo:(id)sender 
{
    [self.navigationController.navigationBar setHidden:NO];
}

- (IBAction)todaysAirQuality:(id)sender {
    [self.navigationController.navigationBar setHidden:NO];
}

- (IBAction)getInformed:(id)sender {
        [self.navigationController.navigationBar setHidden:NO]; 
}

- (IBAction)speakUp:(id)sender {
        [self.navigationController.navigationBar setHidden:NO];
}

- (IBAction)donate:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.lung.org/donate/"];
    
    if (![[UIApplication sharedApplication] openURL:url])
        
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}
- (IBAction)shareTheAppFromIcon:(id)sender {
    self.shareTheAppBackGroundView.alpha = 0.65;
    self.shareTheAppBackGroundView.opaque = NO;
    self.shareTheAppBackGroundView.backgroundColor = [UIColor blackColor];
    [self.view bringSubviewToFront:shareTheAppBackGroundView];
    [self.view bringSubviewToFront:shareButtonsView];
    [self.view bringSubviewToFront:closeModelShareView];

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
- (IBAction)closeShareView:(id)sender {
    [self.view bringSubviewToFront:mainBackgroundView];
    [self.view bringSubviewToFront:shareTheApp];
}
@end
