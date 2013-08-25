//
//  FLCameraOverlayView.m
//  DTryOnWatch
//
//  Created by Darshan on 03/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLCameraOverlayView.h"

@interface FLCameraOverlayView (Private)
-(void) createTopToolbarWithTitle:(NSString  *) title;
-(void) createBottomToolbar;
-(void) createWatchImageWithData:(NSData *)data;
-(void) performRotate:(int) rotateCount;

@end

@implementation FLCameraOverlayView

@synthesize delegate = mDelegate;
@synthesize watchData = mWatchData;
@synthesize watchName = mWatchName;
@synthesize rotateCount = mRotateCount;

-(void) setWatchData:(NSData*) data
{
	NSLog(@"set watch data");
	if(mWatchData)
	{
		[mWatchData release];
	}
	mWatchData = [data retain];
	
	UIImage *image = [[UIImage alloc] initWithData:data];
	[mWatchImageView setImage:image];
	[image release];
}
-(void) setWatchName:(NSString *) watchname
{
	mWatchName = [watchname retain];
	mTitleLabel.text = mWatchName; 
}
- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) 
	{
		[self createTopToolbarWithTitle:@"Default"];
		[self createBottomToolbar];
		[self createWatchImageWithData:nil];
    }
    return self;
}

-(void) createTopToolbarWithTitle:(NSString  *) title
{
	UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX_WIDTH, 44)];
	navigationBarView.backgroundColor = [UIColor colorWithRed:0.2 green:0.09 blue:0.0 alpha:0.7];
	
	UIImage *fossilImage = [UIImage imageNamed:@"navBar-logo.png"];
	UIImageView *fossilImageView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 10, 40, 20)];
	[fossilImageView setImage:fossilImage];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 2.5, 230, 39)];
	label.text = title;
	label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = [UIFont boldSystemFontOfSize:11];
	label.textAlignment = UITextAlignmentCenter;
	mTitleLabel = label;
	
	UIImage *previousImage = [UIImage imageNamed:@"button_back.png"];
	UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 2.5, 50, 39)];
	[backButton setBackgroundColor:[UIColor clearColor]];
	[backButton setImage:previousImage forState:UIControlStateNormal];
	[backButton setShowsTouchWhenHighlighted:YES];
	[backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside]; 
	
	[navigationBarView addSubview:fossilImageView];
	[navigationBarView addSubview:label];
	[navigationBarView addSubview:backButton];
	[self addSubview:navigationBarView];
	
	[navigationBarView release];
	[fossilImageView release];
	[label release];
	[backButton release];
}

-(void) createBottomToolbar
{
	UIView *toolbarView = [[UIView alloc]initWithFrame:CGRectMake(0, (MAX_HEIGHT - TOOLBAR_HEIGHT), MAX_WIDTH, TOOLBAR_HEIGHT)];
	toolbarView.backgroundColor = [UIColor colorWithRed:0.2 green:0.09 blue:0.0 alpha:0.6];
	
	UIImage *cameraImage = [UIImage imageNamed:@"toolbar-camera.png"];
	UIImageView *cameraView = [[UIImageView alloc] initWithFrame:CGRectMake((50-cameraImage.size.width)/2,(45-cameraImage.size.height)/2,cameraImage.size.width, cameraImage.size.height)];
	[cameraView setImage:cameraImage];
	
	UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(160, 5, 50, 50)];
	[cameraButton addSubview:cameraView];
	[cameraButton setShowsTouchWhenHighlighted:YES];
	[cameraButton addTarget:self action:@selector(capture) forControlEvents:UIControlEventTouchUpInside];
	mCameraButton = cameraButton;
	
	UIImage *orientationImage = [UIImage imageNamed:@"toolbar_orientation.png"]; 	
	UIButton *orientationButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 7, TOOLBARBUTTON_SIZE, TOOLBARBUTTON_SIZE)];
	[orientationButton setBackgroundColor:[UIColor clearColor]];
	[orientationButton setImage:orientationImage forState:UIControlStateNormal];
	[orientationButton setShowsTouchWhenHighlighted:YES];
	[orientationButton addTarget:self action:@selector(rotate) forControlEvents:UIControlEventTouchUpInside];
	
	
	[toolbarView addSubview:orientationButton];
	[toolbarView addSubview:cameraButton];
	[self addSubview:toolbarView];
	
	[toolbarView release];
	[cameraView release];
	[cameraButton release];
	[orientationButton release];
}

-(void) createWatchImageWithData:(NSData *)data
{
	UIImageView *watchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	watchImageView.center = self.center;
	[watchImageView setContentMode:UIViewContentModeScaleAspectFit];
	mWatchImageView = watchImageView;
	if(data)
	{
		UIImage *watchImage = [[UIImage alloc] initWithData:data];
		watchImageView.image = watchImage;
		[watchImage release];
	}	
		
	[self addSubview:watchImageView];
	[watchImageView release];
}
-(void) performRotate:(int) rotateCount
{
	float radians = (M_PI / 2.0) * rotateCount;
	CGAffineTransform transform=CGAffineTransformIdentity;
	transform = CGAffineTransformRotate(transform,radians);
	[mWatchImageView setTransform:transform];
	[mCameraButton setTransform:transform];
}
-(void) rotate
{
	//need to do some processing to rotate buttons
	mRotateCount = (mRotateCount + 1) %4;
	[self performRotate:mRotateCount];
	[self.delegate rotate];
}
-(void) back
{
	[self.delegate back];
}

-(void) capture
{
	[self.delegate capture];
}

- (void)dealloc 
{
	self.delegate = nil;
	self.watchData = nil;
	self.watchName = nil;
    [super dealloc];
}


@end
