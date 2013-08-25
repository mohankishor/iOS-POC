//
//  ColorButton.m
//  HiFiveGame
//
//  Created by Devika on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ColorButton.h"


@implementation ColorButton
@synthesize mColor;
-(id)init
{
	if (self==[super init]) {
		mColor=[NSColor grayColor];
	}
	return self;
}

-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSBezierPath* thePath4 = [NSBezierPath bezierPath];
	NSRect bounds4=NSMakeRect(cellFrame.origin.x,cellFrame.origin.y,cellFrame.size.width,cellFrame.size.height);
	[thePath4 appendBezierPathWithRect:bounds4];
	
	[[NSColor grayColor] setFill];
	[thePath4 fill];
   	
	[mColor setFill];
	if (mColor!=[NSColor grayColor]) {
		
		//Drawing the circle
		NSBezierPath* thePath3 = [NSBezierPath bezierPath];
		//	NSRect bounds3 = NSMakeRect(cellFrame.origin.x + (cellFrame.size.width / 2) - 5, cellFrame.origin.y + 3, 50, 50);
		NSRect bounds3 = NSMakeRect(cellFrame.origin.x+(cellFrame.size.width / 2)-14,cellFrame.origin.y+ (cellFrame.size.width / 2)-18, cellFrame.size.height/2+7, cellFrame.size.height/2+7);
		[thePath3 appendBezierPathWithOvalInRect:bounds3];
		[thePath3 fill];
	}
	[[NSColor blackColor] setStroke];
    [[NSColor blackColor] setFill];
	
	[NSBezierPath strokeRect:cellFrame];
	//[self setBordered:NO];
	
	
}

-(void)dealloc
{
	[mColor release];
	[super dealloc];
	
}
@end
