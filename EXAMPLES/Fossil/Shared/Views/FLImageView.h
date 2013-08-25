//
//  FLImageView.h
//  Fossil
//
//  Created by Shirish Gone on 09/09/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FLImageViewDelegate <NSObject>
@optional
-(void) imageTapped: (id) sender;
-(void) imageDoubleTapped: (id) sender;
-(void) imageLongTapped: (id) sender;
@end
	
@interface FLImageView : UIImageView
{
	NSUInteger mNumber;	//page or spread number
	id mDelegate;
	NSTimer *mTimer;
	
}

@property (nonatomic, readwrite) NSUInteger number;
@property (nonatomic, assign) id delegate;


@end