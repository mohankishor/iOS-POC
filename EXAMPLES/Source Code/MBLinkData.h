//
//  MBLinkData.h
//  Media Browser
//
//  Created by Sandeep GS on 01/06/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MBLinkData : NSObject {
	NSString *mLinkTitle;
	NSString *mLinkPath;
}

@property (nonatomic, retain) NSString *mLinkTitle;
@property (nonatomic, retain) NSString *mLinkPath;

@end
