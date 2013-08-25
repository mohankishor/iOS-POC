//---------------------------------------------------------------------------
//
// File: QTMediaSample.m
//
// Abstract: Utility class for managing a single movie frame, a.k.a., a
//           media sample
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
//  Copyright (c) 2009 Apple Inc., All rights reserved.
//
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#import "OpenGLTextureSourceTypes.h"
#import "OpenGLImageBuffer.h"

#import "PixelBuffer.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private Data Structures

//---------------------------------------------------------------------------

struct PixelBufferAttributes
{
	GLuint             bitsPerComponent;
	GLenum             format;				// format
	GLenum             internalFormat;		// internal format
	GLenum             type;				// OpenGL specific type
	NSSize             size;
	OpenGLImageBuffer  pixelBuffer;
};

typedef struct PixelBufferAttributes   PixelBufferAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

@implementation PixelBuffer

//---------------------------------------------------------------------------

- (void) pixelBufferCreate:(const NSSize *)theSize
{
	pixelBufferAttribs->bitsPerComponent = kTextureMaxBPS;
	pixelBufferAttribs->format           = kTextureSourceFormat;
	pixelBufferAttribs->type             = kTextureSourceType;
	pixelBufferAttribs->internalFormat   = kTextureInternalFormat;
	
	pixelBufferAttribs->size.width  = theSize->width;
	pixelBufferAttribs->size.height = theSize->height;
	
	pixelBufferAttribs->pixelBuffer.samplesPerPixel = kTextureMaxSPP;
	pixelBufferAttribs->pixelBuffer.width           = (GLuint)theSize->width;
	pixelBufferAttribs->pixelBuffer.height          = (GLuint)theSize->height;
	pixelBufferAttribs->pixelBuffer.rowBytes        = pixelBufferAttribs->pixelBuffer.width  * pixelBufferAttribs->pixelBuffer.samplesPerPixel;
	pixelBufferAttribs->pixelBuffer.size            = pixelBufferAttribs->pixelBuffer.height * pixelBufferAttribs->pixelBuffer.rowBytes;
	pixelBufferAttribs->pixelBuffer.data            = malloc( pixelBufferAttribs->pixelBuffer.size );
	
	if( pixelBufferAttribs->pixelBuffer.data == NULL )
	{
		NSLog( @">> ERROR: Pixel Buffer - Failure Allocating Memory For Pixel Buffer Data Store!" );
	} //if
} // newPixelBuffer

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

- (id) initPixelBufferWithSize:(const NSSize *)theSize
{
	self = [super init];
	
	if( self )
	{
		pixelBufferAttribs = (PixelBufferAttributesRef)malloc(sizeof(PixelBufferAttributes));
		
		if( pixelBufferAttribs != NULL )
		{
			[self pixelBufferCreate:theSize];
		} // if
		else
		{
			NSLog( @">> ERROR: Pixel Buffer - Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return( self );
} // initPixelBufferWithSize

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Dealloc Resources

//---------------------------------------------------------------------------

 - (void) cleanUpPixelBuffer
{
	if( pixelBufferAttribs != NULL )
	{
		if( pixelBufferAttribs->pixelBuffer.data != NULL )
		{
			free( pixelBufferAttribs->pixelBuffer.data );
		} // if
		
		free( pixelBufferAttribs );
		
		pixelBufferAttribs = NULL;
	} // if
} // cleanUpPixelBuffer

//---------------------------------------------------------------------------

- (void) dealloc 
{
	[self cleanUpPixelBuffer];
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Pixel Buffer Setters

//---------------------------------------------------------------------------

- (GLvoid) setSize:(const NSSize *)theSize
{
	if(		( theSize->width  != pixelBufferAttribs->size.width  ) 
	   ||	( theSize->height != pixelBufferAttribs->size.height ) )
	{
		if( pixelBufferAttribs->pixelBuffer.data != NULL )
		{
			free( pixelBufferAttribs->pixelBuffer.data );
			
			pixelBufferAttribs->pixelBuffer.data = NULL;
		} // if
				
		[self pixelBufferCreate:theSize];
	} // if
} // setSize

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Pixel Buffer Getters

//---------------------------------------------------------------------------

- (GLenum) format
{
	return( pixelBufferAttribs->format );
} // format

//---------------------------------------------------------------------------

- (GLenum) type
{
	return( pixelBufferAttribs->type );
} // type

//---------------------------------------------------------------------------

- (GLenum) internalFormat
{
	return( pixelBufferAttribs->internalFormat );
} // internalFormat

//---------------------------------------------------------------------------

- (GLuint) bitsPerComponent
{
	return( pixelBufferAttribs->bitsPerComponent );
} // bitsPerComponent

//---------------------------------------------------------------------------

- (GLuint) samplesPerPixel
{
	return( pixelBufferAttribs->pixelBuffer.samplesPerPixel );
} // samplesPerPixel

//---------------------------------------------------------------------------

- (GLuint) width
{
	return( pixelBufferAttribs->pixelBuffer.width );
} // width

//---------------------------------------------------------------------------

- (GLuint) height
{
	return( pixelBufferAttribs->pixelBuffer.height );
} // height

//---------------------------------------------------------------------------

- (GLuint) rowBytes
{
	return( pixelBufferAttribs->pixelBuffer.rowBytes );
} // rowBytes

//---------------------------------------------------------------------------

- (NSSize) dimensions
{
	return( pixelBufferAttribs->size );
} // dimensions

//---------------------------------------------------------------------------

- (GLuint) size
{
	return( pixelBufferAttribs->pixelBuffer.size );
} // size

//---------------------------------------------------------------------------

- (GLvoid *) buffer
{
	return( pixelBufferAttribs->pixelBuffer.data );
} // buffer

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Pixel Buffer Utilities

//---------------------------------------------------------------------------

- (GLvoid *) bufferCopy
{
	GLvoid *buffer = malloc( pixelBufferAttribs->pixelBuffer.size );
	
	if( buffer != NULL )
	{
		memcpy(buffer, 
			   pixelBufferAttribs->pixelBuffer.data, 
			   pixelBufferAttribs->pixelBuffer.size);
	} // if
	
	return( buffer );
} // bufferCopy

//---------------------------------------------------------------------------

- (GLvoid) update:(const GLvoid *)thePixelBuffer
{
	memcpy(pixelBufferAttribs->pixelBuffer.data, 
		   thePixelBuffer, 
		   pixelBufferAttribs->pixelBuffer.size);
} // update

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

