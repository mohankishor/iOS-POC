    //
//  FLCameraViewController.m
//  DTryOnWatch
//
//  Created by Darshan on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCameraViewController.h"
#import "FLDataManager.h"

@implementation FLCameraViewController

@synthesize watchData = mWatchData, watchName = mWatchName,  lowMemoryAlertShown = mLowMemoryAlertShown;

- (id) initWithData: (NSData *) data watchTitle: (NSString *) titleString
{
	if (self = [super init])
	{
		self.watchData = data;
		self.watchName = titleString;
		self.lowMemoryAlertShown = NO;
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	UIView *view = [[UIView alloc] init];
	self.view = view;
	self.view.backgroundColor = [UIColor blackColor];
	[view release];
	
	mImagePicker = [[UIImagePickerController alloc] init];
	mImagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
	mImagePicker.delegate = self;
	mImagePicker.showsCameraControls = NO;
	mImagePicker.wantsFullScreenLayout = YES;
	
	//overlay has the toolbars
	FLCameraOverlayView *overlay = [[FLCameraOverlayView alloc] initWithFrame:CGRectMake(0,0,MAX_WIDTH,MAX_HEIGHT)];
	overlay.watchData = self.watchData;
	overlay.watchName = self.watchName;
	overlay.delegate = self;
	
	mImagePicker.cameraOverlayView = overlay;
	[overlay release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[self presentModalViewController:mImagePicker animated:NO];
}


-(void) back
{
	[mImagePicker dismissModalViewControllerAnimated:YES];
	
	[self.navigationController popViewControllerAnimated:NO];
	//[self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:NO afterDelay:1.0];
}
-(void) capture
{
	[mImagePicker takePicture];
}
-(void) delayedPresenterAdjustView
{
	//create and show the adjust view controller
	FLAdjustViewController *vc = [[FLAdjustViewController alloc] initWithWatch:self.watchData andImage:mCapturedImage];
	vc.delegate = self;
	mAdjustViewController = vc;
	[self presentModalViewController:vc animated:YES];
	[vc release];
	[mCapturedImage release];
	mCapturedImage = nil;

}
-(void) rotate
{
}

-(void) adjustBack
{
	[mAdjustViewController dismissModalViewControllerAnimated:YES];
	mAdjustViewController = nil;
	//[self back];
	
	[self performSelector:@selector(delayedPresenterCameraView) withObject:nil afterDelay:1.0];
}
-(void) delayedPresenterCameraView
{
	[self presentModalViewController:mImagePicker animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation == UIInterfaceOrientationLandscapeRight));
}


- (void)didReceiveMemoryWarning 
{
	[[FLDataManager sharedInstance] clearCache];
	if(!self.lowMemoryAlertShown)
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your device is low on memory." 
													message:@"Please close some other apps and try again."
												   delegate:self
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
		[alert show];
		[alert release];
		self.lowMemoryAlertShown = YES;
	}
	[self dismissModalViewControllerAnimated:YES];
	[self.navigationController popViewControllerAnimated:NO];
	
    [super didReceiveMemoryWarning];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.lowMemoryAlertShown = NO;
}
- (void)viewDidUnload 
{
    [super viewDidUnload];
}


- (void)dealloc {
	[mImagePicker release];
	mImagePicker = nil;
    [super dealloc];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	mCapturedImage = [[info objectForKey:@"UIImagePickerControllerOriginalImage"] retain];
	
	[mImagePicker dismissModalViewControllerAnimated:YES];
	
	[self performSelector:@selector(delayedPresenterAdjustView) withObject:nil afterDelay:1.0];
}
@end
