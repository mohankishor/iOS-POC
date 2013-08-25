//---------------------------------------------------------------------------
//
//	File: OpenGLViewCaptureBase.m
//
//  Abstract: Base utility toolkit for capturing a frame from a view
// 			 
//  Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
//  Computer, Inc. ("Apple") in consideration of your agreement to the
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
//  Neither the name, trademarks, service marks or logos of Apple Computer,
//  Inc. may be used to endorse or promote products derived from the Apple
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
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#import "OpenGLTextureSourceTypes.h"
#import "OpenGLViewCaptureBase.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------

struct OpenGLViewCaptureBaseAttributes
{
	GLuint        name;				// Texture name
	GLenum        target;			// Texture target
	GLvoid       *pixels;			// Image pixels
	GLhandleARB   programObject;	// Shader object
	NSRect        subFrame;         // Image frame
};

typedef struct OpenGLViewCaptureBaseAttributes   OpenGLViewCaptureBaseAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers Definition

//---------------------------------------------------------------------------

typedef void (*OpenGLRenderFuncPtr)(OpenGLViewCaptureBaseAttributesRef theViewRecorderBaseAttribs,
									OpenGLVBOQuad *theViewQuad);

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers Implementations

//---------------------------------------------------------------------------

static void glRenderOnly(OpenGLViewCaptureBaseAttributesRef theViewRecorderBaseAttribs,
						 OpenGLVBOQuad *theViewQuad)
{
	// Enable the texture target
	
	glEnable( theViewRecorderBaseAttribs->target );
	
	// Bind to the texture
	
	glBindTexture(theViewRecorderBaseAttribs->target, 
				  theViewRecorderBaseAttribs->name);
	
	// Bind the texture to a quad
	
	[theViewQuad bind];
	
	// Unbind the texture target
	
	glBindTexture( theViewRecorderBaseAttribs->target, 0 );
	
	// Disable the texture target
	
	glDisable( theViewRecorderBaseAttribs->target );
} // glRenderOnly

//---------------------------------------------------------------------------

static void glRenderUsingRec709Shader(OpenGLViewCaptureBaseAttributesRef theViewRecorderBaseAttribs,
									  OpenGLVBOQuad *theViewQuad)
{
	// Enable the texture target
	
	glEnable( theViewRecorderBaseAttribs->target );
	
	// Enable the color correction shader
	
	glUseProgramObjectARB( theViewRecorderBaseAttribs->programObject );
	
	// Bind to the texture
	
	glBindTexture(theViewRecorderBaseAttribs->target, 
				  theViewRecorderBaseAttribs->name);
	
	// Bind the texture to a quad
	
	[theViewQuad bind];
	
	// Unbind the texture target
	
	glBindTexture( theViewRecorderBaseAttribs->target, 0 );
	
	// Disable the color correction shader
	
	glUseProgramObjectARB( NULL );
	
	// Disable the texture target
	
	glDisable( theViewRecorderBaseAttribs->target );
} // glRenderUsingRec709Shader

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers

//---------------------------------------------------------------------------

static OpenGLRenderFuncPtr  glRenderFuncPtr = NULL;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation OpenGLViewCaptureBase

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Initializations

//---------------------------------------------------------------------------

- (void) newOpenGLViewTexture
{
	NSRect bounds = NSMakeRect(0.0f,
							   0.0f, 
							   viewCaptureBaseAttribs->subFrame.size.width, 
							   viewCaptureBaseAttribs->subFrame.size.height);
	
	viewTexture = [[OpenGLViewTexture alloc] initViewTextureWithBounds:&bounds 
																  hint:GL_STORAGE_CACHED_APPLE
																buffer:GL_FRONT];
	
	if( viewTexture )
	{
		viewCaptureBaseAttribs->name   = [viewTexture name];
		viewCaptureBaseAttribs->target = [viewTexture target];
	} // if
	else
	{
		NSLog( @">> ERROR: OpenGL View Capture Base - Failure Instantiating a view texture object!" );
	} // else
} // newOpenGLViewTexture

//---------------------------------------------------------------------------

- (void) newOpenGLRec709Shader
{
	if( rec709 == nil )
	{
		rec709 = [[OpenGLRec709Shader alloc] initRec709ShaderWithBounds:&viewCaptureBaseAttribs->subFrame];
		
		if( rec709 )
		{
			viewCaptureBaseAttribs->programObject = [rec709 programObject];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL View Capture Base - Failure Instantiating Rec 709 Shader (color correction filter)!" );
		} // else
	} // if
} // newOpenGLRec709Shader

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated Initializer

//---------------------------------------------------------------------------

- (id) initViewCaptureBaseWithSubFrame:(const NSRect *)theSubFrame
{
	self = [super initFBOWithSize:&theSubFrame->size];
	
	if( self )
	{
		viewCaptureBaseAttribs = (OpenGLViewCaptureBaseAttributesRef)malloc( sizeof(OpenGLViewCaptureBaseAttributes) );
		
		if( viewCaptureBaseAttribs != NULL )
		{
			viewQuad = [[OpenGLVBOQuad alloc] initVBOQuadWithSize:&theSubFrame->size];
			
			rec709 = nil;
			
			glRenderFuncPtr = &glRenderOnly;
			
			viewCaptureBaseAttribs->pixels   = NULL;
			viewCaptureBaseAttribs->subFrame = *theSubFrame;
			
			[self newOpenGLViewTexture];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL View Capture Base - Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return( self );
} // initViewRecorderBaseWithSubFrame

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Dealloc all the Resources

//---------------------------------------------------------------------------

- (void) cleanUpCaptureBase 
{
	if( viewTexture )
	{
		[viewTexture release];
		
		viewTexture = nil;
	} // if
	
	if ( viewQuad )
	{
		[viewQuad release];
		
		viewQuad = nil;
	} // if
	
	if( rec709 )
	{
		[rec709 release];
		
		rec709 = nil;
	} // if
	
	if( viewCaptureBaseAttribs != NULL )
	{
		free( viewCaptureBaseAttribs );
		
		viewCaptureBaseAttribs = NULL;
	} // if
} // cleanUpCaptureBase

//---------------------------------------------------------------------------

- (void) dealloc 
{
	[self cleanUpCaptureBase];
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

- (void) setBounds:(const NSRect *)theBounds
{
	if(		( theBounds->size.width  != viewCaptureBaseAttribs->subFrame.size.width  )
	   ||	( theBounds->size.height != viewCaptureBaseAttribs->subFrame.size.height ) )
	{
		// FBO (its texture and readback PBO) size changed
		
		[self setSize:&theBounds->size];
		
		// VBO size changed
		
		[viewQuad setSize:&theBounds->size];
		
		// Setup the bounds for the new texture
		
		NSRect textureBounds = NSMakeRect(0.0f,
										  0.0f, 
										  theBounds->size.width, 
										  theBounds->size.height);
		
		// Texture (used for view capture) bounds changed
		
		[viewTexture setBounds:&textureBounds];
		
		// If texture bounds change, so will its ID
		
		viewCaptureBaseAttribs->name = [viewTexture name];
		
		// Set the new frame size
		
		viewCaptureBaseAttribs->subFrame = *theBounds;
		
	} // if
} // setBounds

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Frame Capture Utilities

//---------------------------------------------------------------------------

- (void) disableColorCorrection
{
	glRenderFuncPtr = &glRenderOnly;
} // disableColorCorrection

//---------------------------------------------------------------------------

- (void) enableColorCorrection
{
	[self newOpenGLRec709Shader];
	
	glRenderFuncPtr = &glRenderUsingRec709Shader;
} // enableColorCorrection

//---------------------------------------------------------------------------

- (void) render
{
	glRenderFuncPtr( viewCaptureBaseAttribs, viewQuad );
} // render

//---------------------------------------------------------------------------
//
// Readback and get the pixels from the fbo.  One can use the pixels from 
// here to generate a QuickTime movie frame.
//
//---------------------------------------------------------------------------

- (GLvoid *) captureSubFrame
{
	// Get a texture from the back buffer
	
	[viewTexture copy];
	
	// Update the fbo with the new texture using our render method
	// and with/without the rec 709 color correction unit (filter).
	
	[self update];
	
	// Readback and get the pixels from the fbo.  One can use
	// the pixels from here to generate a QuickTime movie frame.
	
	viewCaptureBaseAttribs->pixels = [self readback];
	
	return( viewCaptureBaseAttribs->pixels );
} // captureSubFrame

//---------------------------------------------------------------------------

- (GLvoid) captureSubFrameToBuffer:(GLvoid *)theBuffer
{
	// Get a texture from the read buffer
	
	[viewTexture copy];
	
	// Update the fbo with the new texture using our render method
	// and with/without the rec 709 color correction unit (filter).
	
	[self update];
	
	// Readback and copy the pixels from the fbo.  One can use
	// the pixels from here to generate a QuickTime movie frame.
	
	[self copyToBuffer:theBuffer];
} // captureSubFrameCopy

//---------------------------------------------------------------------------

- (GLvoid) captureSubFrameToPixelBuffer:(CVPixelBufferRef)thePixelBuffer
{
	// Get a texture from the back buffer
	
	[viewTexture copy];
	
	// Update the fbo with the new texture using our render method
	// and with/without the rec 709 color correction unit (filter).
	
	[self update];
	
	// Readback and copy the pixels from the fbo.  One can use
	// the pixels from here to generate a QuickTime movie frame.
	
	[self copyToPixelBuffer:thePixelBuffer];
} // captureSubFrameToPixelBuffer

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
