//---------------------------------------------------------------------------
//
//	File: OpenGLPBOUnpackKit.m
//
//  Abstract: Utility toolkit for handling (unpack) PBOs
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
#import "OpenGLPBOUnpack.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------

struct OpenGLTexture
{
	GLuint  name;				// texture id
	GLint   hint;				// texture hint
	GLint   level;				// level-of-detail	number
	GLint   border;				// width of the border, either 0  or 1
	GLint   xoffset;			// x offset for texture copy
	GLint   yoffset;			// y offset for texture copy
	GLenum  target;				// e.g., texture 2D or texture rectangle
	GLenum  format;				// format
	GLenum  internalFormat;		// internal format
	GLenum  type;				// OpenGL specific type
};

typedef struct OpenGLTexture  OpenGLTexture;

//---------------------------------------------------------------------------

struct OpenGLPBO
{
	GLuint  name;		// PBO id
	GLenum  target;		// e.g., pixel pack or unpack
	GLenum  usage;		// e.g., stream draw
	GLenum  access;		// e.g., read, write, or both
};

typedef struct OpenGLPBO  OpenGLPBO;

//---------------------------------------------------------------------------

struct OpenGLPBOUnpackAttributes
{
	OpenGLImageBuffer  buffer;	// An image buffer
	OpenGLTexture      texture;	// OpenGL texture pboUnpackAttribs
	OpenGLPBO          pbo;		// OpenGL PBO pboUnpackAttribs
};

typedef struct OpenGLPBOUnpackAttributes   OpenGLPBOUnpackAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation OpenGLPBOUnpack

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark PBO Unpack Initializations

//---------------------------------------------------------------------------

- (void) initOpenGLTexture
{
	pboUnpackAttribs->texture.name           = 0;
	pboUnpackAttribs->texture.level          = 0;
	pboUnpackAttribs->texture.border         = 0;
	pboUnpackAttribs->texture.xoffset        = 0;
	pboUnpackAttribs->texture.yoffset        = 0;
	pboUnpackAttribs->texture.hint           = GL_STORAGE_PRIVATE_APPLE;
	pboUnpackAttribs->texture.target         = GL_TEXTURE_RECTANGLE_ARB;
	pboUnpackAttribs->texture.format         = kTextureSourceFormat;
	pboUnpackAttribs->texture.type           = kTextureSourceType;
	pboUnpackAttribs->texture.internalFormat = kTextureInternalFormat;
} // initOpenGLTexture
 
//---------------------------------------------------------------------------

- (void) initOpenGLImageBuffer:(const NSSize *)theImageSize
{
	pboUnpackAttribs->buffer.samplesPerPixel = kTextureMaxSPP;
	pboUnpackAttribs->buffer.width           = (GLuint)theImageSize->width;
	pboUnpackAttribs->buffer.height          = (GLuint)theImageSize->height;
	pboUnpackAttribs->buffer.rowBytes        = pboUnpackAttribs->buffer.width  * pboUnpackAttribs->buffer.samplesPerPixel;
	pboUnpackAttribs->buffer.size            = pboUnpackAttribs->buffer.height * pboUnpackAttribs->buffer.rowBytes;
	pboUnpackAttribs->buffer.data            = NULL;
} // initOpenGLImageBuffer

//---------------------------------------------------------------------------

- (void) newOpenGLTexture
{
	glGenTextures(1, &pboUnpackAttribs->texture.name);

	glEnable(pboUnpackAttribs->texture.target);

	glTextureRangeAPPLE(pboUnpackAttribs->texture.target, 0, NULL);
	glTextureRangeAPPLE(GL_TEXTURE_2D, 0, NULL);
	
	glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, GL_FALSE);

	glBindTexture(pboUnpackAttribs->texture.target, 
				  pboUnpackAttribs->texture.name);
	
	glTexParameteri(pboUnpackAttribs->texture.target, GL_TEXTURE_STORAGE_HINT_APPLE, pboUnpackAttribs->texture.hint);
	glTexParameteri(pboUnpackAttribs->texture.target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(pboUnpackAttribs->texture.target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(pboUnpackAttribs->texture.target, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(pboUnpackAttribs->texture.target, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

	glTexImage2D(pboUnpackAttribs->texture.target, 
				 pboUnpackAttribs->texture.level, 
				 pboUnpackAttribs->texture.internalFormat, 
				 pboUnpackAttribs->buffer.width,
				 pboUnpackAttribs->buffer.height, 
				 pboUnpackAttribs->texture.border, 
				 pboUnpackAttribs->texture.format,
				 pboUnpackAttribs->texture.type, 
				 NULL);
	
	glDisable(pboUnpackAttribs->texture.target);
} // newOpenGLTexture

//---------------------------------------------------------------------------

- (void) newOpenGLPBOUnpack:(const GLint)thePBOUsage
{
	pboUnpackAttribs->pbo.name   = 0;
	pboUnpackAttribs->pbo.target = GL_PIXEL_UNPACK_BUFFER;
	pboUnpackAttribs->pbo.usage  = thePBOUsage;
	pboUnpackAttribs->pbo.access = GL_WRITE_ONLY;

	glGenBuffers(1, &pboUnpackAttribs->pbo.name);
} // newOpenGLPBOUnpack

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated initializer

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

- (id) initPBOUnpackWithSize:(const NSSize *)thePBOSize
					   usage:(const GLint)thePBOUsage
{
	self = [super init];
	
	if( self )
	{
		pboUnpackAttribs = (OpenGLPBOUnpackAttributesRef)malloc(sizeof(OpenGLPBOUnpackAttributes));
		
		if( pboUnpackAttribs != NULL )
		{
			[self initOpenGLTexture];
			[self initOpenGLImageBuffer:thePBOSize];
			
			[self newOpenGLTexture];
			[self newOpenGLPBOUnpack:thePBOUsage];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL PBO Unpack - Failure Allocating Memory For Attributes!" );
		} // else
	} // self
	
	return  self;
} // initPBOUnpackWithSize

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Dealloc all the Resources

//---------------------------------------------------------------------------

- (void) cleanUpOpenGLBuffer
{
	if( pboUnpackAttribs->pbo.name )
	{
		glDeleteBuffers( 1, &pboUnpackAttribs->pbo.name );
	} // if
} // cleanUpOpenGLBuffer

//---------------------------------------------------------------------------

- (void) cleanUpOpenGLTexture
{
	if( pboUnpackAttribs->texture.name )
	{
		glDeleteTextures( 1, &pboUnpackAttribs->texture.name );
	} // if
} // cleanUpOpenGLTexture

//---------------------------------------------------------------------------

- (void) cleanUpPBOUnpack
{
	if( pboUnpackAttribs != NULL )
	{
		[self cleanUpOpenGLBuffer];
		[self cleanUpOpenGLTexture];
		
		free( pboUnpackAttribs );
		
		pboUnpackAttribs = NULL;
	} // if
} // cleanUpPBOUnpack

//---------------------------------------------------------------------------

- (void) dealloc 
{
	[self cleanUpPBOUnpack];
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark PBO Update

//---------------------------------------------------------------------------

- (void) update:(const GLvoid *)theImage
{
	// Bind the texture and PBO
	
	glBindTexture(pboUnpackAttribs->texture.target, 
				  pboUnpackAttribs->texture.name);
	
	glBindBuffer(pboUnpackAttribs->pbo.target,
				 pboUnpackAttribs->pbo.name );
	
	// If GPU is working with a buffer, glMapBuffer results in a sync
	// issue and will stall the GPU pipeline until such time the current 
	// job is processed. To avoid stalling the pipeline, one should call 
	// the API glBufferData with a NULL pointer before calling the API,
	// glMapBuffer. If you do so then the previous data in a PBO will 
	// be discarded and glMapBuffer returns a new allocated pointer 
	// immediately even thought the GPU is still processing the previous 
	// data.
	
	glBufferData(pboUnpackAttribs->pbo.target, 
				 pboUnpackAttribs->buffer.size, 
				 NULL,
				 pboUnpackAttribs->pbo.usage );
	
	pboUnpackAttribs->buffer.data = glMapBuffer(pboUnpackAttribs->pbo.target, 
												pboUnpackAttribs->pbo.access);	
	
	// Copy the pixel buffer to pbo
	
	if( pboUnpackAttribs->buffer.data != NULL )
	{
		memcpy(pboUnpackAttribs->buffer.data,
			   theImage,
			   pboUnpackAttribs->buffer.size);
	} // if
	
	// Release pointer to the mapping buffer
	
	glUnmapBuffer(pboUnpackAttribs->pbo.target);

	// Use offset instead of pointer to copy pixels from PBO 
	// to texture.
	
	glTexSubImage2D(pboUnpackAttribs->texture.target, 
					pboUnpackAttribs->texture.level, 
					pboUnpackAttribs->texture.xoffset, 
					pboUnpackAttribs->texture.yoffset, 
					pboUnpackAttribs->buffer.width, 
					pboUnpackAttribs->buffer.height, 
					pboUnpackAttribs->texture.format, 
					pboUnpackAttribs->texture.type, 
					NULL);
	
	// At this stage, it is good idea to release a PBO 
	// (with ID 0) after use. Once bound to ID 0, all 
	// pixel operations default to normal behavior.
	
	glBindBuffer(pboUnpackAttribs->pbo.target, 0);
} // updatePBO

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark PBO Setters

//---------------------------------------------------------------------------

- (GLvoid) setUsage:(const GLenum)thePBOUsage
{
	pboUnpackAttribs->pbo.usage = thePBOUsage;
} // setUsage

//---------------------------------------------------------------------------

- (GLvoid) setSize:(const NSSize *)thePBOSize
{
	GLuint width  = (GLuint)thePBOSize->width;
	GLuint height = (GLuint)thePBOSize->height;
	
	if(		( width  != pboUnpackAttribs->buffer.width  ) 
	   ||	( height != pboUnpackAttribs->buffer.height ) )
	{
		[self cleanUpOpenGLBuffer];
		[self cleanUpOpenGLTexture];

		[self initOpenGLTexture];
		[self initOpenGLImageBuffer:thePBOSize];
		
		[self newOpenGLTexture];
		[self newOpenGLPBOUnpack:pboUnpackAttribs->pbo.usage];
	} // if
} // setSize

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark PBO Getters

//---------------------------------------------------------------------------

- (GLenum) target
{
	return( pboUnpackAttribs->texture.target );
} // target

//---------------------------------------------------------------------------

- (GLuint) name
{
	return( pboUnpackAttribs->texture.name );
} // name

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
