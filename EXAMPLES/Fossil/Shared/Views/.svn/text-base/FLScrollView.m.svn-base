//
//  FLScrollView.m
//  Fossil
//
//  Created by Darshan on 28/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FLScrollView.h"
#import "FLImageView.h"
#import "AppDelegate.h"

@implementation FLScrollView

@synthesize imageView = mImageView;
@synthesize actionDelegate = mActionDelegate;
@synthesize index = mIndex;

- (id) init
{
	self = [super init];
	
	if(self)
	{
		UIImageView *view = [[UIImageView alloc] init];
		view.contentMode = UIViewContentModeScaleAspectFit;
		self.imageView = view;
		[view release];
		
		self.delegate = self;
		self.minimumZoomScale = 1.0f;
		self.maximumZoomScale = 3.0f;
		self.zoomScale = 1.0f;
		self.bouncesZoom = YES;
		self.backgroundColor = [UIColor blackColor];
		self.decelerationRate = UIScrollViewDecelerationRateFast;
		
		[self addSubview:self.imageView];
		
		//add gesture recognizers
		mTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performTap)];
		mLongPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(performLongPress:)];
		mDoubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(performDoubleTap:)];
		
		mTapRecognizer.numberOfTapsRequired = 1;
		mDoubleTapRecognizer.numberOfTapsRequired = 2;
		
		mTapRecognizer.delaysTouchesBegan=YES;
		
		[mTapRecognizer requireGestureRecognizerToFail: mDoubleTapRecognizer];
		
		[self addGestureRecognizer:mLongPressRecognizer];
		[self addGestureRecognizer:mTapRecognizer];		
		[self addGestureRecognizer:mDoubleTapRecognizer];
	}
	return self;
}

- (void) dealloc
{
	[mTapRecognizer release];
	[mLongPressRecognizer release];
	[mDoubleTapRecognizer release];
	self.imageView = nil;
	[super dealloc];
}

- (UIView *) viewForZoomingInScrollView:(UIScrollView *) scrollView
{
	return self.imageView;
}

- (void) performDoubleTap:(UIGestureRecognizer*) sender
{
	if (FL_APP_DELEGATE.alertDisplay == YES) 
	{
		return;
	}
	CGPoint pos = [sender locationInView:self];
	//need to zoom to the point
	if(self.zoomScale > 2.0f) 
	{
		[self setZoomScale:1.0f animated:YES];
	}
	else
	{
		[self zoomToRect:CGRectMake(pos.x,pos.y,0.0,0.0) animated:YES];
	}
}

#pragma mark delegation

- (void) performLongPress:(UIGestureRecognizer*) sender //call delegate
{
	if (sender.state == UIGestureRecognizerStateBegan)
	{
		if([mActionDelegate respondsToSelector:@selector(imageLongTapped:)])
		{
			[mActionDelegate imageLongTapped:self];
			
			
		}
	}
	
}

- (void) performTap //call delegate
{
	if([mActionDelegate respondsToSelector:@selector(imageTapped:)])
	{
		[mActionDelegate imageTapped:self];
		
		
	}
}

@end
