//---------------------------------------------------------------------------
//
//	File: OpenGLTextureRange.m
//
//  Abstract: Utility toolkit for handling texture range (VRAM or AGP)
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
#import "OpenGLTextureRange.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------

struct OpenGLTextureRangeAttributes
{
	GLuint             name;				// texture id
	GLint              level;				// level-of-detail	number
	GLint              border;				// width of the border, either 0  or 1
	GLint              xoffset;				// x offset for texture copy
	GLint              yoffset;				// y offset for texture copy
	GLenum             target;				// e.g., texture 2D or texture rectangle
	GLenum             hint;				// type of texture storage
	GLenum             format;				// format
	GLenum             internalFormat;		// internal format
	GLenum             type;				// OpenGL specific type
	OpenGLImageBuffer  buffer;				// An image buffer
};

typedef struct OpenGLTextureRangeAttributes  OpenGLTextureRangeAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark
#pragma mark -

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation OpenGLTextureRange

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Initializations

//---------------------------------------------------------------------------

- (void) initOpenGLImageBuffer:(const NSSize *)theImageBufferSize
{
	textureRangeAttribs->buffer.samplesPerPixel = kTextureMaxSPP;
	textureRangeAttribs->buffer.width           = (GLuint)theImageBufferSize->width;
	textureRangeAttribs->buffer.height          = (GLuint)theImageBufferSize->height;
	textureRangeAttribs->buffer.rowBytes        = textureRangeAttribs->buffer.width  * textureRangeAttribs->buffer.samplesPerPixel;
	textureRangeAttribs->buffer.size            = textureRangeAttribs->buffer.height * textureRangeAttribs->buffer.rowBytes;
	textureRangeAttribs->buffer.data	        = NULL;
} // initOpenGLImageBuffer

//---------------------------------------------------------------------------
//
// The texture range hints parameters can be either of:
//
//		texture->hint = GL_STORAGE_SHARED_APPLE;  AGP
//		texture->hint = GL_STORAGE_CACHED_APPLE;  VRAM
//
// For samples-per-pixel with OpenGL type GL_UNSIGNED_INT_8_8_8_8 or 
// GL_UNSIGNED_INT_8_8_8_8_REV:
//
//		texture->buffer.samplesPerPixel = 4;
//
//---------------------------------------------------------------------------

- (void) initOpenGLTextureRange:(const NSInteger)theTextureHint
						 offset:(const NSPoint *)theTextureOffset
{
	textureRangeAttribs->name           = 0;
	textureRangeAttribs->hint           = theTextureHint;
	textureRangeAttribs->level          = 0;
	textureRangeAttribs->border         = 0;
	textureRangeAttribs->xoffset        = (GLint)theTextureOffset->x;
	textureRangeAttribs->yoffset        = (GLint)theTextureOffset->y;
	textureRangeAttribs->target         = GL_TEXTURE_RECTANGLE_ARB;
	textureRangeAttribs->format         = kTextureSourceFormat;
	textureRangeAttribs->type           = kTextureSourceType;
	textureRangeAttribs->internalFormat = kTextureInternalFormat;
} // initOpenGLTextureRange

//---------------------------------------------------------------------------

- (void) newOpenGLImageBuffer
{
	textureRangeAttribs->buffer.data = malloc(textureRangeAttribs->buffer.size);
	
	if( textureRangeAttribs->buffer.data == NULL )
	{
		NSLog( @">> ERROR: OpenGL Texture Range - Failure Allocating Memory For Local Texture Storage!" );
	} // if
} // newOpenGLImageBuffer

//---------------------------------------------------------------------------

- (void) newOpenGLTextureRange
{
	glGenTextures(1, &textureRangeAttribs->name);

	glEnable(textureRangeAttribs->target);

	glTextureRangeAPPLE(textureRangeAttribs->target, 
						textureRangeAttribs->buffer.size, 
						textureRangeAttribs->buffer.data);
	
	glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, GL_TRUE);
	
	glBindTexture(textureRangeAttribs->target, 
				  textureRangeAttribs->name);
	
	glTexParameteri(textureRangeAttribs->target, GL_TEXTURE_STORAGE_HINT_APPLE, textureRangeAttribs->hint);
	glTexParameteri(textureRangeAttribs->target, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
	glTexParameteri(textureRangeAttribs->target, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
	glTexParameteri(textureRangeAttribs->target, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(textureRangeAttribs->target, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glTexImage2D(textureRangeAttribs->target, 
				 textureRangeAttribs->level, 
				 textureRangeAttribs->internalFormat, 
				 textureRangeAttribs->buffer.width,
				 textureRangeAttribs->buffer.height, 
				 textureRangeAttribs->border, 
				 textureRangeAttribs->format, 
				 textureRangeAttribs->type, 
				 textureRangeAttribs->buffer.data);
		
	glDisable(textureRangeAttribs->target);
} // newOpenGLTextureRange

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
// Initialize
//
//---------------------------------------------------------------------------

- (id) initTextureRangeWithBounds:(const NSRect *)theTextureBounds
							 hint:(const GLint)theTextureHint
{
	self = [super init];
	
	if( self )
	{
		textureRangeAttribs = (OpenGLTextureRangeAttributesRef)malloc( sizeof(OpenGLTextureRangeAttributes) );
		
		if ( textureRangeAttribs != NULL  )
		{
			[self initOpenGLImageBuffer:&theTextureBounds->size];
			[self initOpenGLTextureRange:theTextureHint 
								  offset:&theTextureBounds->origin];
			
			[self newOpenGLImageBuffer];
			[self newOpenGLTextureRange];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Texture Range - Failure Allocating Memory For Attributes!" );
		}  // else
	} // if
	
	return( self );
} // initTextureRangeWithBounds

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Delete Resources

//---------------------------------------------------------------------------

- (void) cleanUpTexture
{
	if ( textureRangeAttribs->name )
	{
		glDeleteTextures(1, &textureRangeAttribs->name);
	} // if
} // cleanUpTexture

//---------------------------------------------------------------------------

- (void) cleanUpTextureBuffer
{
	if( textureRangeAttribs->buffer.data != NULL )
	{
		free( textureRangeAttribs->buffer.data );
		
		textureRangeAttribs->buffer.data = NULL;
	} // if
} // cleanUpTextureBuffer

//---------------------------------------------------------------------------

- (void) cleanUpTextureRange
{
	if( textureRangeAttribs )
	{
		[self cleanUpTextureBuffer];
		[self cleanUpTexture];

		free( textureRangeAttribs );
		
		textureRangeAttribs = NULL;
	} // if
} // cleanUpTextureRange

//---------------------------------------------------------------------------

- (void) dealloc 
{
	[self cleanUpTextureRange];
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Accessors

//---------------------------------------------------------------------------

- (GLenum) target
{
	return( textureRangeAttribs->target );
} // target

//---------------------------------------------------------------------------

- (GLuint) name
{
	return( textureRangeAttribs->name );
} // name

//---------------------------------------------------------------------------

- (NSDictionary *) dictionary
{
	NSArray *textureKeys
	= [NSArray arrayWithObjects:
	   @"name",
	   @"hint",
	   @"level",
	   @"border",
	   @"xoffset",
	   @"yoffset",
	   @"target",
	   @"format",
	   @"type",
	   @"internalformat",
	   @"width",
	   @"height",
	   nil];
	
	NSArray *textureObjects
	= [NSArray arrayWithObjects:
	   [NSNumber numberWithInt:textureRangeAttribs->name ],
	   [NSNumber numberWithInt:textureRangeAttribs->hint ],
	   [NSNumber numberWithInt:textureRangeAttribs->level ],
	   [NSNumber numberWithInt:textureRangeAttribs->border ],
	   [NSNumber numberWithInt:textureRangeAttribs->xoffset ],
	   [NSNumber numberWithInt:textureRangeAttribs->yoffset ],
	   [NSNumber numberWithInt:textureRangeAttribs->target ],
	   [NSNumber numberWithInt:textureRangeAttribs->format ],
	   [NSNumber numberWithInt:textureRangeAttribs->type ],
	   [NSNumber numberWithInt:textureRangeAttribs->internalFormat ],
	   [NSNumber numberWithInt:textureRangeAttribs->buffer.width ],
	   [NSNumber numberWithInt:textureRangeAttribs->buffer.height ],
	   nil];
	
	return( [[NSDictionary alloc ] initWithObjects:textureObjects 
										   forKeys:textureKeys] );
} // dictionary

//---------------------------------------------------------------------------

- (void) setOffsets:(const GLint *)theOffsets
{
	if( theOffsets != NULL )
	{
		textureRangeAttribs->xoffset = theOffsets[0];
		textureRangeAttribs->yoffset = theOffsets[1];
	} // if
} // setOffsets

//---------------------------------------------------------------------------

- (void) setHint:(const GLenum)theTextureStorageHint
{
	textureRangeAttribs->hint = theTextureStorageHint;
} // setHint

//---------------------------------------------------------------------------

- (void) setBounds:(const NSRect *)theTextureBounds
{
	GLuint width  = (GLuint)theTextureBounds->size.width;
	GLuint height = (GLuint)theTextureBounds->size.height;
	
	if(		( width  != textureRangeAttribs->buffer.width  )
	   ||	( height != textureRangeAttribs->buffer.height ) )
	{
		[self cleanUpTextureBuffer];
		[self cleanUpTexture];
		
		[self initOpenGLImageBuffer:&theTextureBounds->size];
		[self initOpenGLTextureRange:textureRangeAttribs->hint 
							  offset:&theTextureBounds->origin];
		
		[self newOpenGLImageBuffer];
		[self newOpenGLTextureRange];
	} // if
} // setBounds

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Texture Utilities

//---------------------------------------------------------------------------
//
// Update the texture
//
//---------------------------------------------------------------------------

- (void) update:(const GLvoid *)thePixels
{
	// Update the texture
	
	glEnable(textureRangeAttribs->target);
	
	glBindTexture(textureRangeAttribs->target, 
				  textureRangeAttribs->name);
	
	glTexSubImage2D(textureRangeAttribs->target, 
					textureRangeAttribs->level, 
					textureRangeAttribs->xoffset, 
					textureRangeAttribs->yoffset, 
					textureRangeAttribs->buffer.width,
					textureRangeAttribs->buffer.height,
					textureRangeAttribs->format, 
					textureRangeAttribs->type, 
					thePixels);
	
	glDisable(textureRangeAttribs->target);
} // updateWithBitmapImageRep

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
