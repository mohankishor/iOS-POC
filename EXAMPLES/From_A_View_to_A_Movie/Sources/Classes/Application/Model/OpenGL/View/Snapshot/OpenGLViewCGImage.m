//-------------------------------------------------------------------------
//
//	File: OpenGLViewCGImage.m
//
//  Abstract: Utility class for generating a CGImagRef from an 
//            OpenGL view
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
//-------------------------------------------------------------------------

//------------------------------------------------------------------------

#import "CGBitmapImageRep.h"
#import "OpenGLViewCGImage.h"

//------------------------------------------------------------------------

//------------------------------------------------------------------------

struct OpenGLViewCGImageAttributes
{
	CGBitmapImageRepRef  bitmapImageRep;
	CGImageRef           imageRef;
	NSRect               subFrame;
	BOOL                 subFrameChanged;
	BOOL                 invalidated;
};

typedef struct OpenGLViewCGImageAttributes   OpenGLViewCGImageAttributes;

//------------------------------------------------------------------------

//------------------------------------------------------------------------

@implementation OpenGLViewCGImage

//------------------------------------------------------------------------

- (id) initViewCGImageWithSubFrame:(const NSRect *)theSubFrame
							  view:(NSOpenGLView *)theBaseView
{
	self = [super initViewPixelsWithSubFrame:theSubFrame 
										view:theBaseView];
	
	if( self )
	{		
		cgImageAttribs = (OpenGLViewCGImageAttributesRef)malloc(sizeof(OpenGLViewCGImageAttributes));
		
		if( cgImageAttribs != NULL )
		{
			cgImageAttribs->subFrame        = *theSubFrame;
			cgImageAttribs->subFrameChanged = YES;
			cgImageAttribs->invalidated     = NO;
			cgImageAttribs->bitmapImageRep  = NULL; 
			cgImageAttribs->imageRef        = NULL;
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL View CGImage - Failure Allocating Memory For attributes!" );
		} // else
	} // if
	
	return( self );
} // initViewCGImageWithSubFrame

//------------------------------------------------------------------------

- (void) cleanUpBitmapImageRep
{
	if( cgImageAttribs->bitmapImageRep != NULL )
	{
		CGBitmapImageRepRelease( cgImageAttribs->bitmapImageRep );
	} // if
} // cleanUpBitmapImageRep

//------------------------------------------------------------------------

- (void) cleanUpCGImage
{
	if( cgImageAttribs->imageRef != NULL )
	{
		CGImageRelease( cgImageAttribs->imageRef );
		
		cgImageAttribs->imageRef = NULL;
	} // if
} // deallocBitmapImage

//------------------------------------------------------------------------

- (void) cleanUpViewCGImage
{
	if( cgImageAttribs != NULL )
	{
		[self cleanUpBitmapImageRep];
		[self cleanUpCGImage];
		
		free( cgImageAttribs );
		
		cgImageAttribs = NULL;
	} // if
} // cleanUpViewCGImage

//------------------------------------------------------------------------

- (void) dealloc
{
	// Release the opaque data structure
	
	[self cleanUpViewCGImage];

	// Dealloc the superclass
	
	[super dealloc];
} // dealloc

//---------------------------------------------------------------------------

+ (id) viewCGImageWithSubFrame:(const NSRect *)theSubFrame
						  view:(NSOpenGLView *)theBaseView
{
	return( [[[OpenGLViewCGImage allocWithZone:[self zone]] initViewCGImageWithSubFrame:theSubFrame 
																				   view:theBaseView] autorelease] );
} // viewCGImageWithSubFrame

//------------------------------------------------------------------------

- (void) imageSetSubFrame:(const NSRect *)theSubFrame
{
	if(   ( theSubFrame->size.width  != cgImageAttribs->subFrame.size.width  ) 
	   || ( theSubFrame->size.height != cgImageAttribs->subFrame.size.height ) )
	{
		cgImageAttribs->subFrame        = *theSubFrame;
		cgImageAttribs->subFrameChanged = YES;
	} // if
} // imageSetSubFrame

//------------------------------------------------------------------------

- (void) imageInvalidate:(const BOOL)theImageIsInvlidated
{
	cgImageAttribs->invalidated = theImageIsInvlidated;
} // imageInvalidate

//------------------------------------------------------------------------

- (NSRect) imageSubFrame
{
	return( cgImageAttribs->subFrame );
} // imageSubFrame

//------------------------------------------------------------------------

- (CGImageRef) imageRef
{
	GLvoid *imagePixels = NULL;
	
	if( cgImageAttribs->subFrameChanged )
	{		
		[self setSubFrame:&cgImageAttribs->subFrame];
		
		imagePixels = [self pixels];
		
		if( imagePixels != NULL )
		{
			[self cleanUpBitmapImageRep];
			
			cgImageAttribs->bitmapImageRep = CGBitmapImageRepCreate(&cgImageAttribs->subFrame.size,
																	imagePixels);
			
			if( cgImageAttribs->bitmapImageRep != NULL )
			{
				[self cleanUpCGImage];
				
				cgImageAttribs->imageRef = CGImageCreateFromBitmapImageRep( cgImageAttribs->bitmapImageRep );
				
				if( cgImageAttribs->imageRef != NULL )
				{
					cgImageAttribs->subFrameChanged = NO;
				} // if
			} // if
		} // if
	} // if
	else if( cgImageAttribs->invalidated )
	{
		imagePixels = [self pixels];
		
		if( imagePixels != NULL )
		{
			[self cleanUpCGImage];
			
			CGBitmapImageRepSetImage( imagePixels, cgImageAttribs->bitmapImageRep );
			
			cgImageAttribs->imageRef = CGImageCreateFromBitmapImageRep( cgImageAttribs->bitmapImageRep );
			
			if( cgImageAttribs->imageRef != NULL )
			{
				cgImageAttribs->invalidated = NO;
			} // if
		} // if
	} // else if
	
	return( cgImageAttribs->imageRef );
} // imageRef

//------------------------------------------------------------------------

@end

//------------------------------------------------------------------------

//------------------------------------------------------------------------

