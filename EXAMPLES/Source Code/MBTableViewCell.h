//
//  MBTableViewCell.h
//  Media Browser
//
//  Created by Sandeep GS on 31/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MBTableViewCell : NSCell {
	NSImage					*mLinkImage;
	NSString				*mLinkName;
	NSMutableDictionary		*mLinkNameAttributes;
}

@property (nonatomic, retain) NSImage *mLinkImage;
@property (nonatomic, retain) NSString *mLinkName;

@end