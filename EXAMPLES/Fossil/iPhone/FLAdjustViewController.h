//
//  FLAdjustViewController.h
//  DTryOnWatch
//
//  Created by Darshan on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TouchImageView.h"

#define MAX_HEIGHT 480
#define MAX_WIDTH 320
#define TOOLBAR_HEIGHT 54
#define TOOLBARBUTTON_SIZE 40

@protocol FLAdjustViewProtocol
@required
-(void) adjustBack;
@end

@interface FLAdjustViewController : UIViewController 
{
	id<FLAdjustViewProtocol> mDelegate;
	TouchImageView *mWatchImageView;
	
	NSData *mWatchData;
	UIImage *mCapturedImage;
	
	UIButton *mSaveButton;
	UIButton *mBackToCameraButton;
	
	//- alert methods
	UIView *mSaveView;
	UIView *mFinishView;
}

@property (nonatomic, retain) NSData *watchData;
@property (nonatomic, retain) UIImage *capturedImage;
@property (nonatomic, retain) id<FLAdjustViewProtocol> delegate;

- (id) initWithWatch: (NSData *) watchData andImage:(UIImage*) capturedImage;

-(void) adjustBack;
-(void) adjustSave;

@end
