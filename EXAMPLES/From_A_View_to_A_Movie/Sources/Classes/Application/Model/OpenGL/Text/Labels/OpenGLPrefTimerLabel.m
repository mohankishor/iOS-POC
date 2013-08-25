//---------------------------------------------------------------------------------------
//
//	File: OpenGLPrefTimerLabel.m
//
//  Abstract: Utility class for displaying a pref timer
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

#import "OpenGLPrefTimerLabel.h"

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------------------

struct OpenGLPrefTimerLabelAttributes
{
	GLdouble  fps;
	BOOL      updateDisplay;
	BOOL      updatelabel;
};

typedef struct	OpenGLPrefTimerLabelAttributes OpenGLPrefTimerLabelAttributes;

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------------------

@implementation OpenGLPrefTimerLabel

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated Initializer

//---------------------------------------------------------------------------
//
// Make sure client goes through designated initializer
//
//---------------------------------------------------------------------------

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

- (id) initLabelWithFormat:(NSString *)theFormatString 
				  fontName:(NSString *)theFontName 
				  fontSize:(const CGFloat)theFontSize 
				 textColor:(NSColor *)theTextColor 
				  boxColor:(NSColor *)theBoxColor 
			   borderColor:(NSColor *)theBorderColor 
			   coordinates:(const NSPoint *)theCoordinates
					bounds:(const NSRect *)theBounds
{
	PrefTimer  *timer = [PrefTimer new];
	double      fps   = [timer perfTick];
	
	NSString  *formatString = nil;
	NSString  *labelString  = nil;
	
	if( theFormatString )
	{
		formatString = [[NSString alloc] initWithString:theFormatString];
	} // if
	else
	{
		formatString = [[NSString alloc] initWithString:@"FPS: %5.2f"];
	} // else
	
	labelString = [[NSString alloc] initWithFormat:formatString,fps];
	
	self = [super initWithString:labelString
						fontName:theFontName 
						fontSize:theFontSize 
					   textColor:theTextColor 
						boxColor:theBoxColor 
					 borderColor:theBorderColor
					 coordinates:theCoordinates
						  bounds:theBounds];
	
	if( self )
	{
		prefTimer             = timer;
		prefTimerFormatString = formatString;
		prefTimerString       = labelString;
		
		[self setUsage:kOpenGLTextureUsePBODynamicDraw];
		
		prefTimerLabelAttribs = (OpenGLPrefTimerLabelAttributesRef)malloc(sizeof(OpenGLPrefTimerLabelAttributes));
		
		if( prefTimerLabelAttribs != NULL )
		{
			prefTimerLabelAttribs->fps           = fps;
			prefTimerLabelAttribs->updateDisplay = YES;
			prefTimerLabelAttribs->updatelabel   = YES;
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Pref Timer Label - Failure Allocating Memory For Attributes!" );
		}  // else
	} // if
	
	return self;
} // initWithFrame

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Deallocating Resources

//---------------------------------------------------------------------------------------

- (void) dealloc
{
	// View's memory container isn't needed
	
	if( prefTimerLabelAttribs != NULL )
	{
		free( prefTimerLabelAttribs );
		
		prefTimerLabelAttribs = NULL;
	} //if
	
	// Release the performance timer
	
	if( prefTimer ) 
	{
		[prefTimer release];
		
		prefTimer = nil;
	} // if

	// Release perf timer's string objects
	
	if( prefTimerString )
	{
		[prefTimerString release];
		
		prefTimerString = nil;
	} // if
	
	if( prefTimerFormatString )
	{
		[prefTimerFormatString release];
		
		prefTimerFormatString = nil;
	} // if
	
	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Preformance Timer Setters

//---------------------------------------------------------------------------------------

- (void) labelSetNeedsDisplay:(const BOOL)theLabelNeedsDisplay
{
	prefTimerLabelAttribs->updateDisplay = theLabelNeedsDisplay;
} // labelSetNeedsDisplay

//---------------------------------------------------------------------------------------

- (void) labelSetNeedsUpdate:(const BOOL)theLabelNeedsUpdate
{
	prefTimerLabelAttribs->updatelabel = theLabelNeedsUpdate;
} // labelSetNeedsUpdate

//---------------------------------------------------------------------------------------

- (void) labelSetFormatString:(NSString *)theFormatString
{
	if( theFormatString )
	{
		[theFormatString retain];
		
		[prefTimerFormatString release];
		
		prefTimerFormatString = theFormatString;
	} //if
} // labelSetFormatString

//---------------------------------------------------------------------------------------

#pragma mark -
#pragma mark Pref Timer View Updates

//---------------------------------------------------------------------------------------

- (void) labelUpdatePrefTimerString
{
	NSString *prefTimerNewString = [[NSString stringWithFormat:prefTimerFormatString,prefTimerLabelAttribs->fps] retain];
	
	[prefTimerString release];
	prefTimerString = prefTimerNewString;

	[self setText:prefTimerString];
} // labelUpdatePrefTimerString

//---------------------------------------------------------------------------------------

- (void) labelDraw
{
	if( prefTimerLabelAttribs->updateDisplay )
	{
		// Preformance ticker text should update only if the 
		// the geometry in the view is rotating.
		
		if( prefTimerLabelAttribs->updatelabel )
		{
			double fps = [prefTimer perfTick];
			
			if( fps != prefTimerLabelAttribs->fps )
			{
				prefTimerLabelAttribs->fps = fps;
				
				[self labelUpdatePrefTimerString];
			} // if
		} // if
		
		[self drawText];
	} // if
} // labelDraw

//---------------------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------

