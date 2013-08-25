//
//  FLCameraOverlayView.h
//  DTryOnWatch
//
//  Created by Darshan on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>

#define MAX_HEIGHT 480
#define MAX_WIDTH 320
#define TOOLBAR_HEIGHT 54
#define TOOLBARBUTTON_SIZE 40

@protocol FLCameraOverlayProtocol

@required
-(void) back;
-(void) capture;
-(void) rotate;

@end

@interface FLCameraOverlayView : UIView 
{
	id<FLCameraOverlayProtocol> mDelegate;
	
	int						mRotateCount;
	
	NSData					*mWatchData;
	NSString			    *mWatchName;
	
	UILabel			*mTitleLabel;
	UIImageView		*mWatchImageView;
	
	UIButton *mCameraButton;
}

@property (nonatomic, retain) NSData *watchData;
@property (nonatomic, retain) NSString *watchName;
@property (nonatomic, assign) int rotateCount;

@property (nonatomic, retain) id<FLCameraOverlayProtocol> delegate;


@end
