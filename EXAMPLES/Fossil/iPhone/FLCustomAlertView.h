//
//  FLCustomAlertView.h
//  Fossil
//
//  Created by Ganesh Nayak on 23/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLViewWithBorder.h"
#import "FLProgressIndicator.h"

@interface FLCustomAlertView : UIViewController
{
	FLViewWithBorder		*mCustomView;
	id						mNavigationDelegate;
	id						mDelegate;
	FLProgressIndicator		*mProgressIndicator;
	NSString				*mPathString;
	NSString				*mTitleString;
	NSString				*mUrlString;

}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) id navDelegate;


- (id) initWithText:(NSString *) text watchPath:(NSString *) path watchUrl:(NSString *) url;
- (void) dismiss;

@end
