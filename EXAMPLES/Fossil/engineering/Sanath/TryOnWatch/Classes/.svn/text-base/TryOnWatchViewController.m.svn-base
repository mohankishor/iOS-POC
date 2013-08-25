//
//  TryOnWatchViewController.m
//  TryOnWatch
//
//  Created by Sanath on 20/09/10.
//  Copyright Sourcebits Technologies Pvt Ltd 2010. All rights reserved.
//

#define IMAGE_HEIGHT 480
#define IMAGE_WIDTH 320

#import "TryOnWatchViewController.h"
@implementation TryOnWatchViewController

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {

	 UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainView.backgroundColor = [UIColor clearColor];
	self.view=mainView;
	[mainView release];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"Magic1" ofType:@"jpg"];
	bgImage = [[UIImage alloc] initWithContentsOfFile:path];
	UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	[bgImageView setImage:bgImage]; 
	[self.view addSubview:bgImageView];

	mImage = [[ImageOverlay alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	[self.view addSubview:mImage];

	rotateCount =1;
	
	UIView *toolbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 426, 320, 54)];
	toolbarView.backgroundColor = [UIColor lightGrayColor];
	
	mSaveAlert=[[CustomAlertView alloc]initWithFrame:CGRectMake(100, 200,10, 100)];
	mSaveAlert.delegate = self;
	
	mFinishAlert=[[CustomAlertView alloc]initWithFrame:CGRectMake(100, 200,10, 100)];
	mFinishAlert.delegate = self;
	
	UIImage *camera = [UIImage imageNamed:@"camera.png"];
	cameraView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,40,40)];
	[cameraView setImage:camera];
	
	UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];//initWithFrame:CGRectMake(250, 10, 30, 30)];
	[cameraButton setFrame:CGRectMake(180, 10, 40, 40)];
	[cameraButton addSubview:cameraView];
	[cameraButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
	
	UIImage *orientationImage = [UIImage imageNamed:@"orientation.png"];
	UIImageView *orientationView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,40,40)];
	[orientationView setBackgroundColor:[UIColor lightGrayColor]];
	[orientationView setImage:orientationImage];

	UIButton *orientationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[orientationButton setFrame:CGRectMake(100, 10, 40, 40)];
	[orientationButton setShowsTouchWhenHighlighted:YES];
	[orientationButton addSubview:orientationView];
	[orientationButton addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
	
	[toolbarView addSubview:orientationButton];
	[toolbarView addSubview:cameraButton];
	[mImage addSubview:toolbarView];
	[toolbarView release];
}

-(void) save:(id)sender
{
	[mSaveAlert setBackgroundColor:[UIColor grayColor] withStrokeColor:[UIColor clearColor]];
	[mSaveAlert setBackgroundColor:[UIColor grayColor] withStrokeColor:[UIColor clearColor]];
    [mSaveAlert addButtonWithTitle:@"Save to Photo Album " withFrame:CGRectMake(10, 50, 260, 40) andWithButtonIndex:1];
	[mSaveAlert addButtonWithTitle:@"Cancel " withFrame:CGRectMake(10, 110, 260, 40) andWithButtonIndex:0];
	[mSaveAlert show];
}

-(IBAction)savePhotos:(id)sender
{
	[mFinishAlert setBackgroundColor:[UIColor grayColor] withStrokeColor:[UIColor clearColor]];
	mFinishAlert.message=@"\n\nSaved to your Photo Album.\n  You can share with your friends \n by emailing from the Photo\n Album.";
	[mFinishAlert show];
}

-(IBAction)cancelPhotos:(id)sender
{
	[mSaveAlert setHidden:YES];
}

-(void) share:(id)sender
{
	NSLog(@"share..");
}
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo
{
}

-(IBAction)camera:(id)sender
{
}

-(void)rotate:(id)sender
{
	CGFloat pi = 3.14159/2;
	CGAffineTransform transform = CGAffineTransformMakeRotation(pi * rotateCount);
	
	mImage.imageView.transform = transform;
	cameraView.transform = transform;

	rotateCount ++;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	//return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return YES;
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
	[mImage release];
	[mScrollView release];
}

@end
