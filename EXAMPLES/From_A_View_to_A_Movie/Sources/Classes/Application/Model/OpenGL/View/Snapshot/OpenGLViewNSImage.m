//------------------------------------------------------------------------
//
//	File: OpenGLViewImage.m
//
//  Abstract: Utility class for generating a NSImage from an OpenGL view
// 			 
//  Disclaimer: IMPORTANT:  This Apple software is supplied to you by
//  Apple Inc. ("Apple") in consideration of your agreement to the
//  following terms, and your use, installation, modification or
//  redistribution of this Apple software constitutes acceptance of these
//  terms.  If you do not agree with these terms, please do not use,
//  install, modify or redistribute this Apple software.
//  
//  In consideration of your agreement to abide by the following terms, and
//  subject to these terms, Apple grants you a personal, non-exclusive
//  license, under Apple's copyrights in this original Apple software (the
//  "Apple Software"), to use, reproduce, modify and redistribute the Apple
//  Software, with or without modifications, in source and/or binary forms;
//  provided that if you redistribute the Apple Software in its entirety and
//  without modifications, you must retain this notice and the following
//  text and disclaimers in all such redistributions of the Apple Software. 
//  Neither the name, trademarks, service marks or logos of Apple Inc.
//  may be used to endorse or promote products derived from the Apple
//  Software without specific prior written permission from Apple.  Except
//  as expressly stated in this notice, no other rights or licenses, express
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
//------------------------------------------------------------------------

//------------------------------------------------------------------------

#import "OpenGLViewNSImage.h"

//------------------------------------------------------------------------

//------------------------------------------------------------------------

struct OpenGLViewNSImageAttributes
{
	CGContextRef contextRef;
	CGRect       contextFrame;
	CGImageRef   imageRef;
	NSRect       subFrame;
	BOOL         subFrameChanged;
	BOOL         invalidated;
};

typedef struct OpenGLViewNSImageAttributes  OpenGLViewNSImageAttributes;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

@implementation OpenGLViewNSImage

//------------------------------------------------------------------------

- (id) initViewNSImageWithSubFrame:(const NSRect *)theSubFrame
							  view:(NSOpenGLView *)theBaseView
{
	self = [super initViewCGImageWithSubFrame:theSubFrame
										 view:theBaseView];
	
	if( self )
	{		
		nsImageAttribs = (OpenGLViewNSImageAttributesRef)malloc(sizeof(OpenGLViewNSImageAttributes));
		
		if( nsImageAttribs != NULL )
		{
			nsImageAttribs->subFrame        = *theSubFrame;
			nsImageAttribs->subFrameChanged = YES;
			nsImageAttribs->invalidated     = NO;
			nsImageAttribs->contextFrame    = NSRectToCGRect( nsImageAttribs->subFrame );
			nsImageAttribs->contextRef      = NULL;
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL View NSImage- Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return( self );
} // initViewNSImageWithSubFrame

//------------------------------------------------------------------------

- (void) cleanUpContext
{
	if( nsImageAttribs->contextRef != NULL )
	{
		CGContextRelease( nsImageAttribs->contextRef );
	} // if
} // cleanUpContext

//------------------------------------------------------------------------

- (void) cleanUpImage
{
	if( nsImage )
	{
		[nsImage release];
		
		nsImage = nil;
	} // if
} // cleanUpImage

//------------------------------------------------------------------------

- (void) cleanUpViewImage
{
	if( nsImageAttribs != NULL )
	{
		[self cleanUpContext];

		free( nsImageAttribs );
		
		nsImageAttribs = NULL;
	} //if
	
	[self cleanUpImage];
} // cleanUpViewImage

//------------------------------------------------------------------------

- (void) dealloc
{
	// Release the nsImage
	
	[self cleanUpViewImage];
	
	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------

+ (id) viewNSImageWithSubFrame:(const NSRect *)theSubFrame
						  view:(NSOpenGLView *)theBaseView
{
	return( [[[OpenGLViewNSImage allocWithZone:[self zone]] initViewNSImageWithSubFrame:theSubFrame 
																				   view:theBaseView] autorelease] );
} // viewNSImageWithSubFrame

//------------------------------------------------------------------------

- (void) imageSetSubFrame:(const NSRect *)theSubFrame
{
	if(   ( theSubFrame->size.width  != nsImageAttribs->subFrame.size.width  ) 
	   || ( theSubFrame->size.height != nsImageAttribs->subFrame.size.height ) )
	{
		nsImageAttribs->subFrame        = *theSubFrame;
		nsImageAttribs->contextFrame    = NSRectToCGRect( nsImageAttribs->subFrame );
		nsImageAttribs->subFrameChanged = YES;
	} // if
	
	[super imageSetSubFrame:theSubFrame];
} // imageSetSubFrame

//------------------------------------------------------------------------

- (void) imageInvalidate:(const BOOL)theImageIsInvlidated
{
	nsImageAttribs->invalidated = theImageIsInvlidated;
	
	[super imageInvalidate:theImageIsInvlidated];
} // imageInvalidate

//------------------------------------------------------------------------
//
// Create a new nsImage to receive the Quartz nsImage data
//
//------------------------------------------------------------------------

- (void) imageCreateWithSubFrame
{
	[self cleanUpContext];
	[self cleanUpImage];
	
	nsImage = [[NSImage alloc] initWithSize:nsImageAttribs->subFrame.size];
	
	[nsImage lockFocus];
	
		nsImageAttribs->contextRef = (CGContextRef)[[NSGraphicsContext currentContext] graphicsPort];
	
	[nsImage unlockFocus];
	
	CGContextRetain( nsImageAttribs->contextRef );
} // imageCreateWithSubFrame

//------------------------------------------------------------------------

- (void) imageInitWithCGImage
{
	if( nsImage )
	{
		nsImageAttribs->imageRef = [self imageRef];
		
		[nsImage lockFocus];
		
			CGContextDrawImage(nsImageAttribs->contextRef, 
							   nsImageAttribs->contextFrame,
							   nsImageAttribs->imageRef);
		
		[nsImage unlockFocus];
	} // if
} // imageInitWithCGImage

//------------------------------------------------------------------------

- (NSImage *) image
{
	if( nsImageAttribs->subFrameChanged )
	{
		[self imageCreateWithSubFrame];
		[self imageInitWithCGImage];
		
		nsImageAttribs->subFrameChanged = NO;
	} // if
	else if( nsImageAttribs->invalidated )
	{
		[self imageInitWithCGImage];
		
		nsImageAttribs->invalidated = NO;
	} // else if
	
	return( nsImage );
} // image

//------------------------------------------------------------------------

@end

//------------------------------------------------------------------------

//------------------------------------------------------------------------

