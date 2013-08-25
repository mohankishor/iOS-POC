//
//  BoredredButton.h
//  HiFiveGame
//
//  Created by Devika on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface BoredredButton : NSButton {
	NSColor *mColor;
	
	//@private 
	NSColorWell *_well;
	
}
@property (nonatomic,retain)NSColor *mColor;
-(IBAction)changeColor:(id)sender;
@end
