//---------------------------------------------------------------------------
//
//	File: OpenGLPBOPackKit.m
//
//  Abstract: Utility toolkit for handling (pack) PBOs
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
//  Neither the buffer, trademarks, service marks or logos of Apple Computer,
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
#import "OpenGLVImageBuffer.h"
#import "OpenGLPBOPack.h"

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Macros

//---------------------------------------------------------------------------

#define OpenGLPBOPackCopyTypes 2

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

enum ImageBufferType
{
	kSrcImage = 0,	// Index for source image
	kDstImage,		// Index for destination image
	kFinalImage		// Index for destination image
};

typedef enum ImageBufferType ImageBufferType;

//---------------------------------------------------------------------------

enum OpenGLImageCopyBufferType
{
	kBufferIsPackedM = 0,		// Packed memory backing store
	kBufferIsPackedMVR			// Packed memory backing store, but flipped
};

typedef enum OpenGLImageCopyBufferType OpenGLImageCopyBufferType;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Data Structures

//---------------------------------------------------------------------------

struct OpenGLPBOAttributes
{
	GLuint   buffer;			// PBO id
	GLint    x;					// X origin of the image
	GLint    y;					// Y origin of the image
	GLenum   format;			// Pixel format
	GLenum   type;				// Pixel type
	GLenum   target;			// Pixel pack
	GLenum   usage;				// static, dynamic, or stream
	GLenum   access;			// Read only permission
	GLenum   mode;				// The read buffer
	GLuint   size;				// Image size
	GLuint   width;				// Image width
	GLuint   height;			// Image height
};

typedef struct OpenGLPBOAttributes  OpenGLPBOAttributes;

//---------------------------------------------------------------------------

struct OpenGLPBOPackAttributes
{
	OpenGLVImageBuffer   image[3];		// Source & destination images
	OpenGLPBOAttributes	 pbo;			// OpenGL PBO pack attributes
};

typedef struct OpenGLPBOPackAttributes   OpenGLPBOPackAttributes;

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers - Definition

//---------------------------------------------------------------------------

typedef void (*OpenGLPBOPackCopyFuncPtr)(OpenGLPBOPackAttributesRef pboPackAttribs);

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers - Implementations

//---------------------------------------------------------------------------
//
// Copy the pbo data into a pixel buffer
//
//---------------------------------------------------------------------------

static void OpenGLPBOPackCopyToMBuffer(OpenGLPBOPackAttributesRef pboPackAttribs)
{
	memcpy(pboPackAttribs->image[kFinalImage].buffer.data,
		   pboPackAttribs->image[kSrcImage].buffer.data,
		   pboPackAttribs->image[kSrcImage].size);
} // OpenGLPBOPackCopyToMBuffer

//---------------------------------------------------------------------------

static void OpenGLPBOPackCopyToMBufferVR(OpenGLPBOPackAttributesRef pboPackAttribs)
{
	vImage_Error imageError = vImageVerticalReflect_ARGB8888(&pboPackAttribs->image[kSrcImage].buffer, 
															 &pboPackAttribs->image[kFinalImage].buffer, 
															 pboPackAttribs->image[kSrcImage].flags);
	
	if( imageError != kvImageNoError )
	{
		NSLog(@">> ERROR[%ld]: OpenGL PBO Pack - Vertical reflect geometric operation!", imageError);
	} // if
} // OpenGLPBOPackCopyToMBufferVR

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Function Pointers - Array Decleration

//---------------------------------------------------------------------------

static OpenGLPBOPackCopyFuncPtr  pboPackCopyFuncPtr[OpenGLPBOPackCopyTypes] = 
									{ 
										&OpenGLPBOPackCopyToMBuffer,
										&OpenGLPBOPackCopyToMBufferVR
									};

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Private - Utilities

//---------------------------------------------------------------------------

static inline OpenGLImageCopyBufferType OpenGLImageIsFlipped( const BOOL theImageIsFlipped )
{
	return( theImageIsFlipped ? kBufferIsPackedMVR : kBufferIsPackedM );
} // OpenGLImageIsFlipped

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------

#pragma mark -

//---------------------------------------------------------------------------

@implementation OpenGLPBOPack

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark PBO Pack Initializations

//---------------------------------------------------------------------------

- (void) initOpenGLImageBuffers:(const NSSize *)thePBOSize
{
	pboPackAttribs->image[kSrcImage].flags           = kvImageNoFlags;
	pboPackAttribs->image[kSrcImage].samplesPerPixel = kTextureMaxSPP;
	pboPackAttribs->image[kSrcImage].buffer.width    = (GLuint)thePBOSize->width;
	pboPackAttribs->image[kSrcImage].buffer.height   = (GLuint)thePBOSize->height;
	pboPackAttribs->image[kSrcImage].buffer.rowBytes = pboPackAttribs->image[kSrcImage].buffer.width  * pboPackAttribs->image[kSrcImage].samplesPerPixel;
	pboPackAttribs->image[kSrcImage].size            = pboPackAttribs->image[kSrcImage].buffer.height * pboPackAttribs->image[kSrcImage].buffer.rowBytes;
	pboPackAttribs->image[kSrcImage].buffer.data     = NULL;
	
	pboPackAttribs->image[kDstImage].flags           = kvImageNoFlags;
	pboPackAttribs->image[kDstImage].samplesPerPixel = pboPackAttribs->image[kSrcImage].samplesPerPixel;
	pboPackAttribs->image[kDstImage].buffer.width    = pboPackAttribs->image[kSrcImage].buffer.width;
	pboPackAttribs->image[kDstImage].buffer.height   = pboPackAttribs->image[kSrcImage].buffer.height;
	pboPackAttribs->image[kDstImage].buffer.rowBytes = pboPackAttribs->image[kSrcImage].buffer.rowBytes;
	pboPackAttribs->image[kDstImage].size            = pboPackAttribs->image[kSrcImage].size;
	pboPackAttribs->image[kDstImage].buffer.data     = NULL;
	
	pboPackAttribs->image[kFinalImage].flags           = kvImageNoFlags;
	pboPackAttribs->image[kFinalImage].samplesPerPixel = pboPackAttribs->image[kDstImage].samplesPerPixel;
	pboPackAttribs->image[kFinalImage].buffer.width    = pboPackAttribs->image[kDstImage].buffer.width;
	pboPackAttribs->image[kFinalImage].buffer.height   = pboPackAttribs->image[kDstImage].buffer.height;
	pboPackAttribs->image[kFinalImage].buffer.rowBytes = pboPackAttribs->image[kDstImage].buffer.rowBytes;
	pboPackAttribs->image[kFinalImage].size            = pboPackAttribs->image[kDstImage].size;
	pboPackAttribs->image[kFinalImage].buffer.data     = NULL;
} // initOpenGLImageBuffers

//---------------------------------------------------------------------------
//
// Need a backing store for the final (destination) image only
//
//---------------------------------------------------------------------------

- (void) newOpenGLImageBuffer
{	
	pboPackAttribs->image[kDstImage].buffer.data = malloc(pboPackAttribs->image[kDstImage].size);
	
	if( pboPackAttribs->image[kDstImage].buffer.data == NULL )
	{
		NSLog( @">> ERROR: OpenGL PBO Pack - Failure Allocating Memory For the Image Backing Store!" );
	} // if
} // newOpenGLImageBuffer

//---------------------------------------------------------------------------

- (void) initOpenGLPBOPack:(const GLint)thePBOUsage
					  mode:(const GLenum)thePBOMode
{
	pboPackAttribs->pbo.buffer = 0;
	pboPackAttribs->pbo.target = GL_PIXEL_PACK_BUFFER;
	pboPackAttribs->pbo.usage  = thePBOUsage;
	pboPackAttribs->pbo.access = GL_READ_ONLY;
	pboPackAttribs->pbo.format = GL_BGRA;
	pboPackAttribs->pbo.type   = GL_UNSIGNED_BYTE;
	pboPackAttribs->pbo.mode   = thePBOMode;
	pboPackAttribs->pbo.x      = 0;
	pboPackAttribs->pbo.y      = 0;
	pboPackAttribs->pbo.size   = pboPackAttribs->image[kSrcImage].size;
	pboPackAttribs->pbo.width  = pboPackAttribs->image[kSrcImage].buffer.width;
	pboPackAttribs->pbo.height = pboPackAttribs->image[kSrcImage].buffer.height;
} // initOpenGLPBOPack

//---------------------------------------------------------------------------

- (void) newOpenGLPBOPack
{
	glGenBuffers(1, &pboPackAttribs->pbo.buffer);
} // newOpenGLPBOPack

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

- (id) initPBOPackWithSize:(const NSSize *)thePBOSize
					 usage:(const GLint)thePBOUsage
					  mode:(const GLenum)thePBOMode
{
	self = [super init];
	
	if( self )
	{
		pboPackAttribs = (OpenGLPBOPackAttributesRef)malloc(sizeof(OpenGLPBOPackAttributes));
		
		if( pboPackAttribs != NULL )
		{
			[self initOpenGLImageBuffers:thePBOSize];
			
			[self initOpenGLPBOPack:thePBOUsage 
							   mode:thePBOMode];
			
			[self newOpenGLImageBuffer];
			[self newOpenGLPBOPack];
		} // if
		else
		{
			NSLog( @"OpenGL PBO Pack - Failure Allocating Memory For Attributes!" );
		} // else
	} // if
	
	return  self;
} // initPBOPackWithSize

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark Dealloc all the Resources

//---------------------------------------------------------------------------

- (void) cleanUpOpenGLBuffer
{
	if( pboPackAttribs->pbo.buffer )
	{
		glDeleteBuffers( 1, &pboPackAttribs->pbo.buffer );
	} // if
} // cleanUpPBOPack

//---------------------------------------------------------------------------

- (void) cleanUpPBOPackBufferDataStore
{
	if( pboPackAttribs->image[kDstImage].buffer.data != NULL )
	{
		free( pboPackAttribs->image[kDstImage].buffer.data );
		
		pboPackAttribs->image[kDstImage].buffer.data = NULL;
	} // if
} // cleanUpPBOPackBufferDataStore

//---------------------------------------------------------------------------

- (void) cleanUpPBOPack
{
	if( pboPackAttribs != NULL )
	{
		[self cleanUpOpenGLBuffer];
		[self cleanUpPBOPackBufferDataStore];
		
		free( pboPackAttribs );
		
		pboPackAttribs = NULL;
	} // if
} // cleanUpPBOPack

//---------------------------------------------------------------------------

- (void) dealloc 
{
	[self cleanUpPBOPack];
	
    [super dealloc];
} // dealloc

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark PBO Utilities

//---------------------------------------------------------------------------

- (void) pboCopyToBufferSync:(const OpenGLImageCopyBufferType)theCopyBufferType
{
	// Copy pixels from framebuffer to PBO by using offset instead of a 
	// pointer. OpenGL should perform asynch DMA transfer, so that the
	// glReadPixels API returns immediately.
	
	glBindBuffer(pboPackAttribs->pbo.target, 
				 pboPackAttribs->pbo.buffer);
	
	glBufferData(pboPackAttribs->pbo.target,
				 pboPackAttribs->pbo.size, 
				 NULL, 
				 pboPackAttribs->pbo.usage);
	
	glReadPixels(pboPackAttribs->pbo.x, 
				 pboPackAttribs->pbo.y, 
				 pboPackAttribs->pbo.width,
				 pboPackAttribs->pbo.height, 
				 pboPackAttribs->pbo.format, 
				 pboPackAttribs->pbo.type, 
				 NULL);
	
	// Map the PBO that contain framebuffer pixels before processing it
	
	pboPackAttribs->image[kSrcImage].buffer.data = glMapBuffer(pboPackAttribs->pbo.target, 
															   pboPackAttribs->pbo.access);
	
	if( pboPackAttribs->image[kSrcImage].buffer.data != NULL )
	{
		pboPackCopyFuncPtr[theCopyBufferType](pboPackAttribs);
	} // if
	
	// Release pointer to the mapping buffer
	
	glUnmapBuffer( pboPackAttribs->pbo.target );
	
	// At this stage, it is good idea to release a PBO 
	// (with ID 0) after use. Once bound to ID 0, all 
	// pixel operations default to normal behavior.
	
	glBindBuffer( pboPackAttribs->pbo.target, 0 );
} // read

//---------------------------------------------------------------------------

- (void) read:(const BOOL)theImageIsFlipped
{
	pboPackAttribs->image[kFinalImage].buffer.data = pboPackAttribs->image[kDstImage].buffer.data;
	
	[self pboCopyToBufferSync:OpenGLImageIsFlipped(theImageIsFlipped)];
} // read

//---------------------------------------------------------------------------

- (void) copyToBuffer:(GLvoid *)theBuffer
			  flipped:(const BOOL)theImageIsFlipped
{
	if( theBuffer != NULL )
	{
		pboPackAttribs->image[kFinalImage].buffer.data = theBuffer;
	} // if
	else
	{
		pboPackAttribs->image[kFinalImage].buffer.data = pboPackAttribs->image[kDstImage].buffer.data;
	} // else
	
	[self pboCopyToBufferSync:OpenGLImageIsFlipped(theImageIsFlipped)];
} // copyToBuffer

//---------------------------------------------------------------------------

- (void) copyToPixelBuffer:(CVPixelBufferRef)thePixelBuffer
				   flipped:(const BOOL)theImageIsFlipped
{
	CVOptionFlags  lockFlags = 0;
	CVReturn       error     = CVPixelBufferLockBaseAddress(thePixelBuffer,lockFlags);
	
	if( error == kCVReturnSuccess )
	{
		pboPackAttribs->image[kFinalImage].buffer.data = CVPixelBufferGetBaseAddress(thePixelBuffer);
		
		CVPixelBufferUnlockBaseAddress(thePixelBuffer,lockFlags);
		
		pboPackAttribs->image[kFinalImage].buffer.width    = CVPixelBufferGetWidth(thePixelBuffer);
		pboPackAttribs->image[kFinalImage].buffer.height   = CVPixelBufferGetHeight(thePixelBuffer);
		pboPackAttribs->image[kFinalImage].buffer.rowBytes = CVPixelBufferGetBytesPerRow(thePixelBuffer);
		pboPackAttribs->image[kFinalImage].size            = pboPackAttribs->image[kFinalImage].buffer.rowBytes * pboPackAttribs->image[kFinalImage].buffer.height;
		
		[self pboCopyToBufferSync:OpenGLImageIsFlipped(theImageIsFlipped)];
	} // if
	else
	{
		pboPackAttribs->image[kFinalImage].buffer.data = pboPackAttribs->image[kDstImage].buffer.data;
		
		[self pboCopyToBufferSync:OpenGLImageIsFlipped(theImageIsFlipped)];
	} // else
} // copyToPixelBuffer

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark PBO Setters

//---------------------------------------------------------------------------

- (GLvoid) setMode:(const GLenum)thePBOMode
{
	pboPackAttribs->pbo.mode = thePBOMode;
} // setMode

//---------------------------------------------------------------------------

- (GLvoid) setUsage:(const GLenum)thePBOUsage
{
	pboPackAttribs->pbo.usage = thePBOUsage;
} // setUsage

//---------------------------------------------------------------------------

- (GLvoid) setSize:(const NSSize *)thePBOSize
{
	GLuint width  = (GLuint)thePBOSize->width;
	GLuint height = (GLuint)thePBOSize->height;
	
	if(		( width  != pboPackAttribs->image[kDstImage].buffer.width  ) 
	   ||	( height != pboPackAttribs->image[kDstImage].buffer.height ) )
	{
		[self cleanUpPBOPackBufferDataStore];
		[self cleanUpOpenGLBuffer];
		
		[self initOpenGLImageBuffers:thePBOSize];
		
		[self initOpenGLPBOPack:pboPackAttribs->pbo.usage 
						   mode:pboPackAttribs->pbo.mode];
		
		[self newOpenGLImageBuffer];
		[self newOpenGLPBOPack];
	} // if
} // setSize

//---------------------------------------------------------------------------

#pragma mark -
#pragma mark PBO Getters

//---------------------------------------------------------------------------

- (GLvoid *) data
{
	return( pboPackAttribs->image[kFinalImage].buffer.data );
} // data

//---------------------------------------------------------------------------

- (GLuint) size
{
	return( pboPackAttribs->image[kFinalImage].size );
} // size

//---------------------------------------------------------------------------

- (GLuint) rowbytes
{
	return( pboPackAttribs->image[kFinalImage].buffer.rowBytes );
} // size

//---------------------------------------------------------------------------

- (GLuint) samplesPerPixel
{
	return( pboPackAttribs->image[kFinalImage].samplesPerPixel );
} // samplesPerPixel

//---------------------------------------------------------------------------

- (GLuint) width
{
	return( pboPackAttribs->image[kFinalImage].buffer.width );
} // width

//---------------------------------------------------------------------------

- (GLuint) height
{
	return( pboPackAttribs->image[kFinalImage].buffer.height );
} // height

//---------------------------------------------------------------------------

@end

//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
