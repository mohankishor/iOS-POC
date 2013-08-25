//---------------------------------------------------------------------------
//
//	File: OpenGLTextureMediator.m
//
//  Abstract: Utility toolkit for managing a texture range or pbo, 
//            with a vbo
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

#import "OpenGLTextureMediator.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Enumerated Types

//---------------------------------------------------------------------------

enum OpenGLTextureMediatorUsage
{
	kOpenGLTextureMediatorUseTexture = 0,
	kOpenGLTextureMediatorUsePBO
};

typedef enum OpenGLTextureMediatorUsage OpenGLTextureMediatorUsage;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structure

//---------------------------------------------------------------------------

struct OpenGLTextureMediatorAttributes
{
	NSRect      frame;
	NSUInteger  usage;
	GLenum      type;
	GLenum      target;
	GLuint      name;
	void       *object;
};

typedef struct OpenGLTextureMediatorAttributes  OpenGLTextureMediatorAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers Definition

//---------------------------------------------------------------------------

typedef void (*OpenGLTextureUpdateFuncPtr)(const GLvoid *theImage, void *theObject);

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers Implementations

//---------------------------------------------------------------------------

static void glUpdatePBO(const GLvoid *theImage,
						void *theObject)
{
	OpenGLPBOUnpack *pbo = (OpenGLPBOUnpack *)theObject;
	
	[pbo update:theImage];
} // glUpdatePBO

//---------------------------------------------------------------------------

static void glUpdateTextureRange(const GLvoid *theImage,
								 void *theObject)
{
	OpenGLTextureRange *textureRange = (OpenGLTextureRange *)theObject;
	
	[textureRange update:theImage];
} // glUpdateTextureRange

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers

//---------------------------------------------------------------------------

static OpenGLTextureUpdateFuncPtr  glUpdateTexFuncPtr = NULL;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@implementation OpenGLTextureMediator

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

- (void) initTextureUsage:(const OpenGLTextureUsage)theTextureUsage
{
	switch( theTextureUsage )
	{
		case kOpenGLTextureUsePBOStreamDraw:
			
			textureMtrAttribs->type  = GL_STREAM_DRAW;
			textureMtrAttribs->usage = kOpenGLTextureMediatorUsePBO;
			glUpdateTexFuncPtr = &glUpdatePBO;
			break;
			
		case kOpenGLTextureUsePBOStaticDraw:
			
			textureMtrAttribs->type  = GL_STATIC_DRAW;
			textureMtrAttribs->usage = kOpenGLTextureMediatorUsePBO;
			glUpdateTexFuncPtr = &glUpdatePBO;
			break;
			
		case kOpenGLTextureUsePBODynamicDraw:
			
			textureMtrAttribs->type  = GL_DYNAMIC_DRAW;
			textureMtrAttribs->usage = kOpenGLTextureMediatorUsePBO;
			glUpdateTexFuncPtr = &glUpdatePBO;
			break;
			
		case kOpenGLTextureUseAppleSharedStorage:
			
			textureMtrAttribs->type  = GL_STORAGE_SHARED_APPLE;
			textureMtrAttribs->usage = kOpenGLTextureMediatorUseTexture;
			glUpdateTexFuncPtr = &glUpdateTextureRange;
			break;
			
		case kOpenGLTextureUseAppleCachedStorage:
		default:
			
			textureMtrAttribs->type  = GL_STORAGE_CACHED_APPLE;
			textureMtrAttribs->usage = kOpenGLTextureMediatorUseTexture;
			glUpdateTexFuncPtr = &glUpdateTextureRange;
			break;
	} // switch
} // setUsage

//---------------------------------------------------------------------------
//
// Initialize
//
//---------------------------------------------------------------------------

- (id) initTextureManager:(const OpenGLTextureUsage)theTextureUsage
{
	self = [super init];
	
	if( self )
	{
		textureMtrAttribs = (OpenGLTextureMediatorAttributesRef)malloc(sizeof(OpenGLTextureMediatorAttributes));
		
		if( textureMtrAttribs != NULL  )
		{
			textureMtrAttribs->object = nil;
			
			textureRange = nil;
			pboUnpack    = nil;
			
			[self initTextureUsage:theTextureUsage];
			
			textureMtrAttribs->frame.size.width  = 0.0f;
			textureMtrAttribs->frame.size.height = 0.0f;
			textureMtrAttribs->frame.origin.x    = 0.0f;
			textureMtrAttribs->frame.origin.y    = 0.0f;
			
			vboQuad = [OpenGLVBOQuad new];
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL Texture Controller - Failure Allocating Memory For Attributes!" );
		}  // else
	} // if
	
	return  self;
} // initTextureController

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Delete Resources

//---------------------------------------------------------------------------

- (void) dealloc 
{
	if( textureRange )
	{
		[textureRange release];
		
		textureRange = nil;
	} // if

	if( pboUnpack )
	{
		[pboUnpack release];
		
		pboUnpack = nil;
	} // if
	
	if( vboQuad )
	{
		[vboQuad release];
		
		vboQuad = nil;
	} // if
	
	if( textureMtrAttribs != NULL )
	{
		free( textureMtrAttribs );
		
		textureMtrAttribs = NULL;
	} // if
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Controller OpenGLTextureUpdateFuncPtr

//---------------------------------------------------------------------------

- (void) update:(const GLvoid *)theImage
		  frame:(const NSRect *)theFrame
{
	BOOL textureSizeChanged =		( theFrame->size.width != textureMtrAttribs->frame.size.width ) 
								||	( theFrame->size.height != textureMtrAttribs->frame.size.height );
	BOOL textureOriginChanged =		( theFrame->origin.x != textureMtrAttribs->frame.origin.x ) 
								||	( theFrame->origin.y != textureMtrAttribs->frame.origin.y );

	if( textureSizeChanged )
	{
		if( textureMtrAttribs->usage == kOpenGLTextureMediatorUseTexture )
		{
			if( textureRange )
			{
				[textureRange release];
				
				textureRange = nil;
			} // if
			
			NSRect bounds = NSMakeRect(0.0f,
									   0.0f, 
									   theFrame->size.width, 
									   theFrame->size.height);
			
			textureRange = [[OpenGLTextureRange alloc] initTextureRangeWithBounds:&bounds
																			 hint:textureMtrAttribs->type];
			
			textureMtrAttribs->object = textureRange;
			textureMtrAttribs->target = [textureRange target];
			textureMtrAttribs->name   = [textureRange name];
		} // if
		else
		{
			if( pboUnpack )
			{
				[pboUnpack release];
				
				pboUnpack = nil;
			} // if
			
			pboUnpack = [[OpenGLPBOUnpack alloc] initPBOUnpackWithSize:&theFrame->size
																 usage:textureMtrAttribs->type];

			textureMtrAttribs->object = pboUnpack;
			textureMtrAttribs->target = [pboUnpack target];
			textureMtrAttribs->name   = [pboUnpack name];
		} // else
	} // if

	glUpdateTexFuncPtr(theImage, textureMtrAttribs->object);
	
	if( textureSizeChanged || textureOriginChanged )
	{
		[vboQuad setFrame:theFrame];
	} // if
	
	textureMtrAttribs->frame = *theFrame;
} // updateTexture

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Controller Draw

//---------------------------------------------------------------------------
//
// Activate the VBO and draw a quad with a texture
//
//---------------------------------------------------------------------------

- (void) draw
{
	glEnable(textureMtrAttribs->target);
	
	glBindTexture(textureMtrAttribs->target, 
				  textureMtrAttribs->name);

	[vboQuad bind];

	glDisable(textureMtrAttribs->target);
} // draw

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
