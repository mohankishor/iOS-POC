//---------------------------------------------------------------------------
//
//	File: OpenGLFBO.m
//
//  Abstract: Utility class for managing FBOs
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

#import "OpenGLImageBuffer.h"
#import "OpenGLTextureSourceTypes.h"
#import "OpenGLFBOStatus.h"
#import "OpenGLFBO.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------

struct OpenGLTextureAttributes
{
	GLuint  name;				// texture named identifiers
	GLint   level;				// level-of-detail number
	GLint   border;				// width of the border, either 0 or 1
	GLenum  target;				// e.g., texture 2D or texture rectangle
	GLenum  hint;				// type of texture storage
	GLenum  format;				// format
	GLenum  internalFormat;		// internal format
	GLenum  type;				// OpenGL specific type
};

typedef struct OpenGLTextureAttributes  OpenGLTextureAttributes;

//---------------------------------------------------------------------------

struct OpenGLFramebufferAttributes
{
	GLuint   name;			// Framebuffer object id
	GLenum   target;		// Framebuffer target
	GLenum   attachment;	// Color attachment "n" extension
	BOOL     isValid;		// Framebuffer status
	NSSize   size;			// Framebuffer size
};

typedef struct OpenGLFramebufferAttributes  OpenGLFramebufferAttributes;

//---------------------------------------------------------------------------

struct OpenGLViewportAttributes
{
	GLint    x;			// lower left x coordinate
	GLint    y;			// lower left y coordinate
	GLsizei  width;		// viewport height
	GLsizei  height;	// viewport width
};

typedef struct OpenGLViewportAttributes  OpenGLViewportAttributes;

//---------------------------------------------------------------------------

struct OpenGLOrthoProjAttributes
{
	GLdouble left;		// left vertical clipping plane
	GLdouble right;		// right vertical clipping plane
	GLdouble bottom;	// bottom horizontal clipping plane
	GLdouble top;		// top horizontal clipping plane
	GLdouble zNear;		// nearer depth clipping plane
	GLdouble zFar;		// farther depth clipping plane
};

typedef struct OpenGLOrthoProjAttributes  OpenGLOrthoProjAttributes;

//---------------------------------------------------------------------------

struct OpenGLFBOAttributes
{
	OpenGLImageBuffer             image;			// An image buffer
	OpenGLOrthoProjAttributes     orthographic;		// fboAttribs for orthographic projection
	OpenGLViewportAttributes      viewport;			// FBO viewport dimensions
	OpenGLTextureAttributes       texture;			// Texture bound to the framebuffer
	OpenGLFramebufferAttributes   framebuffer;		// Framebuffer object
};

typedef struct OpenGLFBOAttributes  OpenGLFBOAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -- OpenGL Texture Initializations --

//---------------------------------------------------------------------------

static void InitOpenGLImageBuffer(const NSSize *theSize,
								  OpenGLFBOAttributesRef theAttributes)
{
	theAttributes->image.samplesPerPixel = kTextureMaxSPP;
	theAttributes->image.width           = (GLuint)theSize->width;
	theAttributes->image.height          = (GLuint)theSize->height;
	theAttributes->image.rowBytes        = theAttributes->image.width  * theAttributes->image.samplesPerPixel;
	theAttributes->image.size            = theAttributes->image.height * theAttributes->image.rowBytes;
	theAttributes->image.data            = NULL;
} // InitOpenGLImageBuffer

//---------------------------------------------------------------------------

static void InitOpenGLTextureAttributes(OpenGLFBOAttributesRef theAttributes)
{
	theAttributes->texture.name           = 0;
	theAttributes->texture.hint           = GL_STORAGE_PRIVATE_APPLE;
	theAttributes->texture.level          = 0;
	theAttributes->texture.border         = 0;
	theAttributes->texture.target         = GL_TEXTURE_RECTANGLE_ARB;
	theAttributes->texture.format         = kTextureSourceFormat;
	theAttributes->texture.type           = kTextureSourceType;
	theAttributes->texture.internalFormat = kTextureInternalFormat;
} // InitOpenGLTextureAttributes	

//---------------------------------------------------------------------------
	
static void InitOpenGLFramebufferAttributes(OpenGLFBOAttributesRef  theAttributes)
{
	theAttributes->framebuffer.name        = 0;
	theAttributes->framebuffer.target      = GL_FRAMEBUFFER_EXT;
	theAttributes->framebuffer.attachment  = GL_COLOR_ATTACHMENT0_EXT;
	theAttributes->framebuffer.isValid     = NO;
	theAttributes->framebuffer.size.width  = theAttributes->image.width;
	theAttributes->framebuffer.size.height = theAttributes->image.height;
} // InitOpenGLFramebufferAttributes

//---------------------------------------------------------------------------

static void InitOpenGLViewportAttributes( OpenGLFBOAttributesRef theAttributes )
{
	theAttributes->viewport.x      = 0;
	theAttributes->viewport.y      = 0;
	theAttributes->viewport.width  = theAttributes->image.width;
	theAttributes->viewport.height = theAttributes->image.height;
} // InitOpenGLViewportAttributes

//---------------------------------------------------------------------------

static void InitOpenGLOrthoProjAttributes( OpenGLFBOAttributesRef theAttributes )
{
	theAttributes->orthographic.left   =  0;
	theAttributes->orthographic.right  =  theAttributes->image.width;
	theAttributes->orthographic.bottom =  0;
	theAttributes->orthographic.top    =  theAttributes->image.height;
	theAttributes->orthographic.zNear  = -1.0;
	theAttributes->orthographic.zFar   =  1.0;
} // InitOpenGLOrthoProjAttributes

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation OpenGLFBO

//---------------------------------------------------------------------------

#pragma mark -- Initialize an OpenGL FBO --

//---------------------------------------------------------------------------

- (void) initOpenGLFrameBuffer:(const NSSize *)theFBOSize
{
	InitOpenGLImageBuffer( theFBOSize, fboAttribs );
	InitOpenGLTextureAttributes( fboAttribs );
	InitOpenGLViewportAttributes( fboAttribs );
	InitOpenGLOrthoProjAttributes( fboAttribs );
	InitOpenGLFramebufferAttributes( fboAttribs );
} // initOpenGLFrameBuffer

//---------------------------------------------------------------------------
//
// Initialize the fbo bound texture
//
//---------------------------------------------------------------------------	

- (BOOL) newOpenGLTexture
{
	BOOL textureIsBuilt = NO;
	
	glDisable(GL_TEXTURE_2D);
	glEnable(fboAttribs->texture.target);
	
	glTextureRangeAPPLE(fboAttribs->texture.target, 0, NULL);
	glTextureRangeAPPLE(GL_TEXTURE_2D, 0, NULL);
	glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, GL_FALSE);
	
	glGenTextures(1, &fboAttribs->texture.name);

	if( fboAttribs->texture.name )
	{
		glBindTexture(fboAttribs->texture.target, 
					  fboAttribs->texture.name);
		
		glTexParameteri(fboAttribs->texture.target, GL_TEXTURE_STORAGE_HINT_APPLE, GL_STORAGE_PRIVATE_APPLE);
		glTexParameteri(fboAttribs->texture.target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
		glTexParameteri(fboAttribs->texture.target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
		glTexParameteri(fboAttribs->texture.target, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
		glTexParameteri(fboAttribs->texture.target, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
		
		glTexImage2D(fboAttribs->texture.target, 
					 fboAttribs->texture.level,
					 fboAttribs->texture.internalFormat, 
					 fboAttribs->image.width, 
					 fboAttribs->image.height, 
					 fboAttribs->texture.border, 
					 fboAttribs->texture.format,
					 fboAttribs->texture.type, 
					 NULL);
		
		textureIsBuilt = YES;
	} // if
	
	glDisable(fboAttribs->texture.target);
	
	return( textureIsBuilt );
} // newOpenGLTexture

//---------------------------------------------------------------------------
//
// Initialize depth render buffer, bind to FBO before checking status
//
//---------------------------------------------------------------------------

- (void) newOpenGLFramebuffer
{	
	glGenFramebuffersEXT(1, &fboAttribs->framebuffer.name);

	if( fboAttribs->framebuffer.name )
	{
		glBindFramebufferEXT(fboAttribs->framebuffer.target, 
							 fboAttribs->framebuffer.name);
		
		glFramebufferTexture2DEXT(fboAttribs->framebuffer.target, 
								  fboAttribs->framebuffer.attachment, 
								  fboAttribs->texture.target, 
								  fboAttribs->texture.name,
								  fboAttribs->texture.level);
		
		fboAttribs->framebuffer.isValid = [[OpenGLFBOStatus statusWithFBOTarget:fboAttribs->framebuffer.target 
																		   exit:NO] framebufferComplete];
		
		glBindFramebufferEXT(fboAttribs->framebuffer.target, 0);
	} // if
} // newOpenGLFramebuffer

//---------------------------------------------------------------------------

- (void) newOpenGLFBO:(const NSSize *)theTextureSize
{
	[self initOpenGLFrameBuffer:theTextureSize];
	
	if( [self newOpenGLTexture] )
	{
		[self newOpenGLFramebuffer];
	} // if
} // newOpenGLFBO

//---------------------------------------------------------------------------
//
// Make sure client goes through designated initializer
//
//---------------------------------------------------------------------------

- (id) init
{
	[self doesNotRecognizeSelector:_cmd];
	
	return nil;
} // init

//---------------------------------------------------------------------------
//
// Initialize on startup
//
//---------------------------------------------------------------------------

- (id) initFBOWithSize:(const NSSize *)theTextureSize
{
	self = [super init];
	
	if( self )
	{
		fboAttribs = (OpenGLFBOAttributesRef)malloc(sizeof(OpenGLFBOAttributes));

		if( fboAttribs != NULL )
		{
			pboPack = [[OpenGLPBOPack alloc] initPBOPackWithSize:theTextureSize
														   usage:GL_DYNAMIC_READ
															mode:fboAttribs->framebuffer.attachment];

			[self newOpenGLFBO:theTextureSize];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL FBO - Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return( self );
} // initFBOWithSize

//---------------------------------------------------------------------------

#pragma mark -- Cleanup all the Resources --

//---------------------------------------------------------------------------

- (void) releaseOpenGLFramebuffer
{
	if( fboAttribs->framebuffer.name )
	{
		glDeleteFramebuffersEXT( 1, &fboAttribs->framebuffer.name );
	} // if
} // releaseOpenGLFramebuffer

//---------------------------------------------------------------------------

- (void) releaseOpenGLTexture
{
	if( fboAttribs->texture.name )
	{
		glDeleteTextures( 1, &fboAttribs->texture.name );
	} // if
} // releaseOpenGLTexture

//---------------------------------------------------------------------------

- (void) releaseFBO
{
	if( fboAttribs != NULL )
	{
		[self releaseOpenGLFramebuffer];
		[self releaseOpenGLTexture];
		
		free( fboAttribs );
		
		fboAttribs = NULL;
	} // if
} // releaseFBO

//---------------------------------------------------------------------------

- (void) releaseOpenGLPBOPack
{
	if( pboPack )
	{
		[pboPack release];
		
		pboPack = nil;
	} // if
} // releaseOpenGLPBOPack

//---------------------------------------------------------------------------

- (void) cleanUpFBO
{
	[self releaseOpenGLPBOPack];
	[self releaseFBO];
} // cleanUpFBO

//---------------------------------------------------------------------------

- (void) dealloc 
{
	[self cleanUpFBO];
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -- Draw into FBO --

//---------------------------------------------------------------------------
//
// Reset the current viewport
//
//---------------------------------------------------------------------------

- (void) reset
{
	glViewport(fboAttribs->viewport.x, 
			   fboAttribs->viewport.y, 
			   fboAttribs->viewport.width, 
			   fboAttribs->viewport.height );
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	glOrtho(fboAttribs->orthographic.left, 
			fboAttribs->orthographic.right, 
			fboAttribs->orthographic.bottom, 
			fboAttribs->orthographic.top, 
			fboAttribs->orthographic.zNear, 
			fboAttribs->orthographic.zFar );
	
	glMatrixMode(GL_TEXTURE);
	glLoadIdentity();
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glClear( GL_COLOR_BUFFER_BIT );
} // reset

//---------------------------------------------------------------------------
//
// Default rendering method. Must be implemented upon subclassing.
//
//---------------------------------------------------------------------------

- (void) render
{
	return;
} // render

//---------------------------------------------------------------------------
//
// Update the framebuffer by using the implementation of "render" method.
// If the shader method is not implemented, the default implementation wiil
// be used whereby, the second texture is simply bound to a quad.
//
//---------------------------------------------------------------------------

- (void) update
{
	// bind buffers and make attachment
	
	glBindFramebufferEXT(fboAttribs->framebuffer.target,
						 fboAttribs->framebuffer.name);
	
	// Write into the texture
	
	glDrawBuffer(fboAttribs->framebuffer.attachment);
	
	// reset the current viewport
	
	[self reset];
	
	// Render to texture
	
	[self render];
		
	// unbind buffer and detach

	glBindFramebufferEXT( fboAttribs->framebuffer.target, 0 );
} // update

//---------------------------------------------------------------------------

- (GLvoid *) readback
{
	// bind buffers and make attachment
	
	glBindFramebufferEXT(fboAttribs->framebuffer.target,
						 fboAttribs->framebuffer.name);
	
	// readback from the framebuffer using a pbo

	[pboPack read:NO];

	// unbind buffer and detach
	
	glBindFramebufferEXT( fboAttribs->framebuffer.target, 0 );

	// Get the PBO's pixel data
	
	fboAttribs->image.data = [pboPack data];

	return( fboAttribs->image.data );
} // readback

//---------------------------------------------------------------------------

- (void) copyToBuffer:(GLvoid *)theBuffer
{
	// bind buffers and make attachment
	
	glBindFramebufferEXT(fboAttribs->framebuffer.target,
						 fboAttribs->framebuffer.name);

	// copy pixels from the framebuffer using a pbo into
	// an allocated buffer
	
	[pboPack copyToBuffer:theBuffer 
				  flipped:NO];

	// unbind buffer and detach
	
	glBindFramebufferEXT( fboAttribs->framebuffer.target, 0 );
} // copyToBuffer

//---------------------------------------------------------------------------

- (void) copyToPixelBuffer:(CVPixelBufferRef)thePixelBuffer
{
	// bind buffers and make attachment
	
	glBindFramebufferEXT(fboAttribs->framebuffer.target,
						 fboAttribs->framebuffer.name);
	
	// copy pixels from the framebuffer using a pbo into
	// an allocated buffer
	
	[pboPack copyToPixelBuffer:thePixelBuffer 
					   flipped:YES];
	
	// unbind buffer and detach
	
	glBindFramebufferEXT( fboAttribs->framebuffer.target, 0 );
} // copyToBuffer

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark FBO Accessors

//---------------------------------------------------------------------------

- (GLuint) texture
{
	return( fboAttribs->texture.name );
} // texture

//---------------------------------------------------------------------------

- (GLenum) target
{
	return( fboAttribs->texture.target );
} // target

//---------------------------------------------------------------------------

- (GLvoid) setSize:(const NSSize *)theTextureSize
{
	GLuint width  = (GLuint)theTextureSize->width;
	GLuint height = (GLuint)theTextureSize->height;
	
	if(		( width  != fboAttribs->image.width  ) 
	   ||	( height != fboAttribs->image.height ) )
	{
		[self releaseOpenGLFramebuffer];
		[self releaseOpenGLTexture];
		
		[pboPack setSize:theTextureSize];

		[self newOpenGLFBO:theTextureSize];
	} // if
} // setSize

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
