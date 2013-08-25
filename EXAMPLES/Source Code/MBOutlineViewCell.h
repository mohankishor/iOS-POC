//
//  MBOutlineViewCell.h
//  Media Browser
//
//  Created by Sandeep GS on 20/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MBOutlineViewCell : NSTextFieldCell {
	NSImage				*mFolderImage;
	NSString			*mFolderName;
	NSMutableDictionary	*mFolderNameAttributes;
}

@property (nonatomic, retain) NSImage *mFolderImage;
@property (nonatomic, retain) NSString *mFolderName;

@end
