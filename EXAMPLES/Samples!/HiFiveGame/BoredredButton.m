//
//  BoredredButton.m
//  HiFiveGame
//
//  Created by Devika on 8/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BoredredButton.h"


@implementation BoredredButton
@dynamic mColor;
-(void)setMColor:(NSColor *)aColor
{
	if (mColor!=aColor) {
		[aColor retain];
		[mColor release];
		mColor=aColor;
		if (_well) {
			[_well setColor:mColor];
		}
		
		[self setNeedsDisplay:YES];
	}
	
}
-(NSColor *)mColor
{
	return mColor;
}
-(id)init
{
	if (self==[super init]) {
		
		
	}
	
	return self;
	
}
-(void)awakeFromNib
{
	_well=[[NSColorWell alloc]init];
	[_well setContinuous:YES];
	[_well setTarget:self];
	[_well setAction:@selector(changeColor:)];
	[self addSubview:_well];
	
}
-(void)dealloc
{
	[_well release];
	[mColor release];
	[super dealloc];
}
//-(void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
-(void)drawRect:(NSRect)dirtyRect
{
	//mColor=[_well color];
	
	
	[mColor setFill];
	[mColor setStroke];	
	
	NSBezierPath* thePath3 = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(self.bounds.origin.x, self.bounds.origin.x, self.bounds.size.width, self.bounds.size.height)];
	
	[thePath3 fill];
	
	//[self setBordered:NO];
	
	
}
-(void)mouseDown:(NSEvent *)theEvent
//-(void)setAction:(SEL)aSelector
{
	//mColor=[NSColor windowFrameColor];
	if ([self isEnabled]) {
				
			[_well performClick:self];
		
	}
	NSLog(@"well color:%@",[_well color]);
}

-(IBAction)changeColor:(id)sender
{
	self.mColor = [_well color];
}
@end
