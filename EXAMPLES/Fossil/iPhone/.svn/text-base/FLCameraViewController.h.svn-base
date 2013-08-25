//
//  FLCameraViewController.h
//  DTryOnWatch
//
//  Created by Darshan on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLCameraOverlayView.h"
#import "FLAdjustViewController.h"



@interface FLCameraViewController : UIViewController <UIImagePickerControllerDelegate,FLCameraOverlayProtocol,FLAdjustViewProtocol,UIAlertViewDelegate> 
{
	UIImagePickerController *mImagePicker;
	
	NSData					*mWatchData;
	NSString			    *mWatchName;
	
	UIImage					*mCapturedImage;
	
	UIViewController *mAdjustViewController;
	
	BOOL mLowMemoryAlertShown;
}

@property (nonatomic, retain) NSData *watchData;
@property (nonatomic, retain) NSString *watchName;
@property (nonatomic,assign) BOOL lowMemoryAlertShown;

- (id) initWithData: (NSData *) data watchTitle: (NSString *) titleString;
-(void) back;
-(void) capture;
-(void) rotate;
-(void) adjustBack;

-(void) delayedPresenterAdjustView;
-(void) delayedPresenterCameraView;
@end
