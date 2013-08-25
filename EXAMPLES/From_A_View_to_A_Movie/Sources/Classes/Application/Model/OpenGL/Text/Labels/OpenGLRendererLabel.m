//---------------------------------------------------------------------------------------
//
//	File: OpenGLRendererLabel.m
//
//  Abstract: Utility class for displaying renderers info
// 			 
//  Disclaimer: IMPORTANT:  This Apple software is supplied to you by
//  Inc. ("Apple") in consideration of your agreement to the following terms, 
//  and your use, installation, modification or redistribution of this Apple 
//  software constitutes acceptance of these terms.  If you do not agree with 
//  these terms, please do not use, install, modify or redistribute this 
//  Apple software.
//  
//  In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Apple grants you a personal, non-exclusive
//  license, under Apple's copyrights in this original Apple software (the
//  "Apple Software"), to use, reproduce, modify and redistribute the Apple
//  Software, with or without modifications, in source and/or binary forms;
//  provided that if you redistribute the Apple Software in its entirety and
//  without modifications, you must retain this notice and the following
//  text and disclaimers in all such redistributions of the Apple Software. 
//  Neither the name, trademarks, service marks or logos of Apple Inc. may 
//  be used to endorse or promote products derived from the Apple Software 
//  without specific prior written permission from Apple.  Except as 
//  expressly stated in this notice, no other rights or licenses, express
//  or implied, are granted by Apple herein, including but not limited to
//  any patent rights that may be infringed by your derivative works or by
//  other works in which the Apple Software may be incorporated.
//  
//  The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
//  MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
//  THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
//  FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
//  OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
//  
//  IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
//  OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
//  MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
//  AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
//  STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
// 
//  Copyright (c) 2008-2009 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#import "OpenGLQuery.h"
#import "OpenGLRendererLabel.h"

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------------------

struct OpenGLRendererLabelAttributes
{
	BOOL     display;
	NSPoint  coordinates;
};

typedef struct	OpenGLRendererLabelAttributes OpenGLRendererLabelAttributes;

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------------------

@implementation OpenGLRendererLabel

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated Initializer

//---------------------------------------------------------------------------------------
//
// Make sure client goes through designated initializer
//
//---------------------------------------------------------------------------------------

- (id) initWithString:(NSString *)theTextString 
			 fontName:(NSString *)theFontName 
			 fontSize:(const CGFloat)theFontSize 
			textColor:(NSColor *)theTextColor 
			 boxColor:(NSColor *)theBoxColor 
		  borderColor:(NSColor *)theBorderColor 
		  coordinates:(const NSPoint *)theCoordinates
			   bounds:(const NSRect *)theBounds 
{
	[self doesNotRecognizeSelector:_cmd];
	
	return nil;
} // initWithString

//---------------------------------------------------------------------------------------

- (id) initLabelWithFontName:(NSString *)theFontName 
					fontSize:(const CGFloat)theFontSize 
				   textColor:(NSColor *)theTextColor 
					boxColor:(NSColor *)theBoxColor 
				 borderColor:(NSColor *)theBorderColor 
				 coordinates:(const NSPoint *)theCoordinates 
					  bounds:(const NSRect *)theBounds
{
	OpenGLQuery *query = [OpenGLQuery new];
	
	if( query )
	{
		NSString *rendererInfo = [query info];

		if( rendererInfo )
		{
			self = [super initWithString:rendererInfo
								fontName:theFontName 
								fontSize:theFontSize 
							   textColor:theTextColor 
								boxColor:theBoxColor 
							 borderColor:theBorderColor
							 coordinates:theCoordinates
								  bounds:theBounds];
			
			if( self )
			{
				rendererLabelAttribs = (OpenGLRendererLabelAttributesRef)malloc(sizeof(OpenGLRendererLabelAttributes));

				if( rendererLabelAttribs != NULL )
				{
					rendererLabelAttribs->display = YES;
					
					rendererLabelAttribs->coordinates.x = 0.0f;
					rendererLabelAttribs->coordinates.y = 0.0f;
				} // if
				else
				{
					NSLog( @">> ERROR: OpenGL Renderer Label - Failure Allocating Memory For Attributes!" );
				} // else
				
				[self viewSetBounds:theBounds];
				[self drawText];
			} // if
			
			[rendererInfo release];
		} // if
		
		[query release];
	} // if
	
	return( self );
} // initLabelWithFormat

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Deallocating Resources

//---------------------------------------------------------------------------------------

- (void) dealloc
{
	// Attributes are not needed
	
	if( rendererLabelAttribs != NULL )
	{
		free( rendererLabelAttribs );
		
		rendererLabelAttribs = NULL;
	} // if
	
	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Label Utilities

//---------------------------------------------------------------------------------------

- (void) labelSetNeedsDisplay:(const BOOL)theLabelNeedsDisplay
{
	rendererLabelAttribs->display = theLabelNeedsDisplay;
} // labelSetNeedsDisplay

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Drawing the label

//---------------------------------------------------------------------------------------

- (void) labelDraw
{
	if( rendererLabelAttribs->display )
	{
		NSRect   bounds = [self viewBounds];
		NSPoint  point  = NSMakePoint(10.0f, bounds.size.height - 52.0f);
		
		if( ( point.x != rendererLabelAttribs->coordinates.x ) || ( point.y != rendererLabelAttribs->coordinates.y ) )
		{
			[self moveTo:&point];
		} // if
		
		[self drawText];
	} // if
} // labelDraw

//---------------------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

