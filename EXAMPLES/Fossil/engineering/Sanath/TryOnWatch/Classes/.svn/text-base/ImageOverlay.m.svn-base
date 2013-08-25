//
//  ImageOverlay.m
//  TryOnWatch
//
//  Created by Sanath on 20/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import "ImageOverlay.h"


@implementation ImageOverlay
@synthesize imageView = mImageView,image = mImage, point = mPoint;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) 
	{
		NSString *path = [[NSBundle mainBundle] pathForResource:@"scanbutton" ofType:@"png"];
		mImage = [[UIImage alloc] initWithContentsOfFile:path];
		mImageView = [[UIImageView alloc] initWithImage:mImage]; 
		NSLog(@"...actual %f---%f",mImage.size.width, mImage.size.height);
		[mImageView setFrame:CGRectMake(120, 240, mImage.size.width, mImage.size.height)];
		NSLog(@"bounds..%f..%f..%f..%f",self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height);
		mImageView.userInteractionEnabled = YES;
		[self addSubview:mImageView];
		[mImageView release];
    }
	pinchRecognizer =[ [UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
	[pinchRecognizer setScale:1];
	[self addGestureRecognizer:pinchRecognizer];
	[pinchRecognizer release];

    return self;
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	NSLog(@"---view---%@",[touch view]);
	NSLog(@"---ovrlayview---%@",mImageView);
	
	// If the touch was in the placardView, move the placardView to its location
	if ([touch view] == mImageView) {
		mPoint = [touch locationInView:mImageView];
		mPoint = [self convertPoint:mPoint fromView:mImageView];
		float stopLeftX = self.bounds.origin.x + mImageView.frame.size.width/2;
		float stopRightX = self.bounds.size.width - mImageView.frame.size.width/2;
		float stopTopY = self.bounds.origin.y + mImageView.frame.size.height/2 + 20;
		float stopBottomY =  self.bounds.size.height - mImageView.frame.size.height/2 -54;
		if (mPoint.x >= stopLeftX && mPoint.y >= stopTopY && 
			mPoint.x <= stopRightX && mPoint.y <= stopBottomY) 
		{
			mImageView.center = mPoint;	
		}
		//mOrigin = mImageView.frame.origin;
				NSLog(@"move 1 point---%f--%f",mImageView.frame.origin.x,mImageView.frame.origin.y);
		NSLog(@"move 2 point---%f--%f",mPoint.x,mPoint.y);
		
		//return;
	}
	else 
	{
		NSLog(@"nothing. .  .");
	}

}



-(void)handlePinch:(UIPinchGestureRecognizer*)sender
{
		UIView *newFrame = [[UIView alloc] initWithFrame:mImageView.frame];
		if (sender.state ==UIGestureRecognizerStateBegan) 
		{
			sender.scale = mImageView.transform.a;;
			
		}
		else if(sender.state == UIGestureRecognizerStateChanged)
		{
			CGFloat scale = MAX(sender.scale, 1.0f);; 
			newFrame.transform = CGAffineTransformMakeScale(scale, scale);
			mImageView.transform = newFrame.transform;
		}
		else if(sender.state == UIGestureRecognizerStateEnded) 
		{
			mImageView.frame = newFrame.frame;
		}
	
}
- (void)dealloc {
    [super dealloc];
}

@end


