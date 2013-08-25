//
//  FLAdjustViewController.m
//  DTryOnWatch
//
//  Created by Darshan on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLAdjustViewController.h"
#import "QuartzCore/QuartzCore.h"

@interface FLAdjustViewController (Private)
-(void) createToolbar;
-(void) createTouchImage;
-(void) createBackgroundImage;
@end

@implementation FLAdjustViewController

@synthesize watchData = mWatchData;
@synthesize capturedImage = mCapturedImage;
@synthesize delegate = mDelegate;

- (id) initWithWatch: (NSData *) watchData andImage:(UIImage*) capturedImage;
{
	if((self = [super initWithNibName:nil bundle:nil]))
	{
		self.watchData = watchData;
		self.capturedImage = capturedImage;
	}
	return self;
}


- (void)loadView 
{
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,MAX_WIDTH,MAX_HEIGHT)];
	view.backgroundColor = [UIColor clearColor];
	self.view = view;
	[view release];
	
	[self createToolbar];	
	
	[self createTouchImage];
	
	[self createBackgroundImage];
}

-(void) createToolbar
{
	UIView *toolbarView = [[UIView alloc]initWithFrame:CGRectMake(0, (MAX_HEIGHT - TOOLBAR_HEIGHT), MAX_WIDTH, TOOLBAR_HEIGHT)];
	toolbarView.backgroundColor = [UIColor colorWithRed:0.2 green:0.09 blue:0.0 alpha:1];
	
	UIImage *cameraImage = [UIImage imageNamed:@"toolbar-action.png"];
	UIImageView *cameraView = [[UIImageView alloc] initWithFrame:CGRectMake((50-cameraImage.size.width)/2,(45-cameraImage.size.height)/2,cameraImage.size.width, cameraImage.size.height)];
	[cameraView setImage:cameraImage];
	
	UIButton *saveButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 5, 50, 50)];
	[saveButton addSubview:cameraView];
	[saveButton setShowsTouchWhenHighlighted:YES];
	[saveButton addTarget:self action:@selector(adjustSave) forControlEvents:UIControlEventTouchUpInside];
	mSaveButton = saveButton;
	
	UIImage *backImage = [UIImage imageNamed:@"toolbar-reset.png"]; 	
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 7, TOOLBARBUTTON_SIZE, TOOLBARBUTTON_SIZE)];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:backImage forState:UIControlStateNormal];
	[backButton setShowsTouchWhenHighlighted:YES];
	[backButton addTarget:self action:@selector(adjustBack) forControlEvents:UIControlEventTouchUpInside];
	mBackToCameraButton = backButton;
	
	[toolbarView addSubview:backButton];
	[toolbarView addSubview:saveButton];
	[self.view addSubview:toolbarView];
	
	[toolbarView release];
	[cameraView release];
	[saveButton release];
	[backButton release];
	
}
-(void) createTouchImage
{
	//same as watch image
	
	UIImage *img = [[UIImage alloc] initWithData:self.watchData];
	
	mWatchImageView = [[TouchImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
	mWatchImageView.image = img;
	//	mWatchImageView.center = self.view.center;
	[img release];
	
	[self.view addSubview:mWatchImageView];
}
-(void) createBackgroundImage
{
	UIImageView *bgImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,MAX_WIDTH,MAX_HEIGHT-TOOLBAR_HEIGHT)];
	bgImage.image = mCapturedImage;
	CGAffineTransform transform = CGAffineTransformIdentity;
	NSLog(@"orientation = %d",mCapturedImage.imageOrientation);
	if(mCapturedImage.imageOrientation == UIImageOrientationUp)
	{
		transform = CGAffineTransformRotate(transform,M_PI/2);
		transform = CGAffineTransformScale(transform,(MAX_HEIGHT-TOOLBAR_HEIGHT)/(double)(MAX_WIDTH),MAX_WIDTH/(double)(MAX_HEIGHT-TOOLBAR_HEIGHT));
	}
	else if(mCapturedImage.imageOrientation == UIImageOrientationDown)
	{
		transform = CGAffineTransformRotate(transform,-M_PI/2);
				transform = CGAffineTransformScale(transform,(MAX_HEIGHT-TOOLBAR_HEIGHT)/(double)(MAX_WIDTH),MAX_WIDTH/(double)(MAX_HEIGHT-TOOLBAR_HEIGHT));	
	}
	else if(mCapturedImage.imageOrientation == UIImageOrientationLeft)
	{
		transform = CGAffineTransformRotate(transform,M_PI);
	}
	[bgImage setTransform:transform];
	
	[self.view addSubview:bgImage];
	[self.view sendSubviewToBack:bgImage];
	[bgImage release];
}
-(void) adjustBack
{
	[self.delegate adjustBack];
}

-(void) adjustSave
{
	[self save:nil];
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
}


- (void)dealloc 
{
	self.delegate = nil;
	self.watchData = nil;
	self.capturedImage = nil;
	[mWatchImageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Alert Methods

-(void) save:(id)sender
{
	mSaveButton.enabled = NO;
	mBackToCameraButton.enabled = NO;
	mSaveView = [[UIView alloc] initWithFrame:CGRectMake(32.5, 120, 255, 150)];
	mSaveView.backgroundColor = [UIColor colorWithHue:0.5 saturation:0.2 brightness:0.1 alpha:0.5];
	[mSaveView.layer setCornerRadius:15.0];
	
	UIButton *alertSaveButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 25, 225, 40)];
	[alertSaveButton setBackgroundColor:[UIColor clearColor]];
	[alertSaveButton setBackgroundImage:[UIImage imageNamed:@"round.png"] forState:UIControlStateNormal];
	[alertSaveButton setTitle:@"Save to Photo Album" forState:UIControlStateNormal];
	[alertSaveButton setShowsTouchWhenHighlighted:YES];
	[alertSaveButton addTarget:self action:@selector(alertSavePhotos:) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *alertCancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 85, 225, 40)];
	[alertCancelButton setBackgroundImage:[UIImage imageNamed:@"round.png"] forState:UIControlStateNormal];
	[alertCancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[alertCancelButton setShowsTouchWhenHighlighted:YES];
	[alertCancelButton addTarget:self action:@selector(alertCancel:) forControlEvents:UIControlEventTouchUpInside];
	
	[mSaveView addSubview:alertSaveButton];
	[mSaveView addSubview:alertCancelButton];
	[self.view addSubview:mSaveView];
	[alertSaveButton release];
	[alertCancelButton release];
}


-(void)alertCancel:(id)sender
{
	mSaveButton.enabled = YES;
	mBackToCameraButton.enabled = YES;
	[mSaveView removeFromSuperview];
	mSaveView = nil;
}

-(void)alertSavePhotos:(id)sender
{
	[mSaveView removeFromSuperview];
	mSaveView = nil;
	UIImageWriteToSavedPhotosAlbum([mWatchImageView getImage:mCapturedImage], nil, nil, nil);
	
	mFinishView = [[UIView alloc] initWithFrame:CGRectMake(32.5, 120, 255, 150)];
	mFinishView.backgroundColor = [UIColor colorWithHue:0.5 saturation:0.2 brightness:0.1 alpha:0.6];
	[mFinishView.layer setCornerRadius:15.0];
	
	UITextView *finishTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 5, 255, 150)];
	finishTextView.backgroundColor = [UIColor clearColor];
	finishTextView.text = @"\n     Saved to your Photo Album.\n  You can share with your friends\n     by emailing from the Photo\n\t\t\tAlbum.";
	finishTextView.editable = NO;
	finishTextView.font = [UIFont systemFontOfSize:16.0];
	finishTextView.textColor = [UIColor whiteColor];
	[mFinishView addSubview:finishTextView];
	[finishTextView release];
	
	[self.view addSubview:mFinishView];
	[self performSelector:@selector(dismiss) withObject:nil afterDelay:4];
}

-(void) dismiss
{
	mSaveButton.enabled = YES;
	mBackToCameraButton.enabled = YES;
	[mFinishView removeFromSuperview];
	mFinishView = nil;
}
@end
