//
//  FLMovieViewController.m
//  Fossil
//
//  Created by Darshan on 29/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLMovieViewController.h"


@implementation FLMovieViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) 
	{
		mMoviePlayerController = [[MPMoviePlayerController alloc] init];
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;
	self.navigationController.toolbarHidden = YES;
	
	if (FL_IS_IPAD)
	{
		mMoviePlayerController.view.frame = CGRectMake(0, 0, 1024, 768);
	}
	else
	{
		mMoviePlayerController.view.frame = CGRectMake( 0, 0, 480, 320);
	}
	[self.view addSubview:mMoviePlayerController.view];
	
	NSString *moviePath = [[NSBundle mainBundle] pathForResource:@"Fossil_Catalog_Holiday-720p" ofType:@"mp4"];
	NSURL *movieURL  = [NSURL fileURLWithPath:moviePath];
	[mMoviePlayerController setContentURL:movieURL];
	mMoviePlayerController.controlStyle =  MPMovieControlStyleNone;
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(playBackDidFinish) 
												 name:MPMoviePlayerPlaybackDidFinishNotification 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(playBackDidFinish) 
												 name:@"appSentToBackGroundNotification" 
											   object:nil];
	[mMoviePlayerController prepareToPlay];
	[mMoviePlayerController play];
	[mMoviePlayerController setScalingMode:MPMovieScalingModeAspectFit];
}

- (void) touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
	NSSet *allTouches = [event allTouches];
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	if([touch tapCount]==1)
	{
		[self stopPlayback];
	}
}


-(void) stopPlayback
{
	[mMoviePlayerController stop];
	[self.navigationController popViewControllerAnimated:NO];
}

-(void) playBackDidFinish
{
	[self.navigationController popViewControllerAnimated:NO];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeRight)||(interfaceOrientation == UIInterfaceOrientationLandscapeLeft));
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mMoviePlayerController stop];
	[mMoviePlayerController release];
    [super dealloc];
}


@end
