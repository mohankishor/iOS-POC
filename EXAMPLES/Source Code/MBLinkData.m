//
//  MBLinkData.m
//  Media Browser
//
//  Created by Sandeep GS on 01/06/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import "MBLinkData.h"


@implementation MBLinkData

@synthesize mLinkTitle;
@synthesize mLinkPath;


- (void) dealloc
{
	self.mLinkTitle = nil;
	self.mLinkPath = nil;
	[super dealloc];
}

@end
