//---------------------------------------------------------------------------
//
//	File: OpenGLVBOQuad.m
//
//  Abstract: Utility toolkit for handling a quad VBO
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

#import "OpenGLVBOQuad.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------

struct OpenGLVBOQuadAttributes
{
	GLuint    name;			// buffer identifier
	GLuint    count;		// vertex count
	GLuint    size;			// size of vertices or texture coordinates
	GLsizei   stride;		// vbo stride
	GLuint    capacity;		// is vertex size + texture coordinate size
	GLenum    target;		// vbo target
	GLenum    usage;		// vbo usage
	GLenum    type;			// vbo type
	GLenum    mode;			// vbo mode
	GLfloat  *data;			// vbo data
	GLfloat   width;		// quad width
	GLfloat   height;		// quad height
};

typedef struct OpenGLVBOQuadAttributes  OpenGLVBOQuadAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation OpenGLVBOQuad

//---------------------------------------------------------------------------

- (void) initVBOQuad:(const NSSize *)theSize
{
	vboAttribs->count    = 4;
	vboAttribs->size     = 8 * sizeof(GLfloat);
	vboAttribs->capacity = 2 * vboAttribs->size;
	vboAttribs->target   = GL_ARRAY_BUFFER;
	vboAttribs->usage    = GL_STATIC_DRAW;
	vboAttribs->type     = GL_FLOAT;
	vboAttribs->mode     = GL_QUADS;
	vboAttribs->stride   = 0;
	vboAttribs->data     = NULL;
	vboAttribs->width    = theSize->width;
	vboAttribs->height   = theSize->height;
} // initVBOQuad

//---------------------------------------------------------------------------

- (void) newVBOQuad:(const GLfloat *)theVertices
		  texCoords:(const GLfloat *)theTexCoords
{
	glGenBuffers(1, &vboAttribs->name);
	
	glBindBuffer(vboAttribs->target, 
				 vboAttribs->name);
	
	glBufferData(vboAttribs->target, vboAttribs->capacity, NULL, vboAttribs->usage);
	glBufferSubData(vboAttribs->target, 0, vboAttribs->size, theVertices);
	glBufferSubData(vboAttribs->target, vboAttribs->size, vboAttribs->size, theTexCoords);
	
	glBindBuffer(vboAttribs->target, 0);
} // newVBOQuad

//---------------------------------------------------------------------------
//
// Initialize
//
//---------------------------------------------------------------------------

- (id) init
{
	self = [super init];
	
	if( self )
	{
		vboAttribs = (OpenGLVBOQuadAttributesRef)malloc(sizeof(OpenGLVBOQuadAttributes));
		
		if( vboAttribs != NULL )
		{
			GLfloat data[8] = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
			NSSize  size    = NSMakeSize( 0.0f, 0.0f );
			
			[self initVBOQuad:&size];
			
			[self newVBOQuad:data 
				   texCoords:data];			
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL VBO Quad - Failure Allocating Memory For Attributes!" );
			NSLog( @">>                          From the default initializer." );
		}  // else
	} // if
	
	return( self );
} // init

//---------------------------------------------------------------------------

- (id) initVBOQuadWithSize:(const NSSize *)theSize
{
	self = [super init];
	
	if( self )
	{
		vboAttribs = (OpenGLVBOQuadAttributesRef)malloc(sizeof(OpenGLVBOQuadAttributes));
		
		if( vboAttribs != NULL )
		{
			if( theSize != NULL )
			{
				GLfloat vertices[8]  = { 0.0f, 0.0f, theSize->width, 0.0f, theSize->width, theSize->height, 0.0f, theSize->height };
				GLfloat texCoords[8] = { 0.0f, theSize->height, theSize->width, theSize->height, theSize->width, 0.0f, 0.0f, 0.0f };
				
				[self initVBOQuad:theSize];
				
				[self newVBOQuad:vertices 
					   texCoords:texCoords];		
			} // if
			else
			{
				GLfloat data[8] = { 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f };
				NSSize  size    = NSMakeSize( 0.0f, 0.0f );
				
				[self initVBOQuad:&size];
				
				[self newVBOQuad:data 
					   texCoords:data];			
			} // else
		} // if
		else
		{
			NSLog( @">> ERROR: OpenGL VBO Quad - Failure Allocating Memory For Attributes!" );
			NSLog( @">>                          From the designated initializer using size." );
		}  // else
	} // if
	
	return( self );
} // initVBOWithSize

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Delete VBO

//---------------------------------------------------------------------------

- (void) cleanUpVBOQuad
{
	if( vboAttribs != NULL )
	{
		if( vboAttribs->name )
		{
			glDeleteBuffers( 1, &vboAttribs->name );
		} // if
		
		free( vboAttribs );
		
		vboAttribs = NULL;
	} // if
} // cleanUpVBOQuad

//---------------------------------------------------------------------------

- (void) dealloc 
{
	[self cleanUpVBOQuad];

    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark VBO Update

//---------------------------------------------------------------------------

- (void) setFrame:(const NSRect *)theFrame
{
	if( theFrame != NULL )
	{
		vboAttribs->width  = theFrame->origin.x + theFrame->size.width;
		vboAttribs->height = theFrame->origin.y + theFrame->size.height;

		glBindBuffer(vboAttribs->target, 
					 vboAttribs->name);
		
		glBufferData(vboAttribs->target, 
					 vboAttribs->capacity, 
					 NULL,
					 vboAttribs->usage);
		
		vboAttribs->data = (GLfloat *)glMapBuffer(vboAttribs->target, 
												  GL_READ_WRITE);
		
		if( vboAttribs->data != NULL )
		{
			// Vertices
			
			vboAttribs->data[0] = theFrame->origin.x;
			vboAttribs->data[1] = theFrame->origin.y;
			vboAttribs->data[2] = theFrame->origin.x;
			vboAttribs->data[3] = vboAttribs->height;
			vboAttribs->data[4] = vboAttribs->width;
			vboAttribs->data[5] = vboAttribs->height,
			vboAttribs->data[6] = vboAttribs->width;
			vboAttribs->data[7] = theFrame->origin.y;

			// Texture coordinates
			
			vboAttribs->data[8]  = 0.0f;
			vboAttribs->data[9]  = 0.0f;
			vboAttribs->data[10] = 0.0f;
			vboAttribs->data[11] = theFrame->size.height;
			vboAttribs->data[12] = theFrame->size.width;
			vboAttribs->data[13] = theFrame->size.height,
			vboAttribs->data[14] = theFrame->size.width;
			vboAttribs->data[15] = 0.0f;

			glUnmapBuffer(vboAttribs->target);
		} // if
		
		glBindBuffer(vboAttribs->target, 0);
	} // if
} // setFrame

//---------------------------------------------------------------------------

- (void) setSize:(const NSSize *)theSize
{
	if( theSize != NULL )
	{
		GLfloat vertices[8]  = { 0.0f, 0.0f, theSize->width, 0.0f, theSize->width, theSize->height, 0.0f, theSize->height };
		GLfloat texCoords[8] = { 0.0f, theSize->height, theSize->width, theSize->height, theSize->width, 0.0f, 0.0f, 0.0f };

		vboAttribs->width  = theSize->width;
		vboAttribs->height = theSize->height;

		glBindBuffer(vboAttribs->target, 
					 vboAttribs->name);
		
		glBufferData(vboAttribs->target, 
					 vboAttribs->capacity, 
					 NULL, 
					 vboAttribs->usage);
		
		vboAttribs->data = (GLfloat *)glMapBuffer(vboAttribs->target, 
												  GL_READ_WRITE);
		
		if( vboAttribs->data != NULL )
		{
			// Vertices
			
			vboAttribs->data[0] = vertices[0];
			vboAttribs->data[1] = vertices[1];
			vboAttribs->data[2] = vertices[2];
			vboAttribs->data[3] = vertices[3];
			vboAttribs->data[4] = vertices[4];
			vboAttribs->data[5] = vertices[5],
			vboAttribs->data[6] = vertices[6];
			vboAttribs->data[7] = vertices[7];
			
			// Texture coordinates
			
			vboAttribs->data[8]  = texCoords[0];
			vboAttribs->data[9]  = texCoords[1];
			vboAttribs->data[10] = texCoords[2];
			vboAttribs->data[11] = texCoords[3];
			vboAttribs->data[12] = texCoords[4];
			vboAttribs->data[13] = texCoords[5],
			vboAttribs->data[14] = texCoords[6];
			vboAttribs->data[15] = texCoords[7];
			
			glUnmapBuffer(vboAttribs->target);
		} // if
		
		glBindBuffer(vboAttribs->target, 0);
	} // if
} // setSize

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark VBO Draw

//---------------------------------------------------------------------------
//
// Draw a quad using texture & vertex coordinates
//
//---------------------------------------------------------------------------

- (void) bind
{
	glBindBuffer(vboAttribs->target, vboAttribs->name);
	
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnableClientState(GL_VERTEX_ARRAY);
	
	glTexCoordPointer(2, vboAttribs->type, vboAttribs->stride, BUFFER_OFFSET(vboAttribs->size));
	glVertexPointer(2, vboAttribs->type, vboAttribs->stride, BUFFER_OFFSET(0));
	
	glDrawArrays(vboAttribs->mode, 0, vboAttribs->count);
	
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);

	glBindBuffer(vboAttribs->target, 0);
} // bind

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
