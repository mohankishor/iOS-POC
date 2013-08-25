//
//  ImageOverlay.h
//  TryOnWatch
//
//  Created by Sanath on 20/09/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ImageOverlay : UIView 
{
	UIImageView *mImageView;
	UIImage *mImage;
	CGPoint mPoint;
	CGPoint mOrigin;
	CGPoint FirstPoint;
	CGPoint EndPoint;
	UIPinchGestureRecognizer *pinchRecognizer;
}

@property(nonatomic, retain)UIImageView *imageView;
@property(nonatomic, retain)UIImage *image;
@property(nonatomic, assign)CGPoint point;
@end
