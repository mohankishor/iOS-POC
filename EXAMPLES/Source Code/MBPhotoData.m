//
//  MBPhotoData.m
//  Media Browser
//
//  Created by Sandeep GS on 14/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBPhotoData.h"

@implementation MBPhotoData

@synthesize mPhotoTitle;
@synthesize mPhotoType;
@synthesize mPhotoPath;
@synthesize mPhotoThumb;

- (id) init
{
	self = [super init];
	if (self != nil) {
		;
	}
	return self;
}

- (void) dealloc
{
	self.mPhotoThumb = nil;
	self.mPhotoTitle = nil;
	self.mPhotoType = nil;
	self.mPhotoPath = nil;
	[super dealloc];
}

-(NSString *)description
{
	return [NSString stringWithFormat:@"Photo Title: %@ Photo Path : %@  Photo Thumb = %@", mPhotoTitle, mPhotoPath, mPhotoThumb];	
}

@end
