//
//  TryOnWatchViewController.h
//  TryOnWatch
//
//  Created by Sanath on 20/09/10.
//  Copyright Sourcebits Technologies Pvt Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageOverlay.h"
//@class ImageOverlay;
#import "CustomAlertView.h"

#define CAMERA_TRANSFORM_X 1
#define CAMERA_TRANSFORM_Y 1.12412


@interface TryOnWatchViewController : UIViewController <UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
	UIImagePickerController *picker;
	ImageOverlay *mImage;
	UIScrollView *mScrollView;
	UIImage *bgImage;
	NSInteger  rotateCount;
	CustomAlertView *mSaveAlert;
	CustomAlertView *mFinishAlert;
	UIImageView *cameraView;

}

@end

