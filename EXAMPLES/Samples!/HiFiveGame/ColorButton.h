//
//  ColorButton.h
//  HiFiveGame
//
//  Created by Devika on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ColorButton : NSButtonCell {
	NSColor *mColor;

}
@property (nonatomic,retain)NSColor *mColor;
@end
