//---------------------------------------------------------------------------
//
//	File: OpenGLTexture.m
//
//  Abstract: Utility toolkit for handling shader's texture
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

#import "OpenGLTexture.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structure

//---------------------------------------------------------------------------

struct OpenGLTextureAttributes
{
	GLuint    name;				// texture id
	GLint     level;			// level-of-detail	number
	GLint     border;			// width of the border, either 0  or 1
	GLint     minFilter;		// texture min filter type
	GLint     magFilter;		// texture mag filter type
	GLint     wrapS;			// texture 3D wrap s parameter
	GLint	  wrapT;			// texture 3D wrap t parameter
	GLint     wrapR;			// texture 3D wrap r parameter
	GLint     xoffset;			// offset from x (used for 1D, 2D, 3D)
	GLint     yoffset;			// offset from y (used for 2D, 3D)
	GLint     zoffset;			// offset from z (used for 3D)
	GLsizei   count;			// texture count
	GLsizei   width;			// texture width (used for 1D, 2D, 3D)
	GLsizei   height;			// texture height (used for 2D, 3D)
	GLsizei   depth;			// texture depth (used for 3D)
	GLenum    active;			// Active texture
	GLenum    target;			// e.g., texture 2D or texture rectangle
	GLenum    format;			// format
	GLenum    internalFormat;	// internal format
	GLenum    type;				// OpenGL specific type
};

typedef struct OpenGLTextureAttributes  OpenGLTextureAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@implementation OpenGLTexture

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Generating New Textures

//---------------------------------------------------------------------------

- (void) newTextureAttributesWithDictionary:(NSDictionary *)theTextureDict
{
	if( theTextureDict )
	{
		textureAttribs->active         = [[theTextureDict objectForKey:@"active"] integerValue];
		textureAttribs->count          = [[theTextureDict objectForKey:@"count"] integerValue];
		textureAttribs->target         = [[theTextureDict objectForKey:@"target"] integerValue];
		textureAttribs->level          = [[theTextureDict objectForKey:@"level"] integerValue];
		textureAttribs->internalFormat = [[theTextureDict objectForKey:@"internalformat"] integerValue];
		textureAttribs->width          = [[theTextureDict objectForKey:@"width"] integerValue];
		textureAttribs->height         = [[theTextureDict objectForKey:@"height"] integerValue];
		textureAttribs->depth          = [[theTextureDict objectForKey:@"depth"] integerValue];
		textureAttribs->border         = [[theTextureDict objectForKey:@"border"] integerValue];
		textureAttribs->format         = [[theTextureDict objectForKey:@"format"] integerValue];
		textureAttribs->type           = [[theTextureDict objectForKey:@"type"] integerValue];
		textureAttribs->wrapS          = [[theTextureDict objectForKey:@"wrapS"] integerValue];
		textureAttribs->wrapT          = [[theTextureDict objectForKey:@"wrapT"] integerValue];
		textureAttribs->wrapR          = [[theTextureDict objectForKey:@"wrapR"] integerValue];
		textureAttribs->minFilter      = [[theTextureDict objectForKey:@"min"] integerValue];
		textureAttribs->magFilter      = [[theTextureDict objectForKey:@"mag"] integerValue];
		textureAttribs->xoffset        = 0;
		textureAttribs->yoffset        = 0;
		textureAttribs->zoffset        = 0;
		textureAttribs->name           = 0;
	} // if
	else
	{ 
		NSLog( @">> ERROR: OpenGL Texture - Failure Allocating Texture Attributes due to an empty dictionary!" );
	}  // else
} // newTextureAttributesWithDictionary
 
//---------------------------------------------------------------------------

- (void) newTexture1D:(const GLvoid *)thePixels
{
	glTexImage1D(	textureAttribs->target, 
					textureAttribs->level, 
					textureAttribs->internalFormat, 
					textureAttribs->width, 
					textureAttribs->border, 
					textureAttribs->format, 
					textureAttribs->type, 
					thePixels);
} // newTexture1D

//---------------------------------------------------------------------------

- (void) newTexture2D:(const GLvoid *)thePixels
{
	glTexImage2D(textureAttribs->target, 
				 textureAttribs->level, 
				 textureAttribs->internalFormat, 
				 textureAttribs->width, 
				 textureAttribs->height, 
				 textureAttribs->border, 
				 textureAttribs->format, 
				 textureAttribs->type, 
				 thePixels);
} // newTexture2D

//---------------------------------------------------------------------------

- (void) newTexture3D:(const GLvoid *)thePixels
{
	glTexParameterf(textureAttribs->target, GL_TEXTURE_WRAP_S, textureAttribs->wrapS);
	glTexParameterf(textureAttribs->target, GL_TEXTURE_WRAP_T, textureAttribs->wrapT);
	glTexParameterf(textureAttribs->target, GL_TEXTURE_WRAP_R, textureAttribs->wrapR);
	
	glTexImage3D(textureAttribs->target, 
				 textureAttribs->level, 
				 textureAttribs->internalFormat, 
				 textureAttribs->width, 
				 textureAttribs->height, 
				 textureAttribs->depth, 
				 textureAttribs->border, 
				 textureAttribs->format, 
				 textureAttribs->type, 
				 thePixels);
} // newTexture3D

//---------------------------------------------------------------------------

- (void) newTexture:(const GLvoid *)thePixels
{
	glActiveTexture(textureAttribs->active);
	glGenTextures(textureAttribs->count, &textureAttribs->name);
	
	glEnable(textureAttribs->target);

	glTextureRangeAPPLE(textureAttribs->target, 0, NULL);
	
	glTexParameteri(textureAttribs->target, 
					GL_TEXTURE_STORAGE_HINT_APPLE, 
					GL_STORAGE_PRIVATE_APPLE);
	
	glPixelStorei(GL_UNPACK_CLIENT_STORAGE_APPLE, GL_FALSE);

	glBindTexture(textureAttribs->target, textureAttribs->name);

	glTexParameterf(textureAttribs->target, GL_TEXTURE_MAG_FILTER, textureAttribs->magFilter);
	glTexParameterf(textureAttribs->target, GL_TEXTURE_MIN_FILTER, textureAttribs->minFilter);

	switch( textureAttribs->target )
	{
		case GL_TEXTURE_1D:
			[self newTexture1D:thePixels];
			break;
		case GL_TEXTURE_RECTANGLE_EXT:
		case GL_TEXTURE_2D:
			[self newTexture2D:thePixels];
			break;
		case GL_TEXTURE_3D:
			[self newTexture3D:thePixels];
			break;
	} // switch
	
	glDisable(textureAttribs->target);
} // newTexture

//---------------------------------------------------------------------------

- (void) newTextureWithDictionary:(NSDictionary *)theTextureDict
{
	GLvoid *pixels = NULL;
	
	[self newTextureAttributesWithDictionary:theTextureDict];
	
	pixels = [self texturePixels:textureAttribs->width 
						  height:textureAttribs->height 
						   depth:textureAttribs->depth];
	
	if( pixels != NULL )
	{
		[self newTexture:pixels];
	
		free( pixels );
		
		pixels = NULL;
	} // if
} // newTextureWithDictionary

//---------------------------------------------------------------------------

- (void) newTextureWithDictionary:(NSDictionary *)theTextureDict
						   pixels:(const GLvoid *)thePixels
{
	[self newTextureAttributesWithDictionary:theTextureDict];
		
	if( thePixels != NULL )
	{
		[self newTexture:thePixels];
	} // if
} // newTextureWithDictionary

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Designated Initializers

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

- (id) initTextureWithDictionary:(NSDictionary *)theTextureDict
{
	self = [super init];
	
	if( self )
	{
		textureAttribs = (OpenGLTextureAttributesRef)malloc(sizeof(OpenGLTextureAttributes));
		
		if( textureAttribs != NULL )
		{
			[self newTextureWithDictionary:theTextureDict];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Texture - Failure Allocating Memory For Attributes!" );
			NSLog( @">>                         From the designated initializer using dictionary." );
		}  // else
	} // if
	
	return  self;
} // initTextureWithDictionary

//---------------------------------------------------------------------------

- (id) initTextureWithDictionary:(NSDictionary *)theTextureDict
						  pixels:(const GLvoid *)thePixels
{
	self = [super init];
	
	if( self )
	{
		textureAttribs = (OpenGLTextureAttributesRef)malloc(sizeof(OpenGLTextureAttributes));
		
		if( textureAttribs != NULL )
		{
			[self newTextureWithDictionary:theTextureDict 
									pixels:thePixels];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Texture - Failure Allocating Memory For Attributes!" );
			NSLog( @">>                         From the designated initializer using dictionary and pixels." );
		}  // else
	} // if
	
	return  self;
} // initTextureWithDictionary

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Delete Texture

//---------------------------------------------------------------------------

- (void) dealloc 
{
	if( textureAttribs != NULL )
	{
		if( textureAttribs->name )
		{
			glDeleteTextures( 1, &textureAttribs->name );
		} // if
	
		free( textureAttribs );
		
		textureAttribs = NULL;
	} // if
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Accessors

//---------------------------------------------------------------------------

- (BOOL) isValid
{
	return( textureAttribs->name != 0 );
} // isValid

//---------------------------------------------------------------------------

- (GLenum) target
{
	return( textureAttribs->target );
} // name

//---------------------------------------------------------------------------

- (GLuint) name
{
	return( textureAttribs->name );
} // name

//---------------------------------------------------------------------------

- (GLenum) active
{
	return( textureAttribs->active );
} // active

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Binding Texture

//---------------------------------------------------------------------------

- (void) bind
{
	glActiveTexture( textureAttribs->active );
	glBindTexture( textureAttribs->target, textureAttribs->name );
} // bind

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Data Source for Pixels

//---------------------------------------------------------------------------

- (GLvoid *) texturePixels:(const NSInteger)theTextureWidth 
					height:(const NSInteger)theTextureHeight 
					 depth:(const NSInteger)theTextureDepth
{
	return( NULL );
} // texturePixels

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
