//
//  FLScrollView.h
//  Fossil
//
//  Created by Darshan on 28/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FLImageView.h"

@interface FLScrollView : UIScrollView<UIScrollViewDelegate>
{
	UIImageView *mImageView;
	id<FLImageViewDelegate,NSObject> mActionDelegate;
	
	UITapGestureRecognizer *mTapRecognizer;
	UITapGestureRecognizer *mDoubleTapRecognizer;
	UILongPressGestureRecognizer *mLongPressRecognizer;
	
	int mIndex;
}

@property (nonatomic, retain) UIImageView* imageView; 
@property (nonatomic, assign) id<FLImageViewDelegate> actionDelegate;
@property (nonatomic, readwrite, assign) int index;

-(void) performDoubleTap:(UIGestureRecognizer*)sender;//zoom

-(void) performLongPress:(UIGestureRecognizer*)sender;//call delegate
-(void) performTap;//call delegate

@end