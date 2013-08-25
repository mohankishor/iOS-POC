//
//  NSWindow+Flipr.h
//  Media Browser
//
//  Created by Sandeep GS on 31/05/10.
//  Copyright 2010 Sourcebits Technolgies Pvt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (Flipr)

+ (NSWindow*)flippingWindow;
+ (void)releaseFlippingWindow;
- (void)flipToShowWindow:(NSWindow*)window forward:(BOOL)forward reflectInto:(NSImageView*)reflection;

@end
