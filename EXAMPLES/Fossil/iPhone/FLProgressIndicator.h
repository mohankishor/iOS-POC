//
//  FLProgressIndicator.h
//  FLTryOnWatch
//
//  Created by Sanath on 11/10/10.
//  Copyright 2010 Sourcebits Technologies Pvt Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FLProgressIndicator : UIView 
{
	UIActivityIndicatorView *mSpinner;
}

- (id)initWithFrame:(CGRect)frame isWatchList:(BOOL)isList;

-(void) start;

-(void) stop;

@end
