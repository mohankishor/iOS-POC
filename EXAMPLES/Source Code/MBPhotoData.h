//
//  MBPhotoData.h
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MBPhotoData : NSObject {
		//Instance Variables to declare photo details 
	NSString			*mPhotoTitle;
	NSString			*mPhotoType;
	NSString			*mPhotoPath;
	NSImage				*mPhotoThumb;
}

@property (nonatomic, retain) NSString	*mPhotoTitle;
@property (nonatomic, retain) NSString	*mPhotoType;
@property (nonatomic, retain) NSString	*mPhotoPath;
@property (nonatomic, retain) NSImage	*mPhotoThumb;

@end
